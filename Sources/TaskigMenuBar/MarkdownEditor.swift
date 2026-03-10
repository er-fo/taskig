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
        textView.allowsUndo = true
        textView.applyMarkdownStyling()

        scrollView.documentView = textView
        context.coordinator.textView = textView
        return scrollView
    }

    func updateNSView(_ nsView: NSScrollView, context: Context) {
        guard let textView = context.coordinator.textView, textView.string != text else { return }
        textView.string = text
        textView.applyMarkdownStyling()
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
            textView.applyMarkdownStyling()
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

    fileprivate func applyMarkdownStyling() {
        guard let textStorage else { return }

        let fullRange = NSRange(location: 0, length: textStorage.length)
        let baseFont = NSFont.monospacedSystemFont(ofSize: 13, weight: .regular)
        let baseColor = NSColor.textColor

        textStorage.beginEditing()
        textStorage.setAttributes([
            .font: baseFont,
            .foregroundColor: baseColor
        ], range: fullRange)

        applyPattern("(?m)^(#{1,6})\\s+(.+)$", in: textStorage) { match in
            let markerRange = match.range(at: 1)
            let titleRange = match.range(at: 2)
            textStorage.addAttribute(.foregroundColor, value: NSColor.secondaryLabelColor, range: markerRange)
            textStorage.addAttributes([
                .font: NSFont.systemFont(ofSize: 15, weight: .semibold)
            ], range: titleRange)
        }

        applyPattern("\\*\\*(.+?)\\*\\*", in: textStorage) { match in
            let contentRange = match.range(at: 1)
            textStorage.addAttribute(.font, value: NSFont.monospacedSystemFont(ofSize: 13, weight: .bold), range: contentRange)
        }

        applyPattern("(?<!\\*)\\*(?!\\*)(.+?)(?<!\\*)\\*(?!\\*)", in: textStorage) { match in
            let contentRange = match.range(at: 1)
            textStorage.addAttribute(.font, value: NSFontManager.shared.convert(baseFont, toHaveTrait: .italicFontMask), range: contentRange)
        }

        applyPattern("`(.+?)`", in: textStorage) { match in
            let whole = match.range(at: 0)
            textStorage.addAttributes([
                .backgroundColor: NSColor.quaternaryLabelColor.withAlphaComponent(0.15)
            ], range: whole)
        }

        applyPattern("\\[(.+?)\\]\\((.+?)\\)", in: textStorage) { match in
            let labelRange = match.range(at: 1)
            let linkRange = match.range(at: 2)
            textStorage.addAttributes([
                .underlineStyle: NSUnderlineStyle.single.rawValue,
                .foregroundColor: NSColor.systemBlue
            ], range: labelRange)
            textStorage.addAttribute(.foregroundColor, value: NSColor.secondaryLabelColor, range: linkRange)
        }

        textStorage.endEditing()
    }

    private func applyPattern(_ pattern: String, in textStorage: NSTextStorage, apply: (NSTextCheckingResult) -> Void) {
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return }
        let range = NSRange(location: 0, length: textStorage.length)
        regex.matches(in: textStorage.string, range: range).forEach(apply)
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
