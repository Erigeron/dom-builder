
(ns server.schema )

(def user
  {:name nil,
   :id nil,
   :nickname nil,
   :avatar nil,
   :password nil,
   :focus {:module nil, :path []}})

(def router {:name nil, :title nil, :data {}, :router nil})

(def configs {:storage-key "/data/cumulo/workflow-storage.edn", :port 5021})

(def database {:sessions {}, :users {}, :dom-modules {}})

(def session
  {:user-id nil,
   :id nil,
   :nickname nil,
   :router {:name :home, :data nil, :router nil},
   :focus {:module nil, :path []},
   :notifications []})

(def notification {:id nil, :kind nil, :text nil})

(def element {:type :element, :name :div, :props {}, :style {}, :children []})

(def dom-module {:type :dom-module, :name "empty", :id nil, :tree nil})
