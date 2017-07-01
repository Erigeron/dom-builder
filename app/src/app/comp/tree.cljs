
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
  {:background-color (hsl 60 80 80),
   :display :inline-block,
   :padding "0 8px",
   :cursor :pointer})

(def style-children {:padding-left 16, :border-left (str "1px solid " (hsl 0 0 90))})

(def style-element-name
  {:background-color (hsl 260 80 50),
   :padding "0 8px",
   :display :inline-block,
   :cursor :pointer,
   :color :white,
   :line-height "1.5em",
   :font-size 12})

(defn on-focus [path] (fn [e d! m!] (println "Focus!" path)))

(defn on-append [path] (fn [e d! m!] (d! :dom-modules/append-element path)))

(defcomp
 comp-tree
 (node-tree base-path)
 (if (= :dom-module (:type node-tree))
   (let [path [(:id node-tree)]]
     (div
      {}
      (div
       {:style style-module-name, :on {:click (on-focus path)}}
       (<> span (:name node-tree) nil))
      (div {:style style-children} (comp-tree (:tree node-tree) (conj path :tree)))))
   (div
    {}
    (div
     {}
     (div
      {:style style-element-name, :on {:click (on-focus base-path)}}
      (<> span (:name node-tree) nil))
     (=< 8 nil)
     (button
      {:inner-text "Append", :style style/tiny-button, :on {:click (on-append base-path)}}))
    (div
     {:style style-children}
     (->> (:children node-tree)
          (map-indexed (fn [idx child] [idx (comp-tree child (conj base-path idx))])))))))
