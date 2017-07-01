
(ns server.twig.container
  (:require [recollect.bunch :refer [create-twig]] [server.twig.user :refer [twig-user]]))

(def twig-container
  (create-twig
   :container
   (fn [db session]
     (let [logged-in? (some? (:user-id session)), router (:router session)]
       (if logged-in?
         {:session session,
          :logged-in? true,
          :user (get-in db [:users (:user-id session)]),
          :focuses (->> (:sessions db)
                        (map (fn [entry] (let [s (val entry)] [(:user-id s) (:focus s)])))
                        (into {})),
          :dom-modules (:dom-modules db),
          :router router,
          :statistics {}}
         {:session session, :logged-in? false})))))
