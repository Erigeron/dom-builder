
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
    (-> db
        (update-in
         data-path
         (fn [element]
           (update element :children (fn [children] (conj children (merge schema/element)))))))))

(defn focus [db op-data session-id op-id op-time]
  (assoc-in db [:sessions session-id :focus :path] op-data))

(defn delete-element [db op-data session-id op-id op-time]
  (if (< (count op-data) 3) (.warn js/console "Invalid path:" (clj->js op-data)))
  (let [initial-path (concat [:dom-modules (first op-data) :tree])
        children-path (mapcat
                       (fn [idx] [:children idx])
                       (->> op-data (drop 2) (drop-last 1)))
        data-path (concat initial-path children-path)
        last-idx (last op-data)]
    (-> db
        (update-in
         data-path
         (fn [element]
           (update
            element
            :children
            (fn [children]
              (vec (concat (take last-idx children) (drop (inc last-idx) children)))))))
        (assoc-in [:sessions session-id :focus :path] (vec (drop-last 1 op-data))))))
