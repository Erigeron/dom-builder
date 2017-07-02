
(ns app.comp.dom-modules
  (:require-macros [respo.macros :refer [defcomp <> span div a input button]])
  (:require [clojure.string :as string]
            [hsl.core :refer [hsl]]
            [respo-ui.style :as ui]
            [respo-ui.style.colors :as colors]
            [respo.core :refer [create-comp]]
            [respo.comp.space :refer [=<]]
            [app.style.layout :as layout]))

(def style-insert
  {:text-decoration :underline,
   :font-size 12,
   :vertical-align :middle,
   :color (hsl 240 50 70),
   :cursor :pointer})

(defn on-input [e d! m!] (m! (:value e)))

(defn on-choose [module-id] (fn [e d! m!] (d! :dom-modules/choose module-id)))

(defn on-insert [module-id] (fn [e d! m!] (d! :dom-modules/insert-module module-id)))

(def style-list {:background-color (hsl 0 0 90), :overflow :auto})

(def style-highlight {:font-weight :bold})

(defn on-delete [e d! m!] (d! :dom-modules/delete-module nil))

(def style-entry {:padding "0 8px", :cursor :pointer})

(defn on-create [text]
  (fn [e d! m!] (if (not (string/blank? text)) (do (d! :dom-modules/create text) (m! "")))))

(defcomp
 comp-dom-modules
 (states dom-modules focus)
 (let [state (or (:data states) "")]
   (div
    {:style (merge (:grid layout/modules-panel) (:modules layout/editor))}
    (div
     {:style (merge (:list layout/modules-panel) style-list)}
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
                 (span
                  {:inner-text "insert", :style style-insert, :on {:click (on-insert k)}}))])))))
    (div
     {:style (:control layout/modules-panel)}
     (div
      {}
      (input
       {:value state, :placeholder "module name", :style ui/input, :on {:input on-input}}))
     (div
      {}
      (button
       {:inner-text "Create module", :style ui/button, :on {:click (on-create state)}})
      (=< 8 nil)
      (button {:inner-text "Rename module", :style ui/button})
      (=< 8 nil)
      (button {:inner-text "Delete", :style ui/button, :on {:click on-delete}}))))))
