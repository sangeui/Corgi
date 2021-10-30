//
//  BookmarkVIewModel.swift
//  Architecture
//
//  Created by 서상의 on 2021/09/04.
//

import Foundation
import Combine

class BookmarkViewModel {
    @Published public private(set) var view: BookmarkNavigation<BookmarkViewType> = .presented(view: .bookmark) {
        didSet { print("🛫 \(self.view)") }
    }
    
    private let bookmarkManager: StorageManager
    private let bookamrk: Bookmark
    
    init(bookmarkManager: StorageManager, bookmark: Bookmark) {
        self.bookmarkManager = bookmarkManager
        self.bookamrk = bookmark
    }
    
    func urlRequest() -> URLRequest? {
        guard var components: URLComponents = .init(url: self.bookamrk.url) else { return nil }
        
        if components.scheme?.isEmpty ?? true {
            components.scheme = "HTTP"
        }
        
        guard let url = components.url else { return nil }
        
        return .init(url: url)
    }
    
    func bookmarkURL() -> URL {
        return self.bookamrk.url
    }
    
    func bookmarkURLstring() -> String {
        return self.bookamrk.url.absoluteString.removingPercentEncoding ?? ""
    }
    
    func bookmarkCategory() -> String? {
        return self.bookamrk.group
    }
    
    func bookmarkDescription() -> String? {
        return self.bookamrk.comment
    }
}

extension BookmarkViewModel: ShareNavigator {
    func navigateToShare(url: URL) {
        self.view = .present(view: .share(url))
    }
}

private extension URLComponents {
    init?(url: URL) {
        self.init(url: url, resolvingAgainstBaseURL: .no)
    }
}

enum BookmarkNavigation<ViewType: Equatable>: Equatable {
    case present(view: ViewType)
    case presented(view: ViewType)
}

enum BookmarkViewType: Equatable {
    case bookmark
    case share(URL)
}
