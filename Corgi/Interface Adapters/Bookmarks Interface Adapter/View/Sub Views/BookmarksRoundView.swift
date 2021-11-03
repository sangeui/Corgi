//
//  BookmarksRoundView.swift
//  Corgi
//
//  Created by 서상의 on 2021/10/14.
//

import UIKit

class BookmarksRoundButton: UIButton {
    var title: String {
        get { self.configuration?.title ?? "" }
        set { self.configuration?.title = newValue }
    }
    
    var image: UIImage? {
        get { self.configuration?.image }
        set { self.configuration?.image = newValue }
    }
    
    init() {
        super.init(frame: .zero)
        
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

private extension BookmarksRoundButton {
    func setup() {
        self.setupConfiguration()
    }
    
    func setupConfiguration() {
        var filledConfiguration: UIButton.Configuration = .filled()
        filledConfiguration.baseBackgroundColor = .corgi.main
        filledConfiguration.imagePadding = .corgi.spacing.padding
        filledConfiguration.buttonSize = .mini
        
        self.configuration = filledConfiguration
    }
}
