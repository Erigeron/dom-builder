
(ns server.updater.dom-modules (:require [server.schema :as schema]))

(defn create [db op-data session-id op-id op-time]
  (let [new-module (merge
                    schema/dom-module
                    {:id op-id, :name op-data, :tree (merge schema/element {:name :div})})]
    (assoc-in db [:dom-modules op-id] new-module)))

(defn choose [db op-data session-id op-id op-time]
  (assoc-in db [:sessions session-id :focus :module] op-data))

(defn append-element [db op-data session-id op-id op-time]
  (if (< (count op-data) 2) (.warn js/console "Invalid path:" (clj->js op-data)))
  (let [initial-path (concat [:dom-modules (first op-data) :tree])
        children-path (mapcat (fn [idx] [:children idx]) (drop 2 op-data))
        data-path (concat initial-path children-path)]
    (println data-path)
    (-> db
        (update-in
         data-path
         (fn [element]
           (update element :children (fn [children] (conj children (merge schema/element)))))))))
