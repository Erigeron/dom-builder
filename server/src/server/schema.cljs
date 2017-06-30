
(ns server.schema )

(def user {:name nil, :id nil, :nickname nil, :avatar nil, :password nil})

(def router {:name nil, :title nil, :data {}, :router nil})

(def configs {:storage-key "/data/cumulo/workflow-storage.edn", :port 5021})

(def element {:type :element, :name :div, :props {}, :style {}, :children []})

(def database
  {:sessions {}, :users {}, :dom-modules {}, :dom-tree (assoc element :name :div)})

(def session
  {:user-id nil,
   :id nil,
   :nickname nil,
   :router {:name :home, :data nil, :router nil},
   :notifications []})

(def notification {:id nil, :kind nil, :text nil})

(def dom-module {:type :dom-module, :name :empty, :tree nil})
