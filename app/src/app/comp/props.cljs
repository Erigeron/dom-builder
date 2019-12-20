
(ns app.comp.props
  (:require-macros [respo.macros :refer [defcomp list-> <> span div a input]])
  (:require [clojure.string :as string]
            [hsl.core :refer [hsl]]
            [respo-ui.style :as ui]
            [respo-ui.style.colors :as colors]
            [respo.core :refer [create-comp]]
            [respo.comp.space :refer [=<]]
            [app.style.layout :as layout]
            [app.style :as style]))

(defn on-click [k v] (fn [e d! m!] (m! (str (name k) ": " v))))

(defn on-input [e d! m!] (m! (:value e)))

(defn on-keydown [text]
  (fn [e d! m!]
    (if (and (= 13 (:key-code e)) (not (string/blank? text)))
      (let [[k v] (map string/trim (string/split text (re-pattern ":\\s?")))]
        (d! :dom-modules/set-prop {:prop (keyword k), :value (if (string/blank? v) nil v)})
        (m! "")))))

(def style-input {:font-size 12, :font-family "Menlo,monospace"})

(def style-line
  {:cursor :pointer, :font-family "Menlo, monospace", :font-size 12, :padding-left 8})

(defcomp
 comp-props
 (states props path)
 (let [state (or (:data states) "")]
   (div
    {:style (:props layout/editor)}
    (<> span "Props" style/title)
    (list->
     :div
     {}
     (->> props
          (map
           (fn [entry]
             (let [[k v] entry]
               [k
                (div
                 {:style style-line, :on {:click (on-click k v)}}
                 (<> span (str (name k) ":") nil)
                 (=< 8 nil)
                 (<> span v nil))])))))
    (div
     {}
     (input
      {:placeholder "prop: value",
       :value state,
       :style (merge ui/input style-input),
       :on {:input on-input, :keydown (on-keydown state)}})))))
