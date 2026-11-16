# DOM Builder

> Collaborative DOM editing over the wire.

## Architecture

- `app.model`: modules, element tree, selection, add/delete, tag/props/style updates
- `app.view`: module list, tree, inspector, preview
- `app.main`: store, dispatch, WebSocket client
- `app.server`: ws-edn broadcast server

The client works locally when the server is not running; run `yarn build` for the browser bundle.

## Develop

```bash
caps --ci
calcit calcit.cirru --check-only
yarn build
```

Server:

```bash
yarn server
```

### License

MIT
