
(ns app.style (:require [respo-ui.style :as ui] [hsl.core :refer [hsl]]))

(def click
  {:text-decoration :underline,
   :font-familze "Josefin Sans",
   :font-size 13,
   :font-weight 300,
   :cursor :pointer,
   :outline :none,
   :color (hsl 240 90 60)})

(def title {:font-family "Josefin Sans", :font-size 20, :font-weight 100})
