#if os(macOS)
import Foundation

struct MarkdownStorage {
    private let key = "taskig.notepad.markdown"

    func load() -> String {
        UserDefaults.standard.string(forKey: key) ?? "# Quick note\n\nStart typing markdown here..."
    }

    func save(_ markdown: String) {
        UserDefaults.standard.set(markdown, forKey: key)
    }
}

#endif
