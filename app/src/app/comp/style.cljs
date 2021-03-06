
(ns app.comp.style
  (:require-macros [respo.macros :refer [defcomp <> span div a input]])
  (:require [clojure.string :as string]
            [hsl.core :refer [hsl]]
            [respo-ui.style :as ui]
            [respo-ui.style.colors :as colors]
            [respo.core :refer [create-comp create-list-element]]
            [respo.comp.space :refer [=<]]
            [app.style.layout :as layout]
            [app.style :as style]))

(defn on-click [k v] (fn [e d! m!] (m! (str (name k) ": " v))))

(defn on-input [e d! m!] (m! (:value e)))

(defn on-keydown [text]
  (fn [e d! m!]
    (let [[k v] (map string/trim (string/split text (re-pattern ":\\s?")))]
      (if (and (= 13 (:key-code e)) (not (string/blank? k)))
        (do
         (d!
          :dom-modules/set-style
          {:prop (keyword k), :value (if (string/blank? v) nil v)})
         (m! ""))))))

(def style-input {:font-size 12, :font-family "Menlo,monospace"})

(def style-line
  {:cursor :pointer, :font-family "Menlo, monospace", :font-size 12, :padding-left 8})

(defcomp
 comp-style
 (states style-map path)
 (let [state (or (:data states) "")]
   (div
    {:style (:style layout/editor)}
    (<> span "Style" style/title)
    (create-list-element
     :div
     {}
     (->> style-map
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
      {:value state,
       :placeholder "prop: value",
       :style (merge ui/input style-input),
       :on {:input on-input, :keydown (on-keydown state)}})))))
