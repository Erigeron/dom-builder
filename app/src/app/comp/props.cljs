
(ns app.comp.props
  (:require-macros [respo.macros :refer [defcomp <> span div a input]])
  (:require [hsl.core :refer [hsl]]
            [respo-ui.style :as ui]
            [respo-ui.style.colors :as colors]
            [respo.core :refer [create-comp]]
            [respo.comp.space :refer [=<]]
            [app.style.layout :as layout]))

(defn on-input [e d! m!] (m! (:value e)))

(defcomp
 comp-props
 (states props path)
 (let [state (or (:data states) "")]
   (div
    {:style (:props layout/editor)}
    (div {})
    (div
     {}
     (input
      {:placeholder "key: value", :value state, :style ui/input, :on {:input on-input}})))))
