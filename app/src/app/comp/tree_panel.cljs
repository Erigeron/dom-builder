
(ns app.comp.tree-panel
  (:require-macros [respo.macros :refer [defcomp <> span code div a button input]])
  (:require [clojure.string :as string]
            [hsl.core :refer [hsl]]
            [respo-ui.style :as ui]
            [respo-ui.style.colors :as colors]
            [respo.core :refer [create-comp]]
            [respo.comp.space :refer [=<]]
            [app.style.layout :as layout]
            [app.style :as style]
            [app.comp.tree :refer [comp-tree]]))

(def style-panel {:overflow :auto, :padding 8})

(defn on-delete [path] (fn [e d! m!] (d! :dom-modules/delete-element path)))

(defn on-append [el-name]
  (fn [e d! m!]
    (d! :dom-modules/append-element (if (string/blank? el-name) "div" el-name))
    (m! "")))

(defn on-input [e d! m!] (m! (:value e)))

(defn on-rename [text] (fn [e d! m!] (d! :dom-modules/rename-element text) (m! "")))

(defn on-before [el-name] (fn [e d! m!] (d! :dom-modules/before-element el-name) (m! "")))

(defcomp
 comp-tree-panel
 (states dom-modules focus)
 (let [state (or (:data states) "")
       tree-node (get dom-modules (:module focus))
       path (:path focus)]
   (div
    {:style (merge (:tree layout/editor) style-panel)}
    (div {} (<> code path nil))
    (div
     {}
     (input
      {:placeholder "Element, defaults to \"div\"",
       :value state,
       :style ui/input,
       :on {:input on-input}})
     (=< 8 nil)
     (a {:inner-text "Append", :style style/click, :on {:click (on-append state)}})
     (=< 8 nil)
     (a {:inner-text "Before", :style style/click, :on {:click (on-before state)}})
     (=< 8 nil)
     (a {:inner-text "Rename", :style style/click, :on {:click (on-rename state)}})
     (=< 8 nil)
     (a {:inner-text "Delete", :style style/click, :on {:click (on-delete path)}}))
    (=< nil 16)
    (if (some? tree-node) (comp-tree tree-node [(:id tree-node)] path)))))
