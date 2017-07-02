
(ns app.comp.preview
  (:require-macros [respo.macros :refer [defcomp <> span div a]])
  (:require [hsl.core :refer [hsl]]
            [respo-ui.style :as ui]
            [respo-ui.style.colors :as colors]
            [respo.core :refer [create-comp create-element]]
            [respo.comp.space :refer [=<]]
            [app.style.layout :as layout]))

(def style-preview
  (merge
   (:preview layout/editor)
   {:background-color (hsl 0 0 90), :padding 8, :color colors/texture, :overflow :auto}))

(defn render-element [tree focused-path path]
  (if (some? tree)
    (if (= :dom-module (:type tree))
      (recur (:tree tree) focused-path (conj path :tree))
      (create-element
       (:name tree)
       (merge
        (:props tree)
        {:style (merge (:style tree) (if (= focused-path path) {:outline "4px solid blue"}))})
       (->> (:children tree)
            (map-indexed
             (fn [idx child] [idx (render-element child focused-path (conj path idx))])))))
    nil))

(defcomp
 comp-preview
 (tree path)
 (div
  {:style (merge ui/center style-preview)}
  (if (some? tree) (render-element tree path [(first path)]) (<> span "nothing" nil))))
