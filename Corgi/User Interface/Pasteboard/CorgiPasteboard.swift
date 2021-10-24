//
//  CorgiPasteboard.swift
//  Corgi
//
//  Created by 서상의 on 2021/10/07.
//

import UIKit
import OSLog

class CorgiPasteboard {
    static let shared: CorgiPasteboard = .init()
    
    private let general: UIPasteboard = .general
    private let moderator: UIPasteboard? = .init(name: .moderator, create: .yes)
    private let localized: UserDefaults = .standard
    
    private var isFirstTime: Bool = true
                                                                                // 102
    private var changeCountFromExternal: Int = .zero                            // 100
    private var changeCountBeforeEnterBackground: Int? = nil                    // 102
    private var changeCountAfterUpdatedInInternal: Int? {
        guard let changeCount = self.changeCountBeforeEnterBackground else { return nil }
        return changeCount - changeCountFromExternal
    }
    
    init() {
        self.changeCountFromExternal = self.general.changeCount
    }
    
    func flush() {
        self.clearHasNotUsedURL()
    }
    
    func paste() -> URL? {
        return self.retrieveHasNotUsedURL()
    }
    
    func check() -> Bool {
        guard self.isFirstTimeForPasteboard() ||
                self.isUpdatedSinceLastTime() else {
                    return hasNotUsedSinceLastTime()
                }
        
        guard let currentURL = self.general.url else { return .no }
        self.sync(currentURL)
        return .yes
    }
    
    // MARK: - TEST
    func temp(bool: Bool) {
        if bool {
            self.changeCountBeforeEnterBackground = self.general.changeCount
        } else {
            self.changeCountBeforeEnterBackground = .zero
        }
    }
    
    func synchronize() {
        self.localized.setValue(self.changeCountFromExternal, forKey: .changeCount)
    }
}

private extension CorgiPasteboard {
    func hasEnteredBackgroundBefore() -> Bool {
        return self.changeCountBeforeEnterBackground.isNotNil
    }
    
    func isFirstTimeForPasteboard() -> Bool {
        return self.localized.value(forKey: .changeCount).isNil
    }
    
    func isUpdatedSinceLastTime() -> Bool {
        var currenctChangeCount = self.general.changeCount  // 103
        var previousChangeCount = self.changeCountFromExternal  // 100
        
        if self.hasEnteredBackgroundBefore(),   // 102
           let update = self.changeCountAfterUpdatedInInternal { // 2 offset
            currenctChangeCount -= update   // 실제 변경된
            self.changeCountFromExternal = currenctChangeCount
        } else if let changeCount = self.localized.value(forKey: .changeCount) as? Int {
            previousChangeCount = changeCount
        }
        
        return currenctChangeCount > previousChangeCount
    }
    
    func hasNotUsedSinceLastTime() -> Bool {
        return self.retrieveHasNotUsedURL().exist
    }
}

private extension CorgiPasteboard {
    func sync(_ url: URL) {
        self.updateCurrentURL(url)
        self.updateHasNotUsedURL(url)
        self.updateChangeCount(self.general.changeCount)
    }
}

// MARK: - UserDefaults
private extension CorgiPasteboard {
    func retrieveHasNotUsedURL() -> URL? {
        return URL(string: (self.localized.value(forKey: .hasNotUsed) as? String) ?? "")
    }
    
    func clearHasNotUsedURL() {
        self.localized.removeObject(forKey: .hasNotUsed)
        
        return
    }
    
    func updateHasNotUsedURL(_ url: URL?) {
        self.localized.setValue(url?.absoluteString, forKey: .hasNotUsed)
    }
    
    func updateChangeCount(_ count: Int) {
        self.localized.setValue(count, forKey: .changeCount)
    }
}

// MARK: - Local Pasteboard
private extension CorgiPasteboard {
    func updateCurrentURL(_ url: URL) {
        self.moderator?.urls = [url]
    }
}

private extension UIPasteboard {
    var optionalURL: URL? { return self.url }
}

extension UIPasteboard.Name {
    static let moderator: Self = .init(rawValue: "moderator")
}

private extension String {
    static let changeCount: String = "changeCount"
    static let hasNotUsed: String = "hasNotUsed"
}

extension Optional {
    var isNil: Bool { return self == nil }
    var isNotNil: Bool { return self.isNil == false }
    var exist: Bool { return self != nil }
}
