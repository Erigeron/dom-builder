
{}
  :about "|Machine-generated snapshot. Do not edit directly — changes will be overwritten. Use `calcit query` to inspect and `calcit edit`/`calcit tree` to modify. Run `calcit docs agents --contract` before mutations; use `--full` for first orientation or changed contract digest. Manual edits must follow format and schema conventions, then run `calcit edit format`."
  :package |app
  :entries $ {}
    :default $ {} (:description |) (:init-fn 'app.main/main!) (:mode :js) (:reload-fn 'app.main/reload!) (:target :browser)
      :feature-policy $ {}
      :modules $ [] |respo.calcit/ |respo-ui.calcit/ |ws-edn.calcit/ |calcit-wss/ |calcit.std/
      :type-slots $ {} $ :dispatch-op 'app.schema/Action
    :server $ {} (:description |) (:init-fn 'app.server/main!) (:mode :js) (:reload-fn 'app.server/reload!)
      :feature-policy $ {}
      :modules $ [] |ws-edn.calcit/ |calcit-wss/ |calcit.std/ |js-ffi/
      :type-slots $ {}
  :files $ {}
    'app.main $ %{} 'FileEntry
      :defs $ {}
        '*store $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def *store
            ref $ model/new-store
          :examples $ []
        'connect! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn connect! ()
            ws-edn.client/ws-connect-typed! |ws://localhost:6001
              ws-edn.client/ClientConfig :retry-base-ms None :retry-max-ms None :retry-jitter None :heartbeat-timeout-ms None :class-mapper $ {}
              ws-edn.client/ClientCallbacks :on-open (Some on-ws-open) :on-close (Some on-ws-close) :on-error None :on-data $ Some on-server-data
            , &unit
          :examples $ []
          :schema $ quote $ Fn (-> Unit) (:features :io :js-ffi :state)
        'dispatch! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn dispatch! (op)
            let
                action $ decode-map-as op $ Map Tag Dynamic
                next $ next-store @*store action
              reset! *store next
              ws-send! $ {} (:kind :store) (:data next)
              render-app!
          :examples $ []
          :schema $ quote $ Fn Dynamic (-> Unit) (:features :io :js-ffi :state)
        'main! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn main! () (connect!) (render-app!) &unit
          :examples $ []
          :schema $ quote $ Fn (-> Unit) (:features :io :js-ffi :state)
        'mount-target $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def mount-target (query-selector |.app)
          :examples $ []
          :schema $ quote $ Option js-ffi.browser/DomElementHost
        'next-store $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn next-store (store op)
            let
                t $ .unwrap-or (get op :type) |
              if (= t :select)
                model/store-select store $ model/ensure-list $ .unwrap-or (get op :path) ([])
                if (= t :add) (model/store-add-child store)
                  if (= t :delete) (model/store-delete store)
                    if (= t :tag)
                      model/store-set-tag store $ turn-tag $ .unwrap-or (get op :value) |div
                      if (= t :prop)
                        model/store-set-prop store
                          turn-tag $ str $ .unwrap-or (get op :key) |class
                          str $ .unwrap-or (get op :value) |
                        if (= t :style)
                          model/store-set-style store
                            turn-tag $ str $ .unwrap-or (get op :key) |color
                            str $ .unwrap-or (get op :value) |
                          if (= t :new-module) (model/store-new-module store)
                            if (= t :select-module)
                              model/store-select-module store $ str $ .unwrap-or (get op :module) |main
                              if (= t :preview)
                                assoc store :preview? $ not $ .unwrap-or (get store :preview?) false
                                , store
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) (Map Tag Dynamic)
            -> $ Map Tag Dynamic
            :features :js-ffi
        'on-respo-action $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn on-respo-action (action) &unit
          :examples $ []
          :schema $ quote $ Fn app.schema/Action (-> Unit)
        'on-server-data $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn on-server-data (data)
            let
                t $ .unwrap-or (get data :kind) |
              if (= t :store)
                do
                  reset! *store $ decode-map-as
                    .unwrap-or (get data :data) ({})
                    Map Tag Dynamic
                  swap! *store $ fn (store) (assoc store :connected? true)
                  render-app!
                , &unit
          :examples $ []
          :schema $ quote $ Fn Dynamic (-> Unit) (:features :io :js-ffi :state)
        'on-ws-close $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn on-ws-close (event)
            swap! *store $ fn (store) (assoc store :connected? false)
            render-app!
          :examples $ []
          :schema $ quote $ Fn js-ffi.browser/EventHost (-> Unit) (:features :io :js-ffi :state)
        'on-ws-open $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn on-ws-open (event)
            swap! *store $ fn (store) (assoc store :connected? true)
            render-app!
          :examples $ []
          :schema $ quote $ Fn js-ffi.browser/EventHost (-> Unit) (:features :io :js-ffi :state)
        'reload! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn reload! ()
            if (nil? build-errors) (render-app!) (println build-errors)
            , &unit
          :examples $ []
          :schema $ quote $ Fn (-> Unit) (:features :io :js-ffi :state)
        'render-app! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn render-app! ()
            render-with!
              narrow-element $ .unwrap mount-target
              fn () $ view/comp-app
                fn (op) (dispatch! op)
                , @*store
              , on-respo-action
          :examples $ []
          :schema $ quote $ Fn (-> Unit) (:features :io :js-ffi :state)
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.main
          :require
            respo.core :refer $ render-with!
            respo.ffi.browser :refer $ narrow-element
            js-ffi.browser :refer $ query-selector
            app.model :as model
            app.view :as view
            ws-edn.client :refer $ ws-connect! ws-send!
            |./calcit.build-errors :default build-errors
    'app.model $ %{} 'FileEntry
      :defs $ {}
        'append-child $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn append-child (tree path child)
            update-node tree path $ fn (node)
              assoc node :children $ conj
                ensure-list $ .unwrap-or (get node :children) ([])
                , child
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) (List Dynamic) (Map Tag Dynamic)
            -> $ Map Tag Dynamic
            :features :js-ffi
        'delete-node $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn delete-node (tree path)
            if (empty? path) tree $ let
                parent-path $ slice path 0 $ Some
                  - (count path) 1
                raw-idx $ .unwrap $ last path
                idx $ if (number? raw-idx) raw-idx 0
              update-node tree parent-path $ fn (node)
                assoc node :children $ remove-index
                  ensure-list $ .unwrap-or (get node :children) ([])
                  , idx
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) (List Dynamic)
            -> $ Map Tag Dynamic
            :features :js-ffi
          :tests $ [] $ %{} 'TestEntry (:name |nested-delete-preserves-other-nodes)
            :code $ quote $ let
                first-child $ {} $ :id |first
                second-child $ {} $ :id |second
                branch $ {} (:id |branch)
                  :children $ [] first-child second-child
                other $ {} $ :id |other
                tree $ {} $ :children ([] branch other)
                expected $ {} $ :children
                  []
                    {} (:id |branch)
                      :children $ [] second-child
                    , other
              assert= expected $ delete-node tree $ [] 0 0
              assert= tree $ delete-node tree $ []
            :tags $ #{} :portable
        'ensure-list $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn ensure-list (x)
            if (list? x) x $ []
          :examples $ []
          :schema $ quote $ Fn Dynamic
            -> $ List Dynamic
        'get-node $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn get-node (tree path)
            if (empty? path) tree $ let
                raw-idx $ .unwrap $ first path
                idx $ if (number? raw-idx) raw-idx 0
                children $ unsafe-coerce
                  .unwrap-or (get tree :children) ([])
                  List Dynamic
                child $ nth children idx
                tail $ if (list? path) (rest path) ([])
              recur
                decode-map-as child $ Map Tag Dynamic
                , tail
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) Dynamic
            -> $ Map Tag Dynamic
            :features :js-ffi
        'new-node $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn new-node ()
            {} (:type :element) (:tag :div)
              :props $ {}
              :style $ {}
              :children $ []
          :examples $ []
          :schema $ quote $ Fn
            -> $ Map Tag Dynamic
        'new-store $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn new-store ()
            {} (:modules {}) (:focus {}) (:preview? false) (:connected? false)
              :modules $ {} $ |main
                {} (:id |main) (:name |Main)
                  :tree $ new-node
              :focus $ {} (:module |main)
                :path $ []
          :examples $ []
          :schema $ quote $ Fn
            -> $ Map Tag Dynamic
        'remove-index $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn remove-index (xs idx)
            -> xs
              map-indexed $ fn (i x)
                if (= i idx) None $ Some x
              .filter $ fn (item) (.some? item)
              .map $ fn (item) (.unwrap item)
          :examples $ []
          :schema $ quote $ Fn (List T) Number
            -> $ List T
            :generics T
          :tests $ [] $ %{} 'TestEntry (:name |preserves-elements-and-index)
            :code $ quote $ do
              assert= ([] |a |c)
                remove-index ([] |a |b |c) 1
              assert= ([] 1 3)
                remove-index ([] 1 2 3) 1
              assert= ([] nil |b)
                remove-index ([] nil |b) 5
              assert= ([] 1 2)
                remove-index ([] 1 2) -1
              assert= ([] 1 2)
                remove-index ([] 1 2) 0.5
              assert= ([])
                remove-index ([]) 0
            :tags $ #{} :portable
        'set-prop $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn set-prop (tree path k v)
            update-node tree path $ fn (node)
              assoc node :props $ assoc
                .unwrap-or (get node :props) ({})
                , k v
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) (List Dynamic) Tag String
            -> $ Map Tag Dynamic
        'set-style $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn set-style (tree path k v)
            update-node tree path $ fn (node)
              assoc node :style $ assoc
                .unwrap-or (get node :style) ({})
                , k v
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) (List Dynamic) Tag String
            -> $ Map Tag Dynamic
        'set-tag $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn set-tag (tree path tag)
            update-node tree path $ fn (node) (assoc node :tag tag)
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) (List Dynamic) Tag
            -> $ Map Tag Dynamic
        'store-add-child $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn store-add-child (store)
            let
                path $ ensure-list $ .unwrap-or
                  get
                    .unwrap-or (get store :focus) ({})
                    , :path
                  []
                tree $ decode-map-as
                  .unwrap-or
                    get (store-module store) :tree
                    {}
                  Map Tag Dynamic
              store-with-tree store $ append-child tree path $ new-node
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic)
            -> $ Map Tag Dynamic
            :features :js-ffi
          :tests $ [] $ %{} 'TestEntry (:name |initial-module-accepts-edit)
            :code $ quote $ let
                next $ store-add-child $ new-store
                module $ store-module next
                tree $ decode-map-as
                  .unwrap $ get module :tree
                  Map Tag Dynamic
                children $ decode-map-as
                  .unwrap $ get tree :children
                  List Dynamic
              assert= 1 $ count children
        'store-delete $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn store-delete (store)
            let
                path $ ensure-list $ .unwrap-or
                  get
                    .unwrap-or (get store :focus) ({})
                    , :path
                  []
                tree $ decode-map-as
                  .unwrap-or
                    get (store-module store) :tree
                    {}
                  Map Tag Dynamic
              store-with-tree store $ delete-node tree path
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic)
            -> $ Map Tag Dynamic
            :features :js-ffi
        'store-module $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn store-module (store)
            let
                modules $ decode-map-as
                  .unwrap-or (get store :modules) ({})
                  Map String Dynamic
                focus $ .unwrap-or (get store :focus) ({})
                mid $ str $ .unwrap-or (get focus :module) |main
              decode-map-as
                .unwrap $ get modules mid
                Map Tag Dynamic
          :examples $ []
          :schema $ quote $ Fn (Map Tag V)
            -> $ Map Tag Dynamic
            :generics V
        'store-new-module $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn store-new-module (store)
            let
                modules $ decode-map-as
                  .unwrap-or (get store :modules) ({})
                  Map String Dynamic
                mid $ str |m $ count modules
                next $ assoc store :modules $ assoc modules mid
                  {} (:id mid) (:name mid)
                    :tree $ new-node
              assoc next :focus $ {} (:module mid)
                :path $ []
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic)
            -> $ Map Tag Dynamic
        'store-select $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn store-select (store path)
            assoc store :focus $ assoc
              .unwrap-or (get store :focus) ({})
              , :path path
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) (List Dynamic)
            -> $ Map Tag Dynamic
        'store-select-module $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn store-select-module (store mid)
            assoc store :focus $ {} (:module mid)
              :path $ []
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) String
            -> $ Map Tag Dynamic
        'store-set-prop $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn store-set-prop (store k v)
            let
                path $ ensure-list $ .unwrap-or
                  get
                    .unwrap-or (get store :focus) ({})
                    , :path
                  []
                tree $ decode-map-as
                  .unwrap-or
                    get (store-module store) :tree
                    {}
                  Map Tag Dynamic
              store-with-tree store $ set-prop tree path k v
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) Tag String
            -> $ Map Tag Dynamic
            :features :js-ffi
        'store-set-style $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn store-set-style (store k v)
            let
                path $ ensure-list $ .unwrap-or
                  get
                    .unwrap-or (get store :focus) ({})
                    , :path
                  []
                tree $ decode-map-as
                  .unwrap-or
                    get (store-module store) :tree
                    {}
                  Map Tag Dynamic
              store-with-tree store $ set-style tree path k v
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) Tag String
            -> $ Map Tag Dynamic
            :features :js-ffi
        'store-set-tag $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn store-set-tag (store tag)
            let
                path $ ensure-list $ .unwrap-or
                  get
                    .unwrap-or (get store :focus) ({})
                    , :path
                  []
                tree $ decode-map-as
                  .unwrap-or
                    get (store-module store) :tree
                    {}
                  Map Tag Dynamic
              store-with-tree store $ set-tag tree path tag
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) Tag
            -> $ Map Tag Dynamic
            :features :js-ffi
        'store-with-tree $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn store-with-tree (store tree)
            let
                modules $ decode-map-as
                  .unwrap-or (get store :modules) ({})
                  Map String Dynamic
                focus $ .unwrap-or (get store :focus) ({})
                mid $ str $ .unwrap-or (get focus :module) |main
                module $ decode-map-as
                  .unwrap $ get modules mid
                  Map Tag Dynamic
              assoc store :modules $ assoc modules mid $ assoc module :tree tree
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) (Map Tag Dynamic)
            -> $ Map Tag Dynamic
        'update-node $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn update-node (tree path f)
            if (empty? path) (f tree)
              let
                  idx $ .unwrap $ first path
                  children $ ensure-list $ .unwrap-or (get tree :children) ([])
                assoc tree :children $ map-indexed children $ fn (i child)
                  if (= i idx)
                    update-node
                      decode-map-as child $ Map Tag Dynamic
                      rest path
                      , f
                    , child
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) (List Dynamic)
            Fn (Map Tag Dynamic)
              -> $ Map Tag Dynamic
            -> $ Map Tag Dynamic
            :features :js-ffi
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.model
    'app.schema $ %{} 'FileEntry
      :defs $ {} $ 'Action
        %{} 'CodeEntry (:doc |)
          :code $ quote $ defenum Action (:noop)
          :examples $ []
          :schema $ quote EnumDef
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.schema
    'app.server $ %{} 'FileEntry
      :defs $ {}
        'broadcast! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn broadcast! (sender data)
            wss-each! $ fn (sid socket)
              if (not= sid sender) (wss-send! sid data) &unit
            , &unit
          :examples $ []
          :schema $ quote $ Fn String Dynamic (-> Unit) (:features :js-ffi :state)
        'main! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn main! () (println "|DOM Builder server at 6001")
            wss-serve! 6001 $ {} (:on-open on-open) (:on-close on-close) (:on-data on-data)
            , &unit
          :examples $ []
          :schema $ quote $ Fn (-> Unit) (:features :io :js-ffi :state)
        'on-close $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn on-close (sid event) (println |client-closed sid)
          :examples $ []
          :schema $ quote $ Fn String Dynamic (-> Unit) (:features :io :js-ffi)
        'on-data $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn on-data (sid data) (broadcast! sid data)
          :examples $ []
          :schema $ quote $ Fn String Dynamic (-> Unit) (:features :js-ffi :state)
        'on-open $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn on-open (sid socket) (println |client-connected sid)
          :examples $ []
          :schema $ quote $ Fn String Dynamic (-> Unit) (:features :io :js-ffi)
        'reload! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn reload! () (println "|server reloaded")
          :examples $ []
          :schema $ quote $ Fn (-> Unit) (:features :io)
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.server
          :require $ ws-edn.server :refer $ wss-serve! wss-send! wss-each!
    'app.view $ %{} 'FileEntry
      :defs $ {}
        'InputActionValue $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defunion InputActionValue Tag String
          :examples $ []
          :schema $ quote UnionDef
        'TreeActionValue $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defunion TreeActionValue Tag (List Number)
          :examples $ []
          :schema $ quote UnionDef
        'ViewActionValue $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defunion ViewActionValue Tag String (List Number)
          :examples $ []
          :schema $ quote UnionDef
        'append-index $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn append-index (path idx) (conj path idx)
          :examples $ []
          :schema $ quote $ Fn (List Dynamic) Number
            -> $ List Dynamic
        'comp-app $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-app (dispatch store)
            let
                modules $ decode-map-as
                  .unwrap-or (get store :modules) ({})
                  Map String Dynamic
                focus $ .unwrap-or (get store :focus) ({})
                mid $ str $ .unwrap-or (get focus :module) |main
                path $ ensure-list $ .unwrap-or (get focus :path) ([])
                module $ decode-map-as
                  .unwrap $ get modules mid
                  Map Tag Dynamic
                tree $ decode-map-as
                  .unwrap-or (get module :tree) ({})
                  Map Tag Dynamic
                node $ model/get-node tree path
              div
                {} $ :style $ merge ui/global ui/fullscreen
                  {} (:display :flex) (:flex-direction :column)
                div
                  {} $ :style $ merge ui/row-parted
                    {} (:height 48) (:padding "|0 14px") (:background-color "|hsl(220,60%,50%)") (:color :white) (:align-items :center)
                  div
                    {} $ :style $ {} (:font-size 18) (:font-weight 600)
                    <> "|DOM Builder"
                  div
                    {} $ :style $ {} (:display :flex) (:gap 8) (:align-items :center)
                    span
                      {} $ :style $ {} (:font-size 12)
                      <> $ if
                        .unwrap-or (get store :connected?) false
                        , |Connected |Local
                    span
                      {} $ :on-click $ h-new dispatch
                      <> "|New module"
                    span
                      {} $ :on-click $ h-preview dispatch
                      <> |Preview
                div
                  {} $ :style $ {} (:display :flex) (:flex 1) (:overflow :hidden)
                  render-modules dispatch store
                  div
                    {} $ :style $ {} (:flex 1) (:padding 12) (:overflow :auto)
                    <> |Tree
                    render-tree dispatch tree ([]) path
                  render-inspector dispatch node
                if
                  .unwrap-or (get store :preview?) false
                  render-preview dispatch tree
                  span $ {}
          :examples $ []
          :schema $ quote $ Fn
            Fn (Map Tag ViewActionValue) (-> Unit)
            Map Tag Dynamic
            -> respo.schema/Component
            :features :js-ffi
        'ensure-list $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn ensure-list (x)
            if (list? x) x $ []
          :examples $ []
          :schema $ quote $ Fn Dynamic
            -> $ List Dynamic
        'h-add $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn h-add (dispatch)
            fn (e d!)
              dispatch $ {} $ :type :add
          :examples $ []
          :schema $ quote $ Fn
            Fn (Map Tag Tag) (-> Unit)
            -> $ Fn respo.schema/RespoEvent
              Fn app.schema/Action (-> Unit) (:features :io :state)
              -> Unit
        'h-delete $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn h-delete (dispatch)
            fn (e d!)
              dispatch $ {} $ :type :delete
          :examples $ []
          :schema $ quote $ Fn
            Fn (Map Tag Tag) (-> Unit)
            -> $ Fn respo.schema/RespoEvent
              Fn app.schema/Action (-> Unit) (:features :io :state)
              -> Unit
        'h-new $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn h-new (dispatch)
            fn (e d!)
              dispatch $ {} $ :type :new-module
          :examples $ []
          :schema $ quote $ Fn
            Fn (Map Tag Tag) (-> Unit)
            -> $ Fn respo.schema/RespoEvent
              Fn app.schema/Action (-> Unit) (:features :io :state)
              -> Unit
        'h-preview $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn h-preview (dispatch)
            fn (e d!)
              dispatch $ {} $ :type :preview
          :examples $ []
          :schema $ quote $ Fn
            Fn (Map Tag Tag) (-> Unit)
            -> $ Fn respo.schema/RespoEvent
              Fn app.schema/Action (-> Unit) (:features :io :state)
              -> Unit
        'render-input $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn render-input (dispatch label k v kind)
            div
              {} $ :style $ {} (:display :flex) (:gap 6) (:margin-bottom 6)
              span
                {} $ :style $ {} (:width 70) (:font-size 12)
                <> label
              input $ {} $ :on-input
                fn (e d!)
                  dispatch $ {} (:type kind) (:key k)
                    :value $ event-value e
          :examples $ []
          :schema $ quote $ Fn
            Fn (Map Tag InputActionValue) (-> Unit)
            , String Tag String Tag (-> respo.schema/Element)
        'render-inspector $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn render-inspector (dispatch node)
            let
                tag $ .unwrap-or (get node :tag) |div
              div
                {} $ :style $ {} (:padding 12) (:width 260) (:border-left "|1px solid #eee") (:overflow :auto)
                <> |Inspector
                render-input dispatch |Tag :tag (str tag) :tag
                div
                  {} $ :style $ {} (:display :flex) (:gap 8) (:margin-top 12)
                  span
                    {} $ :on-click $ h-add dispatch
                    <> "|Add child"
                  span
                    {} $ :on-click $ h-delete dispatch
                    <> |Delete
          :examples $ []
          :schema $ quote $ Fn
            Fn (Map Tag InputActionValue) (-> Unit)
            Map Tag Dynamic
            -> respo.schema/Element
        'render-modules $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn render-modules (dispatch store)
            let
                modules $ decode-map-as
                  .unwrap-or (get store :modules) ({})
                  Map String Dynamic
                focus $ .unwrap-or (get store :focus) ({})
                mid $ .unwrap-or (get focus :module) |main
              div
                {} $ :style $ {} (:padding 12) (:width 180) (:border-right "|1px solid #eee") (:overflow :auto)
                <> |Modules
                respo.core/keyed->
                  {} $ :style $ {}
                  map (.to-list modules)
                    fn (entry)
                      hint-fn $ Fn (Tuple String Dynamic) (-> respo.schema/ChildPair)
                      let[] (id raw-m) entry $ let
                          m $ decode-map-as raw-m $ Map Tag Dynamic
                          selected? $ = id mid
                        respo.core/keyed-element id $ div
                          {}
                            :style $ merge
                              {} (:padding "|6px 8px") (:cursor :pointer) (:font-size 13)
                              if selected?
                                {} $ :background-color "|hsl(220,80%,92%)"
                                {}
                            :on-click $ fn (e d!)
                              dispatch $ {} (:type :select-module) (:module id)
                          <> $ str $ .unwrap-or (get m :name) id
          :examples $ []
          :schema $ quote $ Fn
            Fn (Map Tag InputActionValue) (-> Unit)
            Map Tag V
            -> respo.schema/Element
            :generics V
        'render-node $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn render-node (node)
            let
                tag $ turn-tag $ str
                  .unwrap-or (get node :tag) |div
                props $ decode-map-as
                  .unwrap-or (get node :props) ({})
                  Map Tag Dynamic
                style $ decode-map-as
                  .unwrap-or (get node :style) ({})
                  Map Tag Dynamic
                children $ ensure-list $ .unwrap-or (get node :children) ([])
              create-list-element tag
                merge props $ {} $ :style style
                map-indexed children $ fn (i child)
                  [] i $ render-node $ decode-map-as child (Map Tag Dynamic)
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) (-> respo.schema/Element) (:features :js-ffi)
        'render-preview $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn render-preview (dispatch node)
            div
              {} $ :style $ {} (:position :fixed) (:top 0) (:left 0) (:right 0) (:bottom 0) (:background-color "|rgba(0,0,0,0.45)") (:padding 40) (:z-index 99)
              div
                {} $ :style $ {} (:background-color :white) (:height |100%) (:overflow :auto) (:padding 16) (:border-radius 8)
                span
                  {} $ :on-click $ h-preview dispatch
                  <> "|Close preview"
                div
                  {} $ :style $ {} (:margin-top 12)
                  render-node node
          :examples $ []
          :schema $ quote $ Fn
            Fn (Map Tag Tag) (-> Unit)
            Map Tag Dynamic
            -> respo.schema/Element
        'render-tree $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn render-tree (dispatch node path focus-path)
            let
                tag $ .unwrap-or (get node :tag) |div
                children $ ensure-list $ .unwrap-or (get node :children) ([])
              div
                {} $ :on-click $ fn (e d!)
                  dispatch $ {} (:type :select) (:path path)
                <> $ str tag
                if (empty? children)
                  span $ {}
                  div
                    {} $ :style $ {} (:padding-left 14)
                    respo.core/keyed->
                      {} $ :style $ {}
                      map-indexed children $ fn (idx child)
                        respo.core/keyed-element idx $ render-tree dispatch
                          decode-map-as child $ Map Tag Dynamic
                          conj path idx
                          , focus-path
          :examples $ []
          :schema $ quote $ Fn
            Fn (Map Tag TreeActionValue) (-> Unit)
            Map Tag Dynamic
            List Number
            List Dynamic
            -> respo.schema/Element
            :features :js-ffi
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.view
          :require (respo-ui.core :as ui)
            respo.core :refer $ defcomp div span button input textarea a list-> create-list-element <> event-value
            app.model :as model
