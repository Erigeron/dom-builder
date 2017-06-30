
(ns server.updater.dom-modules (:require [server.schema :as schema]))

(defn create [db op-data session-id op-id op-time]
  (let [new-module (merge
                    schema/dom-module
                    {:id op-id, :name op-data, :tree (merge schema/element {:name :div})})]
    (assoc-in db [:dom-modules op-id] new-module)))

(defn choose [db op-data session-id op-id op-time]
  (assoc-in db [:sessions session-id :focus :module] op-data))
