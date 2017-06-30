
(ns app.comp.dom-modules
  (:require-macros [respo.macros :refer [defcomp <> span div a input button]])
  (:require [clojure.string :as string]
            [hsl.core :refer [hsl]]
            [respo-ui.style :as ui]
            [respo-ui.style.colors :as colors]
            [respo.core :refer [create-comp]]
            [respo.comp.space :refer [=<]]
            [app.style.layout :as layout]))

(def style-list {:background-color (hsl 0 0 90), :overflow :auto})

(defn on-input [e d! m!] (m! (:value e)))

(defn on-create [text]
  (fn [e d! m!] (if (not (string/blank? text)) (do (d! :dom-modules/create text) (m! "")))))

(defn on-choose [module-id] (fn [e d! m!] (d! :dom-modules/choose module-id)))

(defcomp
 comp-dom-modules
 (states dom-modules)
 (let [state (or (:data states) "")]
   (div
    {:style (merge (:grid layout/modules-panel) (:modules layout/editor))}
    (div
     {:style (merge (:list layout/modules-panel) style-list)}
     (->> dom-modules
          (map
           (fn [entry]
             [(key entry)
              (let [m (val entry)]
                (div {:inner-text (:name m), :on {:click (on-choose (:id m))}}))]))))
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
      (button {:inner-text "Rename module", :style ui/button})
      (button {:inner-text "Delete", :style ui/button}))))))
