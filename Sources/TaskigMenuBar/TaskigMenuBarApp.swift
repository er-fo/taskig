#if os(macOS)
import SwiftUI

@main
struct TaskigMenuBarApp: App {
    var body: some Scene {
        MenuBarExtra("Taskig", systemImage: "note.text") {
            NotepadPopoverView()
                .frame(width: 380, height: 280)
                .padding(10)
        }
        .menuBarExtraStyle(.window)
    }
}

#endif
