
(ns app.comp.header
  (:require-macros [respo.macros :refer [defcomp <> span div]])
  (:require [hsl.core :refer [hsl]]
            [respo-ui.style :as ui]
            [respo-ui.style.colors :as colors]
            [respo.core :refer [create-comp]]
            [app.style.layout :as layout]))

(defn on-profile [e dispatch!]
  (dispatch! :router/change {:name :profile, :params nil, :router nil}))

(def style-pointer {:cursor "pointer"})

(def style-header
  (merge
   (:header layout/workspace)
   (:grid layout/header)
   {:height 48,
    :background-color colors/motif,
    :padding "0 16px",
    :font-size 16,
    :color :white}))

(defn on-home [e d! m!] (d! :router/change {:name :home, :data nil, :router nil}))

(defn on-preview [e d! m!] (d! :router/change {:name :preview, :data nil, :router nil}))

(defcomp
 comp-header
 (logged-in?)
 (div
  {:style style-header}
  (div
   {:on {:click on-home}, :style (merge (:logo layout/header) {:cursor :pointer})}
   (<> span "Cumulo" nil))
  (div
   {:on {:click on-preview}, :style (merge (:logo layout/editor) {:cursor :pointer})}
   (<> span "Preview" nil))
  (div
   {:style (merge (:profile layout/header) style-pointer), :on {:click on-profile}}
   (<> span (if logged-in? "Me" "Guest") nil))))
