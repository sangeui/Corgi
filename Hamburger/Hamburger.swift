//
//  Hamburger.swift
//  Hamburger
//
//  Created by 서상의 on 2021/10/04.
//

import Foundation

public extension NSObject {
    var hamburger: Debugger {
        return .shared
    }
}

public protocol Edible {
    
}

public extension Edible {
    var hamburger: Debugger {
        return .shared
    }
}

public class Debugger {
    static let shared = Debugger()
    
    private var name: String = "HAMBURGER"
    private var icon: String = "🍔"
    private var linesFromOthers: Int = 1
    
    private var heading: String {
        return "\(self.icon) \(self.name) DEBUGGING"
    }
    
    private var subHeading: String {
        return "\(self.name) sends message"
    }
    
    private var divider: Character {
        return Character("-")
    }
    
    private var signature: String {
        return "\(self.icon) \(self.name) SAID: I've done all my jobs"
    }
    
    private init() { }
    
    public func configure(name: String, icon: String, lines: Int = 1) {
        self.name = name
        self.icon = icon
        self.linesFromOthers = lines
    }
    
    public func debug(message: String) {
        (0..<self.linesFromOthers).forEach({ _ in print() })
        print(self.heading)
        print(self.subHeading)
        print(String(repeating: self.divider, count: self.subHeading.count))
        print("     \(message)")
        print(String(repeating: self.divider, count: self.subHeading.count))
        print(self.signature)
        (0..<self.linesFromOthers).forEach({ _ in print() })
    }
}
