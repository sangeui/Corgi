//
//  Color.swift
//  Corgi
//
//  Created by 서상의 on 2021/10/19.
//

import UIKit

struct Measurement {
    let spacing: Spacing = .init()
    let size: Size = .init()
}

extension Measurement {
    struct Spacing {
        let margin: CGFloat = 20
        let padding: CGFloat = 10
    }
    
    struct Size {
        func height(multiplier: CGFloat = 1) -> CGFloat {
            return 20 * multiplier
        }
    }
}

extension CGFloat {
    static let corgi = Measurement()
}

struct Color {
    let main: UIColor = .systemOrange
    let background: Background = .init()
    let text: Text = .init()
}

extension Color {
    struct Background {
        let base: UIColor = .systemBackground
        let grouped: UIColor = .init { trait in
            switch trait.userInterfaceStyle {
            case .dark: return .init(red: 33/255, green: 33/255, blue: 33/255, alpha: 1.0)
            default: return .white
            }
        }
    }
    
    struct Text {
        let primary: UIColor = .label
        let secondary: UIColor = .systemGray
    }
}

extension UIColor {
    static let corgi = Color()
}

struct Font {
    let header1: UIFont = .systemFont(ofSize: 28, weight: .semibold)
    let subtitle3: UIFont = .systemFont(ofSize: 14, weight: .semibold)
    let subTitle4: UIFont = .systemFont(ofSize: 12, weight: .semibold)
    let subTitle5: UIFont = .systemFont(ofSize: 10, weight: .semibold)
    let caption1: UIFont = .systemFont(ofSize: 10, weight: .regular)
    let caption2: UIFont = .systemFont(ofSize: 8, weight: .semibold)
}

extension UIFont {
    static let corgi = Font()
}
