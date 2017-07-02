
(ns server.util )

(defn find-first [f xs] (reduce (fn [_ x] (when (f x) (reduced x))) nil xs))

(defn expand-tree-path [path]
  (let [initial-path (concat [:dom-modules (first path) :tree])
        children-path (mapcat (fn [idx] [:children idx]) (drop 2 path))
        data-path (concat initial-path children-path)]
    (vec data-path)))
