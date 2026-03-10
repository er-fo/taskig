# Taskig Menu Bar Notepad

A compact macOS menu bar app that opens an overlay notepad with live markdown preview.

## Features

- **Menu bar native UX** via `MenuBarExtra` window-style dropdown.
- **Markdown editing + rendering** side-by-side.
- **Command-key markdown helpers** in the editor:
  - `Cmd+B` wraps selection in `**bold**`
  - `Cmd+I` wraps selection in `*italic*`
  - `Cmd+K` wraps selection as markdown link syntax
  - `Cmd+\`` wraps selection in inline code
- **Autosave** with `UserDefaults`.

## Run

```bash
swift run TaskigMenuBar
```

> Note: This target is intended for macOS and should be built/run in a macOS environment with SwiftUI/AppKit available.
