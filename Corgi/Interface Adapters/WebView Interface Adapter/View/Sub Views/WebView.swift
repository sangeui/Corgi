//
//  WebView.swift
//  Corgi
//
//  Created by 서상의 on 2021/10/23.
//

import UIKit
import WebKit

class WebView: WKWebView {
    var onFinish: ((WKWebView) -> Void)? = nil
    var onLoading: ((Bool) -> Void)? = nil
    
    private let progressBar: ProgressView = .init(progressViewStyle: .bar)
    
    init() {
        super.init(frame: .init(), configuration: .init())
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            self.progressBar.progress = Float(self.estimatedProgress)
            return
        }
        
        if keyPath == #keyPath(WKWebView.isLoading) {
            self.onLoading?(self.isLoading)
        }
    }
}

extension WebView: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.onFinish?(webView)
    }
}

private extension WebView {
    func setup() {
        self.navigationDelegate = self
        self.isOpaque = .no
        self.configuration.allowsInlineMediaPlayback = .yes
        self.backgroundColor = .corgi.background.base
        self.underPageBackgroundColor = .corgi.background.base
        
        self.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        self.addObserver(self, forKeyPath: #keyPath(WKWebView.isLoading), options: .new, context: nil)

        
        self.setupProgressBar(self.progressBar, inside: self)
    }
    
    func setupProgressBar(_ bar: ProgressView, inside parent: UIView) {
        parent.addSubview(bar, autolayout: .yes)
        bar.leading.pin(equalTo: parent.leading).active
        bar.trailing.pin(equalTo: parent.trailing).active
        bar.bottom.pin(equalTo: parent.bottom).active
        
        bar.sizeToFit()
        bar.layer.zPosition = .greatestFiniteMagnitude
        bar.progressTintColor = .corgi.main
    }
}

class ProgressView: UIProgressView {
    override var progress: Float {
        didSet { self.isHidden = self.progress.isZero || self.progress == 1 }
    }
}

