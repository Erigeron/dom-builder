
(ns server.twig.user (:require [recollect.twig :refer [create-twig]]))

(def twig-user (create-twig :user (fn [user] (dissoc user :password))))
