#if os(macOS)
import SwiftUI

struct NotepadPopoverView: View {
    @StateObject private var viewModel = NotepadViewModel()

    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text("Taskig")
                    .font(.headline)
                Spacer()
                Button("Clear") {
                    viewModel.clear()
                }
                .keyboardShortcut(.delete, modifiers: [.command, .shift])
            }

            HSplitView {
                MarkdownEditor(text: $viewModel.markdown)
                    .frame(minWidth: 240, minHeight: 240)

                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Preview")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        if let preview = viewModel.preview {
                            Text(preview)
                                .textSelection(.enabled)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        } else {
                            Text("Invalid markdown")
                                .foregroundStyle(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(10)
                }
                .background(.quaternary.opacity(0.15), in: RoundedRectangle(cornerRadius: 8))
                .frame(minWidth: 240)
            }

            HStack {
                Text("Cmd+B, Cmd+I, Cmd+K, Cmd+` for inline style helpers")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer()
            }
        }
    }
}

#endif
