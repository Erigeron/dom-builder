
(ns app.comp.preview
  (:require [hsl.core :refer [hsl]]
            [respo-ui.style :as ui]
            [respo-ui.style.colors :as colors]
            [respo.core :refer [create-comp create-element create-list-element]]
            [respo.macros :refer [defcomp list-> <> span div a]]
            [respo.comp.space :refer [=<]]
            [app.style.layout :as layout]))

(defn on-close [e d! m!] (d! :router/change {:name :home, :data nil}))

(def style-highlight {:outline (str "1px dashed " (hsl 240 80 70))})

(defn render-element [tree paths dom-modules path level]
  (if (and (some? tree) (< level 20))
    (if (= :dom-module (:type tree))
      (let [nested-module (get dom-modules (:id tree))]
        (recur (:tree nested-module) paths dom-modules [(:id tree) :tree] (inc level)))
      (create-list-element
       (:name tree)
       (merge
        (:props tree)
        {:style (merge (:style tree) (if (contains? paths path) style-highlight))})
       (->> (:children tree)
            (map-indexed
             (fn [idx child]
               [idx (render-element child paths dom-modules (conj path idx) (inc level))])))))
    (span {})))

(def style-close
  {:position :fixed,
   :top 8,
   :right 8,
   :z-index 999,
   :font-size 12,
   :font-family "Josefin Sans",
   :cursor :pointer,
   :color (hsl 0 0 20 0.5)})

(def style-missing {:font-family "Josefin Sans", :font-weight 100, :font-size 32})

(def style-preview
  (merge {:background-color (hsl 0 0 90), :color colors/texture, :overflow :auto}))

(defcomp
 comp-preview
 (tree dom-modules module-id focuses)
 (let [paths (->> focuses (map (fn [entry] (:path (last entry)))) (into #{}))]
   (div
    {:style (merge ui/center ui/fullscreen style-preview)}
    (div {:style style-close, :on {:click on-close}} (<> span "Close" nil))
    (if (some? tree)
      (render-element (:tree tree) paths dom-modules [module-id :tree] 0)
      (<> span "No tree is found" style-missing)))))
