
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
    :padding "0 16px",
    :font-size 16,
    :color (hsl 0 0 40),
    :font-weight 100,
    :font-family "Josefin Sans",
    :border-bottom (str "1px solid " (hsl 0 0 90))}))

(defn on-home [e d! m!] (d! :router/change {:name :home, :data nil, :router nil}))

(defn on-preview [e d! m!] (d! :router/change {:name :preview, :data nil, :router nil}))

(defcomp
 comp-header
 (logged-in?)
 (div
  {:style style-header}
  (div
   {:on {:click on-home}, :style (merge (:logo layout/header) {:cursor :pointer})}
   (<> span "Builder" nil))
  (div
   {:on {:click on-preview}, :style (merge (:logo layout/editor) {:cursor :pointer})}
   (<> span "Preview" nil))
  (div
   {:style (merge (:profile layout/header) style-pointer), :on {:click on-profile}}
   (<> span (if logged-in? "Profile" "Guest") nil))))
