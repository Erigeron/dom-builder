
{} (:package |app)
  :configs $ {} (:init-fn |app.client/main!) (:reload-fn |app.client/reload!)
    :modules $ [] |respo.calcit/ |lilac/ |recollect/ |memof/ |respo-ui.calcit/ |ws-edn.calcit/ |cumulo-util.calcit/ |respo-message.calcit/ |cumulo-reel.calcit/
    :version |0.0.1
  :entries $ {}
    :server $ {} (:port 6001) (:storage-key |calcit.cirru) (:init-fn |app.server/main!) (:reload-fn |app.server/reload!)
      :modules $ [] |lilac/ |recollect/ |memof/ |ws-edn.calcit/ |cumulo-util.calcit/ |cumulo-reel.calcit/ |calcit-wss/ |calcit.std/
  :files $ {}
    |app.comp.editor $ {}
      :ns $ quote
        ns app.comp.editor $ :require
          [] respo-ui.core :refer $ [] hsl
          [] app.schema :as schema
          [] respo-ui.core :as ui
          [] respo.core :refer $ [] create-comp
          [] respo.comp.space :refer $ [] =<
          [] app.style.layout :as layout
          [] app.comp.tree-panel :refer $ [] comp-tree-panel
          [] app.comp.props :refer $ [] comp-props
          [] app.comp.style :refer $ [] comp-style
          [] app.comp.dom-modules :refer $ [] comp-dom-modules
          [] respo.core :refer $ [] defcomp >> <> span div a
      :defs $ {}
        |comp-editor $ quote
          defcomp comp-editor (states dom-modules focus clipboard)
            let
                path $ :path focus
                module-id $ :module focus
                dom-module $ get dom-modules module-id
                element $ case-default (count path)
                  get-in (:tree dom-module)
                    -> path (drop 2)
                      mapcat $ fn (x) ([] :children x)
                  1 nil
                  2 $ :tree dom-module
              div
                {} $ :style style-editor
                comp-dom-modules (>> states :modules) dom-modules focus
                comp-tree-panel (>> states :tree) dom-modules focus clipboard
                comp-props (>> states :props) (:props element) (:path focus)
                comp-style (>> states :style) (:style element) (:path focus)
        |style-editor $ quote
          def style-editor $ merge (:grid layout/editor) (:body layout/workspace)
            {} $ :padding "|0 16px"
    |app.comp.tree $ {}
      :ns $ quote
        ns app.comp.tree $ :require
          [] respo-ui.core :refer $ [] hsl
          [] respo-ui.core :as ui
          [] respo.core :refer $ [] create-comp
          [] respo.comp.space :refer $ [] =<
          [] app.style.layout :as layout
          [] app.style :as style
          [] respo.core :refer $ [] defcomp list-> >> <> span div a button
      :defs $ {}
        |comp-tree $ quote
          defcomp comp-tree (node-tree base-path focus-path)
            case-default (:type node-tree) (<> |nothing nil)
              :dom-module $ div ({})
                div
                  {}
                    :style $ merge style-module-name
                      if (= base-path focus-path) style-focus
                    :on-click $ on-focus base-path
                  <> (:name node-tree) nil
                div
                  {} $ :style style-children
                  if (contains? node-tree :tree)
                    comp-tree (:tree node-tree)
                      [] (:id node-tree) :tree
                      , focus-path
              :element $ div ({})
                div ({})
                  div
                    {}
                      :style $ merge style-element-name
                        if (= base-path focus-path) style-focus
                      :on-click $ on-focus base-path
                    let
                        el-name $ :name node-tree
                      <>
                        str
                          if (string? el-name) (.slice el-name 1)
                            if (keyword? el-name) (turn-str el-name) |nil
                          let
                              p $ :props node-tree
                            if (contains? p :inner-text)
                              str "| " $ pr-str (:inner-text p)
                        , nil
                list->
                  {} $ :style style-children
                  -> (:children node-tree)
                    map-indexed $ fn (idx child)
                      [] idx $ comp-tree child (conj base-path idx) focus-path
        |style-module-name $ quote
          def style-module-name $ {}
            :background-color $ hsl 40 80 60
            :color :white
            :display :inline-block
            :padding "|0 8px"
            :cursor :pointer
            :font-size 12
            :margin 1
        |style-children $ quote
          def style-children $ {} (:padding-left 16)
            :border-left $ str "|1px solid " (hsl 0 0 90)
        |style-element-name $ quote
          def style-element-name $ {}
            :background-color $ hsl 260 80 80
            :padding "|0 8px"
            :margin 1
            :display :inline-block
            :cursor :pointer
            :color :white
            :line-height |1.5em
            :font-size 12
            :white-space :nowrap
            :max-width 200
            :overflow :hidden
            :text-overflow :ellipsis
        |on-focus $ quote
          defn on-focus (path)
            fn (e d!) (d! :dom-modules/focus path)
        |style-focus $ quote
          def style-focus $ {}
            :outline $ str "|1px dashed " (hsl 240 80 60)
    |app.comp.header $ {}
      :ns $ quote
        ns app.comp.header $ :require
          [] respo-ui.core :refer $ [] hsl
          [] respo-ui.core :as ui
          [] respo.core :refer $ [] create-comp
          [] respo.core :refer $ [] defcomp <> span div
          [] app.style.layout :as layout
      :defs $ {}
        |on-profile $ quote
          defn on-profile (e dispatch!)
            dispatch! :router/change $ {} (:name :profile) (:params nil) (:router nil)
        |comp-header $ quote
          defcomp comp-header (logged-in?)
            div
              {} $ :style style-header
              div
                {}
                  :on-click $ fn (e d!)
                    d! :router/change $ {} (:name :home) (:data nil) (:router nil)
                  :style $ merge (:logo layout/header)
                    {} $ :cursor :pointer
                <> |Builder nil
              div
                {}
                  :on-click $ fn (e d!)
                    d! :router/change $ {} (:name :preview) (:data nil) (:router nil)
                  :style $ merge (:logo layout/editor)
                    {} $ :cursor :pointer
                <> |Preview nil
              div
                {}
                  :style $ merge (:profile layout/header) style-pointer
                  :on-click on-profile
                <> (if logged-in? |Profile |Guest) nil
        |style-pointer $ quote
          def style-pointer $ {} (:cursor |pointer)
        |style-header $ quote
          def style-header $ merge (:header layout/workspace) (:grid layout/header)
            {} (:height 48) (:padding "|0 16px") (:font-size 16)
              :color $ hsl 0 0 40
              :font-weight 100
              :font-family "|Josefin Sans"
              :border-bottom $ str "|1px solid " (hsl 0 0 90)
    |app.comp.container $ {}
      :ns $ quote
        ns app.comp.container $ :require
          [] hsl.core :refer $ [] hsl
          [] respo-ui.core :as ui
          [] respo.core :refer $ [] create-comp
          [] respo.comp.inspect :refer $ [] comp-inspect
          [] app.comp.header :refer $ [] comp-header
          [] app.comp.profile :refer $ [] comp-profile
          [] app.comp.login :refer $ [] comp-login
          respo-message.comp.messages :refer $ comp-messages
          [] app.style.layout :as layout
          [] app.comp.editor :refer $ [] comp-editor
          [] app.comp.preview :refer $ [] comp-preview
          [] respo.core :refer $ [] defcomp <> div span
          app.config :refer $ dev?
      :defs $ {}
        |style-alert $ quote
          def style-alert $ {} (:font-family "|Josefin Sans") (:font-weight 100) (:font-size 40)
        |comp-container $ quote
          defcomp comp-container (states store)
            let
                state $ :data states
                session $ :session store
                dom-modules $ :dom-modules store
              if (nil? store)
                div
                  {} $ :style (merge ui/global ui/fullscreen ui/center)
                  <> "|No connection!" style-alert
                if
                  = :preview $ get-in store ([] :router :name)
                  let
                      module-id $ get-in session ([] :focus :module)
                      dom-module $ get dom-modules module-id
                    comp-preview dom-module dom-modules
                      w-js-log $ get-in session ([] :focus :module)
                      w-js-log $ :focuses store
                  div
                    {} $ :style (merge ui/global ui/fullscreen style-contaier)
                    comp-header $ :logged-in? store
                    if (:logged-in? store)
                      let
                          router $ :router store
                        case-default (:name router)
                          div ({})
                            <>
                              str "|404 page: " $ pr-str router
                              , nil
                          :home $ comp-editor states dom-modules (:focus session) (:clipboard session)
                          :profile $ comp-profile (:user store)
                      comp-login states
                    when dev? $ comp-inspect |Store store style-debugger
                    comp-messages
                      get-in store $ [] :session :messages
                      {}
                      fn (info d!) (d! :session/remove-message info)
        |style-debugger $ quote
          def style-debugger $ {} (:bottom 0) (:left 0) (:max-width |100%)
        |style-contaier $ quote
          def style-contaier $ merge (:grid layout/workspace) ({})
    |app.schema $ {}
      :ns $ quote (ns app.schema)
      :defs $ {}
        |dom-module $ quote
          def dom-module $ {} (:type :dom-module) (:name |empty) (:id nil) (:tree nil)
        |configs $ quote
          def configs $ {} (:storage-key |/data/cumulo/dom-builder.edn) (:port 5021)
        |user $ quote
          def user $ {} (:name nil) (:id nil) (:nickname nil) (:avatar nil) (:password nil)
            :focus $ {} (:module nil)
              :path $ []
        |element $ quote
          def element $ {} (:type :element) (:name :div)
            :props $ {}
            :style $ {}
            :children $ []
        |database $ quote
          def database $ {}
            :sessions $ {}
            :users $ {}
            :dom-modules $ {}
        |router $ quote
          def router $ {} (:name nil) (:title nil)
            :data $ {}
            :router nil
        |session $ quote
          def session $ {} (:user-id nil) (:id nil) (:nickname nil)
            :router $ {} (:name :home) (:data nil) (:router nil)
            :focus $ {} (:module nil)
              :path $ []
            :clipboard nil
            :notifications $ []
        |notification $ quote
          def notification $ {} (:id nil) (:kind nil) (:text nil)
    |app.server $ {}
      :ns $ quote
        ns app.server $ :require (app.schema :as schema)
          app.updater :refer $ updater
          cumulo-reel.core :refer $ reel-reducer refresh-reel reel-schema
          app.config :as config
          app.twig.container :refer $ twig-container
          recollect.diff :refer $ diff-twig
          wss.core :refer $ wss-serve! wss-send! wss-each!
          recollect.twig :refer $ new-twig-loop! clear-twig-caches!
          app.$meta :refer $ calcit-dirname
          calcit.std.fs :refer $ path-exists? check-write-file!
          calcit.std.time :refer $ set-interval
          calcit.std.date :refer $ Date get-time!
          calcit.std.path :refer $ join-path
      :defs $ {}
        |*initial-db $ quote
          defatom *initial-db $ if
            path-exists? $ w-log storage-file
            do (println "\"Found local EDN data")
              merge schema/database $ parse-cirru-edn (read-file storage-file)
            do (println "\"Found no data") schema/database
        |persist-db! $ quote
          defn persist-db! () $ let
              file-content $ format-cirru-edn
                assoc (:db @*reel) :sessions $ {}
              storage-path storage-file
              backup-path $ get-backup-path!
            check-write-file! storage-path file-content
            check-write-file! backup-path file-content
        |sync-clients! $ quote
          defn sync-clients! (reel)
            wss-each! $ fn (sid)
              let
                  db $ :db reel
                  records $ :records reel
                  session $ get-in db ([] :sessions sid)
                  old-store $ or (get @*client-caches sid) nil
                  new-store $ twig-container db session records
                  changes $ diff-twig old-store new-store
                    {} $ :key :id
                when config/dev? $ println "\"Changes for" sid "\":" changes (count records)
                if
                  not= changes $ []
                  do
                    wss-send! sid $ format-cirru-edn
                      {} (:kind :patch) (:data changes)
                    swap! *client-caches assoc sid new-store
            new-twig-loop!
        |storage-file $ quote
          def storage-file $ if (empty? calcit-dirname)
            str calcit-dirname $ :storage-file config/site
            str calcit-dirname "\"/" $ :storage-file config/site
        |*reader-reel $ quote (defatom *reader-reel @*reel)
        |*reel $ quote
          defatom *reel $ merge reel-schema
            {} (:base @*initial-db) (:db @*initial-db)
        |main! $ quote
          defn main! ()
            println "\"Running mode:" $ if config/dev? "\"dev" "\"release"
            let
                p? $ get-env "\"port"
                port $ if (some? p?) (parse-float p?) (:port config/site)
              run-server! port
              println $ str "\"Server started on port:" port
            do (; "\"init it before doing multi-threading") (identity @*reader-reel)
            set-interval 200 $ fn () (render-loop!)
            set-interval 600000 $ fn () (persist-db!)
            on-control-c on-exit!
        |get-backup-path! $ quote
          defn get-backup-path! () $ let
              now $ .extract (get-time!)
            join-path calcit-dirname "\"backups"
              str $ :month now
              str (:day now) "\"-snapshot.cirru"
        |on-exit! $ quote
          defn on-exit! () (persist-db!) (; println "\"exit code is...") (quit! 0)
        |dispatch! $ quote
          defn dispatch! (op op-data sid)
            let
                op-id $ generate-id!
                op-time $ -> (get-time!) (.timestamp)
              if config/dev? $ println "\"Dispatch!" (str op) op-data sid
              if (= op :effect/persist) (persist-db!)
                reset! *reel $ reel-reducer @*reel updater op op-data sid op-id op-time config/dev?
        |run-server! $ quote
          defn run-server! (port)
            wss-serve! (&{} :port port)
              fn (data)
                key-match data
                    :connect sid
                    do (dispatch! :session/connect nil sid) (println "\"New client.")
                  (:message sid msg)
                    let
                        action $ parse-cirru-edn msg
                      case-default (:kind action) (println "\"unknown action:" action)
                        :op $ dispatch! (:op action) (:data action) sid
                  (:disconnect sid)
                    do (println "\"Client closed!") (dispatch! :session/disconnect nil sid)
                  _ $ println "\"unknown data:" data
        |render-loop! $ quote
          defn render-loop! () $ when
            not $ identical? @*reader-reel @*reel
            reset! *reader-reel @*reel
            sync-clients! @*reader-reel
        |*client-caches $ quote
          defatom *client-caches $ {}
        |reload! $ quote
          defn reload! () (println "\"Code updated..")
            if (not config/dev?) (raise "\"reloading only happens in dev mode")
            clear-twig-caches!
            reset! *reel $ refresh-reel @*reel @*initial-db updater
            sync-clients! @*reader-reel
    |app.twig.container $ {}
      :ns $ quote
        ns app.twig.container $ :require
          [] app.twig.user :refer $ [] twig-user
          calcit.std.rand :refer $ rand-hex-color!
      :defs $ {}
        |twig-container $ quote
          defn twig-container (db session records)
            let
                logged-in? $ some? (:user-id session)
                router $ :router session
                base-data $ {} (:logged-in? logged-in?) (:session session)
                  :reel-length $ count records
              if logged-in?
                {} (:session session) (:logged-in? true)
                  :user $ get-in db
                    [] :users $ :user-id session
                  :focuses $ -> (:sessions db)
                    map-kv $ fn (k s)
                      [] k $ :focus s
                  :dom-modules $ :dom-modules db
                  :router router
                  :count $ count (:sessions db)
                  :color $ rand-hex-color!
                {} (:session session) (:logged-in? false)
    |app.updater $ {}
      :ns $ quote
        ns app.updater $ :require ([] app.updater.session :as session) ([] app.updater.user :as user) ([] app.updater.router :as router) ([] app.updater.dom-modules :as dom-modules)
      :defs $ {}
        |updater $ quote
          defn updater (db op op-data sid op-id op-time)
            let
                session $ get-in db ([] :sessions sid)
                user $ if (some? session)
                  get-in db $ [] :users (:user-id session)
                f $ case-default op
                  fn (& args) (println "|Unhandled op:" op) db
                  :session/connect session/connect
                  :session/disconnect session/disconnect
                  :user/log-in user/log-in
                  :user/sign-up user/sign-up
                  :user/log-out user/log-out
                  :session/remove-notification session/remove-notification
                  :router/change router/change
                  :dom-modules/create dom-modules/create
                  :dom-modules/choose dom-modules/choose
                  :dom-modules/append-element dom-modules/append-element
                  :dom-modules/delete-element dom-modules/delete-element
                  :dom-modules/rename-element dom-modules/rename-element
                  :dom-modules/before-element dom-modules/before-element
                  :dom-modules/focus dom-modules/focus
                  :dom-modules/set-style dom-modules/set-style
                  :dom-modules/set-prop dom-modules/set-prop
                  :dom-modules/insert-module dom-modules/insert-module
                  :dom-modules/delete-module dom-modules/delete-module
                  :dom-modules/copy dom-modules/copy
                  :dom-modules/clipboard-append dom-modules/clipboard-append
                  :dom-modules/clipboard-before dom-modules/clipboard-before
              f db op-data sid op-id op-time
    |app.comp.tree-panel $ {}
      :ns $ quote
        ns app.comp.tree-panel $ :require
          [] respo-ui.core :refer $ [] hsl
          [] respo-ui.core :as ui
          [] respo.core :refer $ [] create-comp
          [] respo.comp.space :refer $ [] =<
          [] app.style.layout :as layout
          [] app.style :as style
          [] app.comp.tree :refer $ [] comp-tree
          [] app.comp.clipboard :refer $ [] comp-clipboard
          [] respo.core :refer $ [] defcomp <> span code div a button input
      :defs $ {}
        |style-panel $ quote
          def style-panel $ {} (:overflow :auto) (:padding "|0 8px")
        |render-operations $ quote
          defn render-operations (state cursor path)
            div ({})
              input $ {} (:placeholder "|Element, defaults to \"div\"") (:value state) (:style ui/input)
                :on-input $ fn (e d!)
                  d! cursor $ :value e
              =< 8 nil
              a $ {} (:inner-text |Append) (:style style/click)
                :on-click $ fn (e d!)
                  d! :dom-modules/append-element $ if (blank? state) |div state
                  d! cursor |
              =< 8 nil
              a $ {} (:inner-text |Before) (:style style/click)
                :on-click $ fn (e d!) (d! :dom-modules/before-element state) (d! cursor |)
              =< 8 nil
              a $ {} (:inner-text |Copy) (:style style/click)
                :on-click $ fn (e d!) (d! :dom-modules/copy nil)
              =< 8 nil
              a $ {} (:inner-text |Delete) (:style style/click)
                :on-click $ fn (e d!) (d! :dom-modules/delete-element path)
              =< 8 nil
              a $ {} (:inner-text |Rename) (:style style/click)
                :on-click $ fn (e d!)
                  if
                    not $ blank? state
                    do (d! :dom-modules/rename-element state) (d! cursor |)
        |comp-tree-panel $ quote
          defcomp comp-tree-panel (states dom-modules focus clipboard)
            let
                cursor $ :cursor states
                state $ or (:data states) |
                tree-node $ get dom-modules (:module focus)
                path $ :path focus
              div
                {} $ :style
                  merge (:tree layout/editor) style-panel
                <> |Tree style/title
                render-operations state cursor path
                =< nil 8
                comp-clipboard clipboard cursor
                ; div ({}) (<> path nil)
                =< nil 8
                if (some? tree-node)
                  comp-tree tree-node
                    [] $ :id tree-node
                    , path
    |app.twig.user $ {}
      :ns $ quote
        ns app.twig.user $ :require
          [] recollect.twig :refer $ [] create-twig
      :defs $ {}
        |twig-user $ quote
          def twig-user $ create-twig :user
            fn (user) (dissoc user :password)
    |app.comp.dom-modules $ {}
      :ns $ quote
        ns app.comp.dom-modules $ :require
          [] respo-ui.core :refer $ [] hsl
          [] respo-ui.core :as ui
          [] respo.core :refer $ [] create-comp
          [] respo.comp.space :refer $ [] =<
          [] app.style.layout :as layout
          [] app.style :as style
          [] respo.core :refer $ [] defcomp list-> <> span div a input button
      :defs $ {}
        |style-entry $ quote
          def style-entry $ {} (:padding "|0 8px") (:cursor :pointer)
        |render-module-list $ quote
          defn render-module-list (dom-modules focus)
            list->
              {} $ :style (merge style-list)
              -> dom-modules (.to-list)
                map $ fn (entry)
                  let-sugar
                        [] k m
                        , entry
                    [] k $ div
                      {}
                        :style $ merge style-entry
                          if
                            = k $ :module focus
                            , style-highlight
                        :on-click $ fn (e d!)
                          d! :dom-modules/choose $ :id m
                      <> (:name m) nil
                      =< 8 nil
                      span $ {} (:inner-text |insert) (:style style/click)
                        :on-click $ fn (e d!) (d! :dom-modules/insert-module k)
        |style-highlight $ quote
          def style-highlight $ {}
            :background-color $ hsl 240 40 96
        |on-delete $ quote
          defn on-delete (e d!) (d! :dom-modules/delete-module nil)
        |style-list $ quote
          def style-list $ {} (:overflow :auto) (:max-height 400)
        |comp-dom-modules $ quote
          defcomp comp-dom-modules (states dom-modules focus)
            let
                cursor $ :cursor states
                state $ or (:data states) |
              div
                {} $ :style
                  merge $ :modules layout/editor
                <> |Modules style/title
                render-module-list dom-modules focus
                =< nil 8
                div
                  {} $ :style ({})
                  div ({})
                    input $ {} (:value state) (:placeholder "|module name") (:style ui/input)
                      :on-input $ fn (e d!)
                        d! cursor $ :value e
                  div ({})
                    a $ {} (:inner-text |Create) (:style style/click)
                      :on-click $ fn (e d!)
                        if
                          not $ blank? state
                          do (d! :dom-modules/create state) (d! cursor |)
                    =< 8 nil
                    a $ {} (:inner-text |Rename) (:style style/click)
                    =< 8 nil
                    a $ {} (:inner-text |Delete) (:style style/click) (:on-click on-delete)
    |app.updater.user $ {}
      :ns $ quote
        ns app.updater.user $ :require
          calcit.std.hash :refer $ md5
      :defs $ {}
        |sign-up $ quote
          defn sign-up (db op-data sid op-id op-time)
            let-sugar
                  [] username password
                  , op-data
                maybe-user $ find
                  vals $ :users db
                  fn (user)
                    = username $ :name user
              if (some? maybe-user)
                update-in db ([] :sessions sid :messages)
                  fn (messages)
                    assoc messages op-id $ {} (:id op-id)
                      :text $ str "\"Name is taken: " username
                -> db
                  assoc-in ([] :sessions sid :user-id) op-id
                  assoc-in ([] :users op-id)
                    {} (:id op-id) (:name username) (:nickname username)
                      :password $ md5 password
                      :avatar nil
        |log-in $ quote
          defn log-in (db op-data sid op-id op-time)
            let-sugar
                  [] username password
                  , op-data
                maybe-user $ -> (:users db) (vals) (.to-list)
                  find $ fn (user)
                    and $ = username (:name user)
              update-in db ([] :sessions sid)
                fn (session)
                  if (some? maybe-user)
                    if
                      = (md5 password) (:password maybe-user)
                      assoc session :user-id $ :id maybe-user
                      update session :messages $ fn (messages)
                        assoc messages op-id $ {} (:id op-id)
                          :text $ str "\"Wrong password for " username
                    update session :messages $ fn (messages)
                      assoc messages op-id $ {} (:id op-id)
                        :text $ str "\"No user named: " username
        |log-out $ quote
          defn log-out (db op-data session-id op-id op-time)
            assoc-in db ([] :sessions session-id :user-id) nil
    |app.updater.dom-modules $ {}
      :ns $ quote
        ns app.updater.dom-modules $ :require ([] app.schema :as schema)
          [] app.util :refer $ [] expand-tree-path
      :defs $ {}
        |copy $ quote
          defn copy (db op-data session-id op-id op-time)
            let
                path $ get-in db ([] :sessions session-id :focus :path)
                data-path $ expand-tree-path path
                tree $ get-in db data-path
              println "|copy tree:" $ pr-str tree
              assoc-in db ([] :sessions session-id :clipboard) tree
        |insert-module $ quote
          defn insert-module (db op-data session-id op-id op-time)
            let
                path $ get-in db ([] :sessions session-id :focus :path)
                nested-module $ get-in db ([] :dom-modules op-data)
              if
                < (count path) 2
                do (println "|Invalid path:" path) db
                let
                    data-path $ expand-tree-path path
                  -> db $ update-in data-path
                    fn (element)
                      update element :children $ fn (children)
                        conj children $ dissoc nested-module :tree
        |delete-module $ quote
          defn delete-module (db op-data session-id op-id op-time)
            let
                module-id $ get-in db ([] :sessions session-id :focus :module)
              update db :dom-modules $ fn (dom-modules) (dissoc dom-modules module-id)
        |focus $ quote
          defn focus (db op-data session-id op-id op-time)
            -> db $ assoc-in ([] :sessions session-id :focus :path) op-data
        |set-style $ quote
          defn set-style (db op-data session-id op-id op-time)
            let
                path $ get-in db ([] :sessions session-id :focus :path)
              update-in db (expand-tree-path path)
                fn (element)
                  update element :style $ fn (style)
                    if
                      some? $ :value op-data
                      assoc style (:prop op-data) (:value op-data)
                      dissoc style $ :prop op-data
        |before-element $ quote
          defn before-element (db op-data session-id op-id op-time)
            let
                path $ get-in db ([] :sessions session-id :focus :path)
              if
                < (count path) 2
                do (println "|Invalid path:" path) db
                let
                    data-path $ expand-tree-path (butlast path)
                    last-idx $ last path
                  -> db $ update-in data-path
                    fn (element)
                      update element :children $ fn (children)
                        concat (take children last-idx)
                          [] $ merge schema/element
                            {} $ :name (turn-keyword op-data)
                          drop children last-idx
        |delete-element $ quote
          defn delete-element (db op-data session-id op-id op-time)
            if
              < (count op-data) 3
              println "|Invalid path:" op-data
            let
                data-path $ expand-tree-path (butlast op-data)
                last-idx $ last op-data
              -> db
                update-in data-path $ fn (element)
                  update element :children $ fn (children)
                    concat (take children last-idx)
                      drop children $ inc last-idx
                assoc-in ([] :sessions session-id :focus :path) (butlast op-data)
        |set-prop $ quote
          defn set-prop (db op-data session-id op-id op-time)
            let
                path $ get-in db ([] :sessions session-id :focus :path)
              update-in db (expand-tree-path path)
                fn (element)
                  update element :props $ fn (props)
                    if
                      some? $ :value op-data
                      assoc props (:prop op-data) (:value op-data)
                      dissoc props $ :prop op-data
        |choose $ quote
          defn choose (db op-data session-id op-id op-time)
            assoc-in db ([] :sessions session-id :focus)
              {}
                :path $ [] op-data
                :module op-data
        |create $ quote
          defn create (db op-data session-id op-id op-time)
            let
                new-module $ merge schema/dom-module
                  {} (:id op-id) (:name op-data)
                    :tree $ merge schema/element
                      {} $ :name :div
              assoc-in db ([] :dom-modules op-id) new-module
        |rename-element $ quote
          defn rename-element (db op-data session-id op-id op-time)
            let
                path $ get-in db ([] :sessions session-id :focus :path)
              update-in db (expand-tree-path path)
                fn (element)
                  assoc element :name $ turn-keyword op-data
        |append-element $ quote
          defn append-element (db op-data session-id op-id op-time)
            let
                path $ get-in db ([] :sessions session-id :focus :path)
              if
                < (count path) 2
                do (println "|Invalid path:" path) db
                let
                    data-path $ expand-tree-path path
                  -> db $ update-in data-path
                    fn (element)
                      update element :children $ fn (children)
                        conj children $ merge schema/element
                          {} $ :name (turn-keyword op-data)
        |clipboard-append $ quote
          defn clipboard-append (db op-data session-id op-id op-time)
            let
                path $ get-in db ([] :sessions session-id :focus :path)
                tree $ get-in db ([] :sessions session-id :clipboard)
              if
                < (count path) 2
                do (println "|Invalid path:" path) db
                let
                    data-path $ expand-tree-path path
                  -> db $ update-in data-path
                    fn (element)
                      update element :children $ fn (children) (conj children tree)
        |clipboard-before $ quote
          defn clipboard-before (db op-data session-id op-id op-time)
            let
                path $ get-in db ([] :sessions session-id :focus :path)
                tree $ get-in db ([] :sessions session-id :clipboard)
              if
                < (count path) 2
                do (println "|Invalid path:" path) db
                let
                    data-path $ expand-tree-path (butlast path)
                    last-idx $ last path
                  -> db $ update-in data-path
                    fn (element)
                      update element :children $ fn (children)
                        concat (take children last-idx) ([] tree) (drop children last-idx)
    |app.comp.preview $ {}
      :ns $ quote
        ns app.comp.preview $ :require
          [] respo-ui.core :refer $ [] hsl
          [] respo-ui.core :as ui
          [] respo.core :refer $ [] create-comp create-element create-list-element
          [] respo.core :refer $ [] defcomp list-> <> span div a
          [] respo.comp.space :refer $ [] =<
          [] app.style.layout :as layout
      :defs $ {}
        |comp-preview $ quote
          defcomp comp-preview (tree dom-modules module-id focuses)
            let
                paths $ -> focuses (w-js-log) (.to-list)
                  .map $ fn (entry)
                    :path $ last entry
              div
                {} $ :style (merge ui/center ui/fullscreen style-preview)
                div
                  {} (:style style-close) (:on-click on-close)
                  <> |Close nil
                if (some? tree)
                  render-element (:tree tree) paths dom-modules ([] module-id :tree) 0
                  <> "|No tree is found" style-missing
        |style-preview $ quote
          def style-preview $ merge
            {}
              :background-color $ hsl 0 0 90
              :color "\"#333"
              :overflow :auto
        |render-element $ quote
          defn render-element (tree paths dom-modules path level)
            if
              and (some? tree) (< level 20)
              if
                = :dom-module $ :type tree
                let
                    nested-module $ get dom-modules (:id tree)
                  recur (:tree nested-module) paths dom-modules
                    [] (:id tree) :tree
                    inc level
                create-list-element (:name tree)
                  merge (:props tree)
                    {} $ :style
                      merge (:style tree)
                        if (includes? paths path) style-highlight
                  -> (:children tree)
                    map-indexed $ fn (idx child)
                      [] idx $ render-element child paths dom-modules (conj path idx) (inc level)
              span $ {}
        |style-close $ quote
          def style-close $ {} (:position :fixed) (:top 8) (:right 8) (:z-index 999) (:font-size 12) (:font-family "|Josefin Sans") (:cursor :pointer)
            :color $ hsl 0 0 20 0.5
        |on-close $ quote
          defn on-close (e d!)
            d! :router/change $ {} (:name :home) (:data nil)
        |style-highlight $ quote
          def style-highlight $ {}
            :outline $ str "|1px dashed " (hsl 240 80 70)
        |style-missing $ quote
          def style-missing $ {} (:font-family "|Josefin Sans") (:font-weight 100) (:font-size 32)
    |app.comp.profile $ {}
      :ns $ quote
        ns app.comp.profile $ :require
          [] respo-ui.core :refer $ [] hsl
          [] app.schema :as schema
          [] respo-ui.core :as ui
          [] respo.comp.space :refer $ [] =<
          [] respo.core :refer $ [] defcomp <> span div a
      :defs $ {}
        |on-log-out $ quote
          defn on-log-out (e dispatch!) (dispatch! :user/log-out nil)
            .removeItem js/localStorage $ :storage-key schema/configs
        |comp-profile $ quote
          defcomp comp-profile (user)
            div
              {} $ :style ui/flex
              <>
                str "|Hello! " $ :name user
                , nil
              =< 8 nil
              a
                {} (:style style-trigger) (:on-click on-log-out)
                <> "|Log out" nil
        |style-trigger $ quote
          def style-trigger $ {} (:font-size 14) (:cursor :pointer)
            :background-color $ hsl 200 90 70
            :color :white
            :padding "|0 8px"
    |app.comp.login $ {}
      :ns $ quote
        ns app.comp.login $ :require
          [] respo.comp.space :refer $ [] =<
          [] respo.comp.inspect :refer $ [] comp-inspect
          [] respo-ui.core :as ui
          [] app.schema :as schema
          [] respo.core :refer $ [] defcomp <> div input button span
          app.config :as config
      :defs $ {}
        |comp-login $ quote
          defcomp comp-login (states)
            let
                cursor $ :cursor states
                state $ or (:data states) initial-state
              div
                {} $ :style (merge ui/flex ui/center)
                div ({})
                  div
                    {} $ :style ({})
                    div ({})
                      input $ {} (:placeholder "\"Username")
                        :value $ :username state
                        :style ui/input
                        :on-input $ fn (e d!)
                          d! cursor $ assoc state :username (:value e)
                    =< nil 8
                    div ({})
                      input $ {} (:placeholder "\"Password")
                        :value $ :password state
                        :style ui/input
                        :on-input $ fn (e d!)
                          d! cursor $ assoc state :password (:value e)
                  =< nil 8
                  div
                    {} $ :style
                      {} $ :text-align :right
                    span $ {} (:inner-text "\"Sign up")
                      :style $ merge ui/link
                      :on-click $ on-submit (:username state) (:password state) true
                    =< 8 nil
                    span $ {} (:inner-text "\"Log in")
                      :style $ merge ui/link
                      :on-click $ on-submit (:username state) (:password state) false
        |initial-state $ quote
          def initial-state $ {} (:username |) (:password |)
        |on-submit $ quote
          defn on-submit (username password signup?)
            fn (e dispatch!)
              dispatch! (if signup? :user/sign-up :user/log-in) ([] username password)
              .!setItem js/localStorage (:storage-key config/site)
                format-cirru-edn $ [] username password
    |app.style $ {}
      :ns $ quote
        ns app.style $ :require ([] respo-ui.core :as ui)
          [] respo-ui.core :refer $ [] hsl
      :defs $ {}
        |click $ quote
          def click $ {} (:text-decoration :underline) (:font-familze "|Josefin Sans") (:font-size 13) (:font-weight 300) (:cursor :pointer) (:outline :none)
            :color $ hsl 240 90 60
        |title $ quote
          def title $ {} (:font-family "|Josefin Sans") (:font-size 20) (:font-weight 100)
    |app.comp.props $ {}
      :ns $ quote
        ns app.comp.props $ :require
          [] respo-ui.core :refer $ [] hsl
          [] respo-ui.core :as ui
          [] respo.core :refer $ [] create-comp
          [] respo.comp.space :refer $ [] =<
          [] app.style.layout :as layout
          [] app.style :as style
          [] respo.core :refer $ [] defcomp list-> <> span div a input
      :defs $ {}
        |comp-props $ quote
          defcomp comp-props (states props path)
            let
                state $ or (:data states) |
                cursor $ :cursor states
                text state
              div
                {} $ :style (:props layout/editor)
                <> |Props style/title
                list-> ({})
                  -> props (.to-list)
                    map $ fn (entry)
                      let-sugar
                            [] k v
                            , entry
                        [] k $ div
                          {} (:style style-line)
                            :on-click $ fn (e d!)
                              d! cursor $ str (turn-str k) "|: " v
                          <>
                            str (turn-str k) |:
                            , nil
                          =< 8 nil
                          <> v nil
                div ({})
                  input $ {} (:placeholder "|prop: value") (:value state)
                    :style $ merge ui/input style-input
                    :on-input $ fn (e d!)
                      d! cursor $ :value e
                    :on-keydown $ fn (e d!)
                      if
                        and
                          = 13 $ :key-code e
                          not $ blank? text
                        let-sugar
                              [] k v
                              -> text
                                .!split $ new js/RegExp  "\":\\s*"
                                to-calcit-data
                                map trim
                          d! :dom-modules/set-prop $ {}
                            :prop $ turn-keyword k
                            :value $ if (blank? v) nil v
                          d! cursor |
        |style-line $ quote
          def style-line $ {} (:cursor :pointer) (:font-family "|Menlo, monospace") (:font-size 12) (:padding-left 8)
        |style-input $ quote
          def style-input $ {} (:font-size 12) (:font-family |Menlo,monospace)
    |app.comp.style $ {}
      :ns $ quote
        ns app.comp.style $ :require
          [] respo-ui.core :refer $ [] hsl
          [] respo-ui.core :as ui
          [] respo.core :refer $ [] create-comp list-> create-list-element
          [] respo.comp.space :refer $ [] =<
          [] app.style.layout :as layout
          [] app.style :as style
          [] respo.core :refer $ [] defcomp <> span div a input
      :defs $ {}
        |comp-style $ quote
          defcomp comp-style (states style-map path)
            let
                state $ or (:data states) |
                cursor $ :cursor states
                text state
              div
                {} $ :style (:style layout/editor)
                <> |Style style/title
                list-> ({})
                  -> style-map (.to-list)
                    map $ fn (entry)
                      let-sugar
                            [] k v
                            , entry
                        [] k $ div
                          {} (:style style-line)
                            :on-click $ fn (e d!)
                              d! cursor $ str (turn-str k) "|: " v
                          <>
                            str (turn-str k) |:
                            , nil
                          =< 8 nil
                          <> v nil
                div ({})
                  input $ {} (:value state) (:placeholder "|prop: value")
                    :style $ merge ui/input style-input
                    :on-input $ fn (e d!)
                      d! cursor $ :value e
                    :on-keydown $ fn (e d!)
                      let-sugar
                            [] k v
                            -> text
                              .!split $ new js/RegExp "\":\\s*"
                              to-calcit-data
                              map trim
                        if
                          and
                            = 13 $ :key-code e
                            not $ blank? k
                          do
                            d! :dom-modules/set-style $ {}
                              :prop $ turn-keyword k
                              :value $ if (blank? v) nil v
                            d! cursor |
        |style-line $ quote
          def style-line $ {} (:cursor :pointer) (:font-family "|Menlo, monospace") (:font-size 12) (:padding-left 8)
        |style-input $ quote
          def style-input $ {} (:font-size 12) (:font-family |Menlo,monospace)
    |app.util $ {}
      :ns $ quote (ns app.util)
      :defs $ {}
        |find-first $ quote
          defn find-first (f xs)
            reduce
              fn (_ x)
                when (f x) (reduced x)
              , nil xs
        |expand-tree-path $ quote
          defn expand-tree-path (path)
            let
                initial-path $ concat
                  [] :dom-modules (first path) :tree
                children-path $ -> path (drop 2)
                  mapcat $ fn (idx) ([] :children idx)
                data-path $ concat initial-path children-path
              , data-path
        |log-js! $ quote
          defn log-js! (& args)
            apply js/console.log $ map
              fn (x)
                if (coll? x) (clj->js x) x
              , args
        |try-verbosely! $ quote
          defn try-verbosely! (x)
            try x $ catch js/Error e (.log js/console e)
    |app.style.layout $ {}
      :ns $ quote (ns app.style.layout)
      :defs $ {}
        |workspace $ quote
          def workspace $ {}
            :grid $ {} (:display |grid) (:grid-template-rows "|60px 1fr") (:grid-template-columns |1fr) (:justify-items :stretch) (:align-items :stretch)
            :header $ {} (:grid-area |1/1)
            :body $ {} (:grid-area |2/1)
        |header $ quote
          def header $ {}
            :grid $ {} (:display :grid) (:grid-template-rows |1fr) (:grid-template-columns "|80px 80px 1fr 80px") (:grid-gap |8px) (:align-items :center) (:justify-items :center)
            :logo $ {} (:grid-area |1/1)
            :editor $ {} (:grid-area |1/2)
            :profile $ {} (:grid-area |1/4)
        |editor $ quote
          def editor $ {}
            :grid $ {} (:display :grid) (:grid-template-columns "|repeat(6,1fr)") (:grid-template-rows "|repeat(2,1fr)") (:grid-gap |8px) (:justify-items :stretch) (:align-items :stretch)
            :modules $ {} (:grid-area "|1/1/span 2/span 1")
            :tree $ {} (:grid-area "|1/2/span 2/span 3")
            :props $ {} (:grid-area "|1/5/span 1/span 2")
            :style $ {} (:grid-area "|2/5/span 1/span 2")
    |app.comp.clipboard $ {}
      :ns $ quote
        ns app.comp.clipboard $ :require
          [] respo-ui.core :refer $ [] hsl
          [] respo-ui.core :as ui
          [] respo.comp.space :refer $ [] =<
          [] app.style :as style
          [] respo.core :refer $ [] defcomp <> span div a
      :defs $ {}
        |comp-clipboard $ quote
          defcomp comp-clipboard (piece cursor)
            if (some? piece)
              div ({})
                <>
                  str
                    turn-str $ :name piece
                    , |: $ count (:children piece)
                  , style-el-name
                =< 8 nil
                a $ {} (:inner-text |Append) (:style style/click)
                  :on-click $ fn (e d!) (d! :dom-modules/clipboard-append nil)
                =< 8 nil
                a $ {} (:inner-text |Before) (:style style/click) (:on-click on-before)
              <> "|Nothing in clipboard." style-nothing
        |style-nothing $ quote
          def style-nothing $ {} (:font-family "|Josefin Sans") (:font-size 14)
            :color $ hsl 0 0 50
        |style-el-name $ quote
          def style-el-name $ {} (:color :white)
            :background-color $ hsl 240 80 80
            :padding "|0 8px"
        |on-before $ quote
          defn on-before (e d!) (d! :dom-modules/clipboard-before nil)
    |app.updater.router $ {}
      :ns $ quote (ns app.updater.router)
      :defs $ {}
        |change $ quote
          defn change (db op-data session-id op-id op-time)
            assoc-in db ([] :sessions session-id :router) op-data
    |app.updater.session $ {}
      :ns $ quote
        ns app.updater.session $ :require ([] app.schema :as schema)
      :defs $ {}
        |connect $ quote
          defn connect (db op-data session-id op-id op-time)
            assoc-in db ([] :sessions session-id)
              merge schema/session $ {} (:id session-id)
        |disconnect $ quote
          defn disconnect (db op-data session-id op-id op-time)
            update db :sessions $ fn (sessions) (dissoc sessions session-id)
        |remove-notification $ quote
          defn remove-notification (db op-data session-id op-id op-time)
            update-in db ([] :sessions session-id :notifications)
              fn (notifications) (.silce notifications 0 op-data)
    |app.client $ {}
      :ns $ quote
        ns app.client $ :require
          respo.core :refer $ render! clear-cache!
          respo.cursor :refer $ update-states
          app.comp.container :refer $ comp-container
          app.schema :as schema
          app.config :as config
          ws-edn.client :refer $ ws-connect! ws-send!
          recollect.patch :refer $ patch-twig
          cumulo-util.core :refer $ on-page-touch
          "\"url-parse" :default url-parse
          "\"bottom-tip" :default hud!
          "\"./calcit.build-errors" :default client-errors
      :defs $ {}
        |render-app! $ quote
          defn render-app! () $ render! mount-target
            wo-js-log $ comp-container (:states @*states) @*store
            , dispatch!
        |*states $ quote
          defatom *states $ {}
            :states $ {}
              :cursor $ []
        |mount-target $ quote
          def mount-target $ js/document.querySelector "\".app"
        |connect! $ quote
          defn connect! () $ let
              url-obj $ url-parse js/location.href true
              host $ either (-> url-obj .-query .-host) js/location.hostname
              port $ either (-> url-obj .-query .-port) (:port config/site)
            ws-connect! (str "\"ws://" host "\":" port)
              {}
                :on-open $ fn (event) (simulate-login!)
                :on-close $ fn (event) (reset! *store nil) (js/console.error "\"Lost connection!")
                :on-data on-server-data
        |main! $ quote
          defn main! ()
            println "\"Running mode:" $ if config/dev? "\"dev" "\"release"
            if config/dev? $ load-console-formatter!
            render-app!
            connect!
            add-watch *store :changes $ fn (store prev) (render-app!)
            add-watch *states :changes $ fn (states prev) (render-app!)
            on-page-touch $ fn ()
              if (nil? @*store) (connect!)
            println "\"App started!"
        |*store $ quote (defatom *store nil)
        |dispatch! $ quote
          defn dispatch! (op op-data)
            when
              and config/dev? $ ; not= op :states
              println "\"Dispatch" op op-data
            case-default op
              ws-send! $ {} (:kind :op) (:op op) (:data op-data)
              :states $ reset! *states (update-states @*states op-data)
              :effect/connect $ connect!
        |on-server-data $ quote
          defn on-server-data (data)
            case-default (:kind data) (println "\"unknown server data kind:" data)
              :patch $ let
                  changes $ :data data
                when config/dev? $ js/console.log "\"Changes" (to-js-data changes)
                reset! *store $ patch-twig @*store changes
        |simulate-login! $ quote
          defn simulate-login! () $ let
              raw $ .!getItem js/localStorage (:storage-key config/site)
            if (some? raw)
              do (println "\"Found storage.")
                dispatch! :user/log-in $ parse-cirru-edn raw
              do $ println "\"Found no storage."
        |reload! $ quote
          defn reload! () $ if (some? client-errors) (hud! "\"error" client-errors)
            do (hud! "\"inactive" nil) (remove-watch *store :changes) (remove-watch *states :changes) (clear-cache!) (render-app!)
              add-watch *store :changes $ fn (store prev) (render-app!)
              add-watch *states :changes $ fn (states prev) (render-app!)
              println "\"Code updated."
    |app.config $ {}
      :ns $ quote (ns app.config)
      :defs $ {}
        |dev? $ quote
          def dev? $ = "\"dev" (get-env "\"mode")
        |site $ quote
          def site $ {} (:port 5021) (:title "\"Calcium.") (:icon "\"http://cdn.tiye.me/logo/cumulo.png") (:theme "\"#eeeeff") (:storage-key "\"calcium-storage") (:storage-file "\"storage.cirru")
