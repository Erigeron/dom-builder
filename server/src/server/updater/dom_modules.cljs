
(ns server.updater.dom-modules
  (:require [server.schema :as schema] [server.util :refer [expand-tree-path]]))

(defn append-element [db op-data session-id op-id op-time]
  (let [path (get-in db [:sessions session-id :focus :path])]
    (if (< (count path) 2)
      (do (.warn js/console "Invalid path:" (clj->js path)) db)
      (let [data-path (expand-tree-path path)]
        (-> db
            (update-in
             data-path
             (fn [element]
               (update
                element
                :children
                (fn [children]
                  (conj children (merge schema/element {:name (keyword op-data)})))))))))))

(defn delete-element [db op-data session-id op-id op-time]
  (if (< (count op-data) 3) (.warn js/console "Invalid path:" (clj->js op-data)))
  (let [data-path (expand-tree-path (drop-last 1 op-data)), last-idx (last op-data)]
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

(defn rename-element [db op-data session-id op-id op-time]
  (let [path (get-in db [:sessions session-id :focus :path])]
    (update-in
     db
     (expand-tree-path path)
     (fn [element] (assoc element :name (keyword op-data))))))

(defn set-style [db op-data session-id op-id op-time]
  (let [path (get-in db [:sessions session-id :focus :path])]
    (update-in
     db
     (expand-tree-path path)
     (fn [element]
       (update
        element
        :style
        (fn [style]
          (if (some? (:value op-data))
            (assoc style (:prop op-data) (:value op-data))
            (dissoc style (:prop op-data)))))))))

(defn focus [db op-data session-id op-id op-time]
  (assoc-in db [:sessions session-id :focus :path] op-data))

(defn choose [db op-data session-id op-id op-time]
  (assoc-in db [:sessions session-id :focus :module] op-data))

(defn insert-module [db op-data session-id op-id op-time]
  (let [path (get-in db [:sessions session-id :focus :path])
        nested-module (get-in db [:dom-modules op-data])]
    (if (< (count path) 2)
      (do (.warn js/console "Invalid path:" (clj->js path)) db)
      (let [data-path (expand-tree-path path)]
        (-> db
            (update-in
             data-path
             (fn [element]
               (update
                element
                :children
                (fn [children] (conj children (dissoc nested-module :tree)))))))))))

(defn create [db op-data session-id op-id op-time]
  (let [new-module (merge
                    schema/dom-module
                    {:id op-id, :name op-data, :tree (merge schema/element {:name :div})})]
    (assoc-in db [:dom-modules op-id] new-module)))

(defn set-prop [db op-data session-id op-id op-time]
  (let [path (get-in db [:sessions session-id :focus :path])]
    (update-in
     db
     (expand-tree-path path)
     (fn [element]
       (update
        element
        :props
        (fn [props]
          (if (some? (:value op-data))
            (assoc props (:prop op-data) (:value op-data))
            (dissoc props (:prop op-data)))))))))

(defn delete-module [db op-data session-id op-id op-time]
  (let [module-id (get-in db [:sessions session-id :focus :module])]
    (update db :dom-modules (fn [dom-modules] (dissoc dom-modules module-id)))))
