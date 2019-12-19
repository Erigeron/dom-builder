
(ns app.comp.dom-modules
  (:require-macros [respo.macros :refer [defcomp list-> <> span div a input button]])
  (:require [clojure.string :as string]
            [hsl.core :refer [hsl]]
            [respo-ui.style :as ui]
            [respo-ui.style.colors :as colors]
            [respo.core :refer [create-comp]]
            [respo.comp.space :refer [=<]]
            [app.style.layout :as layout]
            [app.style :as style]))

(defn on-choose [module-id] (fn [e d! m!] (d! :dom-modules/choose module-id)))

(defn on-create [text]
  (fn [e d! m!] (if (not (string/blank? text)) (do (d! :dom-modules/create text) (m! "")))))

(defn on-delete [e d! m!] (d! :dom-modules/delete-module nil))

(defn on-input [e d! m!] (m! (:value e)))

(defn on-insert [module-id] (fn [e d! m!] (d! :dom-modules/insert-module module-id)))

(def style-entry {:padding "0 8px", :cursor :pointer})

(def style-highlight {:background-color (hsl 240 40 96)})

(def style-list {:overflow :auto, :max-height 400})

(defn render-module-list [dom-modules focus]
  (list->
   :div
   {:style (merge style-list)}
   (->> dom-modules
        (map
         (fn [entry]
           (let [[k m] entry]
             [k
              (div
               {:style (merge style-entry (if (= k (:module focus)) style-highlight)),
                :on {:click (on-choose (:id m))}}
               (<> span (:name m) nil)
               (=< 8 nil)
               (span {:inner-text "insert", :style style/click, :on {:click (on-insert k)}}))]))))))

(defcomp
 comp-dom-modules
 (states dom-modules focus)
 (let [state (or (:data states) "")]
   (div
    {:style (merge (:modules layout/editor))}
    (<> span "Modules" style/title)
    (render-module-list dom-modules focus)
    (=< nil 8)
    (div
     {:style {}}
     (div
      {}
      (input
       {:value state, :placeholder "module name", :style ui/input, :on {:input on-input}}))
     (div
      {}
      (a {:inner-text "Create", :style style/click, :on {:click (on-create state)}})
      (=< 8 nil)
      (a {:inner-text "Rename", :style style/click})
      (=< 8 nil)
      (a {:inner-text "Delete", :style style/click, :on {:click on-delete}}))))))
