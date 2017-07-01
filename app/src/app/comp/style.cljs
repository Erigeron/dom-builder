
(ns app.comp.style
  (:require-macros [respo.macros :refer [defcomp <> span div a input]])
  (:require [hsl.core :refer [hsl]]
            [respo-ui.style :as ui]
            [respo-ui.style.colors :as colors]
            [respo.core :refer [create-comp]]
            [respo.comp.space :refer [=<]]
            [app.style.layout :as layout]))

(defn on-input [e d! m!] (m! (:value 1)))

(defcomp
 comp-style
 (states style-map path)
 (let [state (or (:data states) "")]
   (div
    {:style (:style layout/editor)}
    (div {})
    (div
     {}
     (input
      {:value state, :placeholder "key: value", :style ui/input, :on {:input on-input}})))))
