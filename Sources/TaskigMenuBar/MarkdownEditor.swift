#if os(macOS)
import SwiftUI
import AppKit

struct MarkdownEditor: NSViewRepresentable {
    @Binding var text: String

    func makeNSView(context: Context) -> NSScrollView {
        let scrollView = NSScrollView()
        scrollView.drawsBackground = false
        scrollView.hasVerticalScroller = true

        let textView = MarkdownTextView()
        textView.delegate = context.coordinator
        textView.string = text
        textView.isRichText = false
        textView.isAutomaticQuoteSubstitutionEnabled = false
        textView.isAutomaticDashSubstitutionEnabled = false
        textView.font = .monospacedSystemFont(ofSize: 13, weight: .regular)
        textView.textContainerInset = NSSize(width: 8, height: 10)
        textView.backgroundColor = .clear

        scrollView.documentView = textView
        context.coordinator.textView = textView
        return scrollView
    }

    func updateNSView(_ nsView: NSScrollView, context: Context) {
        guard let textView = context.coordinator.textView, textView.string != text else { return }
        textView.string = text
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text)
    }

    final class Coordinator: NSObject, NSTextViewDelegate {
        @Binding var text: String
        weak var textView: MarkdownTextView?

        init(text: Binding<String>) {
            _text = text
        }

        func textDidChange(_ notification: Notification) {
            guard let textView else { return }
            text = textView.string
        }
    }
}

final class MarkdownTextView: NSTextView {
    override func keyDown(with event: NSEvent) {
        guard event.modifierFlags.intersection(.deviceIndependentFlagsMask).contains(.command),
              let key = event.charactersIgnoringModifiers?.lowercased() else {
            super.keyDown(with: event)
            return
        }

        switch key {
        case "b":
            wrapSelection(prefix: "**", suffix: "**")
        case "i":
            wrapSelection(prefix: "*", suffix: "*")
        case "k":
            wrapSelection(prefix: "[", suffix: "](https://)")
        case "`":
            wrapSelection(prefix: "`", suffix: "`")
        default:
            super.keyDown(with: event)
        }
    }

    private func wrapSelection(prefix: String, suffix: String) {
        guard let textStorage else { return }
        let range = selectedRange()
        guard let swiftRange = Range(range, in: string) else { return }
        let selectedText = String(string[swiftRange])
        let replacement = prefix + selectedText + suffix

        textStorage.replaceCharacters(in: range, with: replacement)
        let cursorLocation = range.location + replacement.count
        setSelectedRange(NSRange(location: cursorLocation, length: 0))
        didChangeText()
    }
}

#endif
