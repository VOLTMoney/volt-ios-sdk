//
//  InAppWebView.swift
//  VoltWrapper
//
//  Created by Sagar Bhatnagar on 25/08/24.
//

import Foundation
import UIKit
import WebKit

class InAppWebView: UIViewController {
    var webView: WKWebView!
    
    override func viewDidLoad() {
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences = preferences
        webView = WKWebView(frame: view.bounds, configuration: configuration)
    }
}

extension InAppWebView: WKNavigationDelegate, WKUIDelegate {
}
