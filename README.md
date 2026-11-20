# DOM Builder

> Collaborative DOM editing over the wire.

## Architecture

- `app.model`: modules, element tree, selection, add/delete, tag/props/style updates
- `app.view`: module list, tree, inspector, preview
- `app.main`: store, dispatch, WebSocket client
- `app.server`: ws-edn broadcast server

The client works locally when the server is not running; run `yarn build` for the browser bundle.

## 使用者需要注意

开发与构建使用正式 Calcit 和 `@calcit/procs` 0.44.0。 标准库与 WSS 依赖分别使用配套正式版 0.2.58 和 0.2.46。前端和 WebSocket 服务须使用更新后的依赖重新构建；默认模块 ID 统一为字符串 `main`，修复初始模块读取时报键类型错误；协作消息仍使用原 Map 结构，服务器路径未改。按钮事件工厂使用明确的 Respo 事件回调类型，内部操作派发限定为 Tag 键 Map。PR 只运行检查和构建，前端 rsync 仅在主分支推送时执行。

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
