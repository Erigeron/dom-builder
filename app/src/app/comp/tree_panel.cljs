
(ns app.comp.tree-panel
  (:require-macros [respo.macros :refer [defcomp <> span code div a button]])
  (:require [hsl.core :refer [hsl]]
            [respo-ui.style :as ui]
            [respo-ui.style.colors :as colors]
            [respo.core :refer [create-comp]]
            [respo.comp.space :refer [=<]]
            [app.style.layout :as layout]
            [app.style :as style]
            [app.comp.tree :refer [comp-tree]]))

(def style-panel {:overflow :auto})

(defn on-delete [path] (fn [e d! m!] (d! :dom-modules/delete-element path)))

(defn on-append [path] (fn [e d! m!] (d! :dom-modules/append-element path)))

(defcomp
 comp-tree-panel
 (dom-modules focus)
 (let [tree-node (get dom-modules (:module focus)), path (:path focus)]
   (div
    {:style (merge (:tree layout/editor) style-panel)}
    (div
     {}
     (button
      {:inner-text "Append", :style style/tiny-button, :on {:click (on-append path)}})
     (=< 8 nil)
     (button
      {:inner-text "Delete", :style style/tiny-button, :on {:click (on-delete path)}}))
    (div {} (<> code path nil))
    (comp-tree tree-node [] (:path focus)))))
