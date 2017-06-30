
(ns app.comp.editor
  (:require-macros [respo.macros :refer [defcomp <> span div a]])
  (:require [hsl.core :refer [hsl]]
            [app.schema :as schema]
            [respo-ui.style :as ui]
            [respo-ui.style.colors :as colors]
            [respo.core :refer [create-comp]]
            [respo.comp.space :refer [=<]]
            [app.style.layout :as layout]
            [app.comp.dom-modules :refer [comp-dom-modules]]
            [app.comp.preview :refer [comp-preview]]
            [app.comp.props :refer [comp-props]]
            [app.comp.style :refer [comp-style]]))

(def style-editor (merge (:grid layout/editor) {:padding "0 16px"}))

(defcomp
 comp-editor
 (dom-tree dom-modules)
 (div
  {:style style-editor}
  (comp-dom-modules dom-modules)
  (comp-preview dom-tree)
  (comp-props nil)
  (comp-style nil)))
