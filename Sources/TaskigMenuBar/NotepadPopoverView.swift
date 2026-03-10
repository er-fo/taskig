#if os(macOS)
import SwiftUI

struct NotepadPopoverView: View {
    @StateObject private var viewModel = NotepadViewModel()

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Taskig")
                    .font(.headline)
                Spacer()
                Button("Clear") {
                    viewModel.clear()
                }
                .keyboardShortcut(.delete, modifiers: [.command, .shift])
            }

            MarkdownEditor(text: $viewModel.markdown)
                .background(.quaternary.opacity(0.12), in: RoundedRectangle(cornerRadius: 8))

            HStack {
                Text("Live markdown styling · Cmd+B Cmd+I Cmd+K Cmd+`")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Spacer()
            }
        }
    }
}

#endif
