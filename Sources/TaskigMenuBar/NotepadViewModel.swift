#if os(macOS)
import Foundation

@MainActor
final class NotepadViewModel: ObservableObject {
    @Published var markdown: String {
        didSet { storage.save(markdown) }
    }

    private let storage = MarkdownStorage()

    init() {
        markdown = storage.load()
    }

    func clear() {
        markdown = ""
    }
}

#endif
