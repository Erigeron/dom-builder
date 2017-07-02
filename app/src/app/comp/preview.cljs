
(ns app.comp.preview
  (:require-macros [respo.macros :refer [defcomp <> span div a]])
  (:require [hsl.core :refer [hsl]]
            [respo-ui.style :as ui]
            [respo-ui.style.colors :as colors]
            [respo.core :refer [create-comp create-element]]
            [respo.comp.space :refer [=<]]
            [app.style.layout :as layout]))

(def style-preview
  (merge {:background-color (hsl 0 0 90), :color colors/texture, :overflow :auto}))

(defn render-element [tree focused-path dom-modules path level]
  (if (and (some? tree) (< level 20))
    (if (= :dom-module (:type tree))
      (let [nested-module (get dom-modules (:id tree))]
        (recur (:tree nested-module) focused-path dom-modules [(:id tree) :tree] (inc level)))
      (create-element
       (:name tree)
       (merge
        (:props tree)
        {:style (merge
                 (:style tree)
                 (do
                  (println "compare" focused-path path)
                  (if (= focused-path path) {:outline "4px solid blue"})))})
       (->> (:children tree)
            (map-indexed
             (fn [idx child]
               [idx
                (render-element child focused-path dom-modules (conj path idx) (inc level))])))))
    nil))

(def style-close
  {:position :fixed,
   :top 8,
   :right 8,
   :z-index 999,
   :font-size 12,
   :font-family "Josefin Sans",
   :cursor :pointer,
   :color (hsl 0 0 20 0.5)})

(defn on-close [e d! m!] (d! :router/change {:name :home, :data nil}))

(defcomp
 comp-preview
 (tree dom-modules path)
 (div
  {:style (merge ui/center ui/fullscreen style-preview)}
  (div {:style style-close, :on {:click on-close}} (<> span "Close" nil))
  (if (some? tree)
    (render-element (:tree tree) path dom-modules [(first path) :tree] 0)
    (<> span "nothing" nil))))
