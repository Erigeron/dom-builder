
(ns app.comp.tree-panel
  (:require-macros [respo.macros :refer [defcomp <> span div a]])
  (:require [hsl.core :refer [hsl]]
            [respo-ui.style :as ui]
            [respo-ui.style.colors :as colors]
            [respo.core :refer [create-comp]]
            [respo.comp.space :refer [=<]]
            [app.style.layout :as layout]
            [app.comp.tree :refer [comp-tree]]))

(defcomp
 comp-tree-panel
 (dom-modules focus)
 (let [tree-node (get dom-modules (:module focus))]
   (div {:style (:tree layout/editor)} (<> span tree-node nil))))
