//
//  VoltHomeViewController.swift
//  VoltFramework
//
//  Created by 
//

import UIKit
import WebKit

public class VoltHomeViewController: BaseViewController {

    @IBOutlet weak var voltWebView: WKWebView!
    
    private var voltUrl: URL?
    
    public init() {
        super.init(nibName: "VoltHomeViewController", bundle: Bundle(for: VoltHomeViewController.self))
        voltUrl = Volt.createVoltSDKUrl()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        voltWebView?.uiDelegate = self
        voltWebView?.navigationDelegate = self
        self.navigationController?.isNavigationBarHidden = true
        loadWebView()
    }

    private func loadWebView() {
        showProgressBar()
        voltWebView.load(NSURLRequest(url: voltUrl ?? URL(fileURLWithPath: "")) as URLRequest)
    }
}

extension VoltHomeViewController: WKUIDelegate {
    public func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if let frame = navigationAction.targetFrame,
            frame.isMainFrame {
            return nil
        }
        if voltUrl != navigationAction.request.url {
            UIApplication.shared.open(navigationAction.request.url ?? URL(fileURLWithPath: ""))
        }
        return nil
    }
}

extension VoltHomeViewController: WKNavigationDelegate {

    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hideProgressBar()
    }

    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        hideProgressBar()
    }

    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.request.url?.scheme == "tel" {
            UIApplication.shared.open(navigationAction.request.url!)
            decisionHandler(.cancel)
        } else if navigationAction.request.url?.scheme == "mailto" {
            UIApplication.shared.open(navigationAction.request.url!)
            decisionHandler(.cancel)
        } else if navigationAction.request.url?.scheme == "whatsapp" {
            UIApplication.shared.open(navigationAction.request.url!)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
}
