
(ns app.comp.preview
  (:require-macros [respo.macros :refer [defcomp <> span div a]])
  (:require [hsl.core :refer [hsl]]
            [respo-ui.style :as ui]
            [respo-ui.style.colors :as colors]
            [respo.core :refer [create-comp]]
            [respo.comp.space :refer [=<]]
            [app.style.layout :as layout]))

(def style-preview
  (merge
   (:preview layout/editor)
   {:background-color (hsl 0 0 90), :padding 8, :color colors/texture, :overflow :auto}))

(defcomp comp-preview (tree) (div {:style style-preview} (<> span "Preview" nil)))
