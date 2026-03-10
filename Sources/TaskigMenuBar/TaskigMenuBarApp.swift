#if os(macOS)
import SwiftUI

@main
struct TaskigMenuBarApp: App {
    var body: some Scene {
        MenuBarExtra("Taskig", systemImage: "note.text") {
            NotepadPopoverView()
                .frame(minWidth: 500, minHeight: 340)
                .padding(12)
        }
        .menuBarExtraStyle(.window)
    }
}

#endif
