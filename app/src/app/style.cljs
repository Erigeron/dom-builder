
(ns app.style (:require [respo-ui.style :as ui]))

(def tiny-button
  (merge ui/button {:font-size 12, :line-height 1.4, :padding "0 8px", :min-width 40}))
