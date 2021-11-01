//
//  HomeToolBarButton.swift
//  Architecture
//
//  Created by 서상의 on 2021/09/07.
//

import UIKit

class ToolbarButton: UIButton {
    let toolbarButtonType: ButtonKind
    
    init(type: ButtonKind) {
        self.toolbarButtonType = type
        super.init(frame: .zero)
        
        self.setImage(type.image, for: .normal)
        self.tintColor = .corgi.main
    }
    
    @available(*, unavailable, message: "")
    required init?(coder: NSCoder) {
        fatalError()
    }
}

enum ButtonKind {
    case remove, category, add
    
    var image: UIImage? {
        switch self {
        case .add: return .init(systemName: "highlighter")
        case .remove: return .init(systemName: "trash")
        case .category: return .init(systemName: "folder")
        }
    }
}
