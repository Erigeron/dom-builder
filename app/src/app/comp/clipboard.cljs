
(ns app.comp.clipboard
  (:require-macros [respo.macros :refer [defcomp <> span div a]])
  (:require [hsl.core :refer [hsl]]
            [respo-ui.style :as ui]
            [respo-ui.style.colors :as colors]
            [respo.core :refer [create-comp]]
            [respo.comp.space :refer [=<]]
            [app.style :as style]))

(def style-nothing {:font-family "Josefin Sans", :font-size 14, :color (hsl 0 0 50)})

(def style-el-name {:color :white, :background-color (hsl 240 80 60), :padding "0 8px"})

(defn on-append [e d! m!] (d! :dom-modules/clipboard-append nil))

(defn on-before [e d! m!] (d! :dom-modules/clipboard-before nil))

(defcomp
 comp-clipboard
 (piece)
 (div
  {}
  (if (some? piece)
    (<> span (str (name (:name piece)) ":" (count (:children piece))) style-el-name)
    (<> span "Nothing here..." style-nothing))
  (=< 8 nil)
  (a {:inner-text "Append", :style style/click, :on {:click on-append}})
  (=< 8 nil)
  (a {:inner-text "Before", :style style/click, :on {:click on-before}})))
