import Foundation
import BCApp
import WolfBase
import SwiftUI
import MarkdownUI

enum AppChapter: CaseIterable, Identifiable, ChapterProtocol {
    case about
    case licenseAndDisclaimer

    static var chapterTitles: [String: String] = [:]
    
    static var appLogo: AnyView {
        AppLogo().eraseToAnyView()
    }
    
    var name: String {
        switch self {
        case .about:
            return "about"
        case .licenseAndDisclaimer:
            return "license-and-disclaimer"
        }
    }
    
    var header: AnyView? {
        switch self {
        case .about:
            return IconChapterHeader(image: Image.account)
                .foregroundColor(.accentColor)
                .eraseToAnyView()
        case .licenseAndDisclaimer:
            return nil
        }
    }
    
    var shortTitle: String? {
        switch self {
        default:
            return nil
        }
    }

    var markdownChapter: MarkdownChapter {
        MarkdownChapter(name: name)
    }
    
    var title: String {
        if Self.chapterTitles[name] == nil {
            Self.chapterTitles[name] = markdownChapter.title ?? "Untitled"
        }
        return Self.chapterTitles[name]!
    }
    
    var markdown: Markdown {
        Markdown(Document(markdownChapter.body))
    }

    var id: String {
        name
    }
}
