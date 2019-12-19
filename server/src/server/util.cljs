
(ns server.util )

(defn expand-tree-path [path]
  (let [initial-path (concat [:dom-modules (first path) :tree])
        children-path (mapcat (fn [idx] [:children idx]) (drop 2 path))
        data-path (concat initial-path children-path)]
    (vec data-path)))

(defn find-first [f xs] (reduce (fn [_ x] (when (f x) (reduced x))) nil xs))

(defn log-js! [& args]
  (apply js/console.log (map (fn [x] (if (coll? x) (clj->js x) x)) args)))

(defn try-verbosely! [x] (try x (catch js/Error e (.log js/console e))))
