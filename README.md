# DOM Builder

> Collaborative DOM editing over the wire.

## Architecture

- `app.model`: modules, element tree, selection, add/delete, tag/props/style updates
- `app.view`: module list, tree, inspector, preview
- `app.main`: store, dispatch, WebSocket client
- `app.server`: ws-edn broadcast server

The client works locally when the server is not running; run `yarn build` for the browser bundle.

## 使用者需要注意

开发与构建使用正式 Calcit 和 `@calcit/procs` 0.44.0。前端和 WebSocket 服务须使用更新后的依赖重新构建；现有消息协议与服务器路径未改。PR 只运行检查和构建，前端 rsync 仅在主分支推送时执行。

## Develop

```bash
caps --strict --ci
calcit calcit.cirru --check-only
yarn build
```

Server:

```bash
yarn server
```

### License

MIT
