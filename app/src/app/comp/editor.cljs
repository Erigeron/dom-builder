
(ns app.comp.editor
  (:require-macros [respo.macros :refer [defcomp cursor-> <> span div a]])
  (:require [hsl.core :refer [hsl]]
            [app.schema :as schema]
            [respo-ui.style :as ui]
            [respo-ui.style.colors :as colors]
            [respo.core :refer [create-comp]]
            [respo.comp.space :refer [=<]]
            [app.style.layout :as layout]
            [app.comp.tree-panel :refer [comp-tree-panel]]
            [app.comp.preview :refer [comp-preview]]
            [app.comp.props :refer [comp-props]]
            [app.comp.style :refer [comp-style]]
            [app.comp.dom-modules :refer [comp-dom-modules]]))

(def style-editor (merge (:grid layout/editor) {:padding "0 16px"}))

(defcomp
 comp-editor
 (states dom-modules focus)
 (div
  {:style style-editor}
  (comp-preview nil)
  (cursor-> :modules comp-dom-modules states dom-modules focus)
  (comp-tree-panel dom-modules focus)
  (cursor-> :props comp-props states nil (:path focus))
  (cursor-> :style comp-style states nil (:path focus))))
