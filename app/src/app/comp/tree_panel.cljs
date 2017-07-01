
(ns app.comp.tree-panel
  (:require-macros [respo.macros :refer [defcomp <> span div a]])
  (:require [hsl.core :refer [hsl]]
            [respo-ui.style :as ui]
            [respo-ui.style.colors :as colors]
            [respo.core :refer [create-comp]]
            [respo.comp.space :refer [=<]]
            [app.style.layout :as layout]
            [app.comp.tree :refer [comp-tree]]))

(def style-panel {:overflow :auto})

(defcomp
 comp-tree-panel
 (dom-modules focus)
 (let [tree-node (get dom-modules (:module focus))]
   (div {:style (merge (:tree layout/editor) style-panel)} (comp-tree tree-node []))))
