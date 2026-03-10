# Taskig Menu Bar Notepad

A compact macOS menu bar app that opens a small overlay notepad with live markdown styling.

## Features

- **Compact single-pane dropdown** via `MenuBarExtra` window style.
- **Inline live markdown styling** while editing (single editor, no split preview).
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
