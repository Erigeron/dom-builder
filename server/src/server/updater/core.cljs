
(ns server.updater.core
  (:require [server.updater.session :as session]
            [server.updater.user :as user]
            [server.updater.router :as router]
            [server.updater.dom-modules :as dom-modules]))

(defn updater [db op op-data session-id op-id op-time]
  (case op
    :session/connect (session/connect db op-data session-id op-id op-time)
    :session/disconnect (session/disconnect db op-data session-id op-id op-time)
    :user/log-in (user/log-in db op-data session-id op-id op-time)
    :user/sign-up (user/sign-up db op-data session-id op-id op-time)
    :user/log-out (user/log-out db op-data session-id op-id op-time)
    :session/remove-notification
      (session/remove-notification db op-data session-id op-id op-time)
    :router/change (router/change db op-data session-id op-id op-time)
    :dom-modules/create (dom-modules/create db op-data session-id op-id op-time)
    :dom-modules/choose (dom-modules/choose db op-data session-id op-id op-time)
    :dom-modules/append-element
      (dom-modules/append-element db op-data session-id op-id op-time)
    :dom-modules/delete-element
      (dom-modules/delete-element db op-data session-id op-id op-time)
    :dom-modules/rename-element
      (dom-modules/rename-element db op-data session-id op-id op-time)
    :dom-modules/focus (dom-modules/focus db op-data session-id op-id op-time)
    :dom-modules/set-style (dom-modules/set-style db op-data session-id op-id op-time)
    :dom-modules/set-prop (dom-modules/set-prop db op-data session-id op-id op-time)
    (do (println "Unhandled op:" (str op)) db)))
