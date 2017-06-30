
(ns app.comp.dom-modules
  (:require-macros [respo.macros :refer [defcomp <> span div a]])
  (:require [hsl.core :refer [hsl]]
            [respo-ui.style :as ui]
            [respo-ui.style.colors :as colors]
            [respo.core :refer [create-comp]]
            [respo.comp.space :refer [=<]]
            [app.style.layout :as layout]))

(defcomp
 comp-dom-modules
 (dom-modules)
 (div {:style (:modules layout/editor)} (<> span "Modules" nil)))
