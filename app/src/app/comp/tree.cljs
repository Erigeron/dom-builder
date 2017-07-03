
(ns app.comp.tree
  (:require-macros [respo.macros :refer [defcomp <> span div a button]])
  (:require [hsl.core :refer [hsl]]
            [respo-ui.style :as ui]
            [respo-ui.style.colors :as colors]
            [respo.core :refer [create-comp]]
            [respo.comp.space :refer [=<]]
            [app.style.layout :as layout]
            [app.style :as style]))

(def style-module-name
  {:background-color (hsl 40 80 60),
   :color :white,
   :display :inline-block,
   :padding "0 8px",
   :cursor :pointer,
   :line-height "1.6em",
   :font-size 12,
   :margin 1})

(def style-children {:padding-left 16, :border-left (str "1px solid " (hsl 0 0 90))})

(def style-element-name
  {:background-color (hsl 260 80 80),
   :padding "0 8px",
   :margin 1,
   :display :inline-block,
   :cursor :pointer,
   :color :white,
   :line-height "1.5em",
   :font-size 12})

(defn on-focus [path] (fn [e d! m!] (d! :dom-modules/focus path)))

(def style-focus {:outline (str "1px dashed " (hsl 240 80 60))})

(defcomp
 comp-tree
 (node-tree base-path focus-path)
 (case (:type node-tree)
   :dom-module
     (div
      {}
      (div
       {:style (merge style-module-name (if (= base-path focus-path) style-focus)),
        :on {:click (on-focus base-path)}}
       (<> span (:name node-tree) nil))
      (div
       {:style style-children}
       (if (contains? node-tree :tree)
         (comp-tree (:tree node-tree) [(:id node-tree) :tree] focus-path))))
   :element
     (div
      {}
      (div
       {}
       (div
        {:style (merge style-element-name (if (= base-path focus-path) style-focus)),
         :on {:click (on-focus base-path)}}
        (let [el-name (:name node-tree)]
          (<>
           span
           (if (string? el-name)
             (subs el-name 1)
             (if (keyword? el-name) (name el-name) (do (println "nil" node-tree) "nil")))
           nil))))
      (div
       {:style style-children}
       (->> (:children node-tree)
            (map-indexed
             (fn [idx child] [idx (comp-tree child (conj base-path idx) focus-path)])))))
   (<> span "nothing" nil)))
