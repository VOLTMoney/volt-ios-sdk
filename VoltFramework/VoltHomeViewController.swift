//
//  VoltHomeViewController.swift
//  VoltFramework
//
//  Created by
//

import UIKit
import WebKit
import Foundation

public class VoltHomeViewController: BaseViewController {

    //@IBOutlet public weak var customNavigationView: UIView!
    @IBOutlet public weak var voltWebView: WKWebView!

    private var voltUrl: URL?
    public static var mobileNumber: String?
    private var indicator: UIActivityIndicatorView?
    var nvgStatus = false

    // MARK: Object Lifecycle

    public init(mobileNumber: String, hideNavigationBar: Bool) {
        super.init(nibName: "VoltHomeViewController", bundle: Bundle(for: VoltHomeViewController.self))
        nvgStatus = hideNavigationBar

        voltUrl = VoltSDKContainer.initVoltSDK(mobileNumber: mobileNumber)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = nvgStatus
        title = "Loan Against Mutual Fund"
        voltWebView?.uiDelegate = self
        voltWebView?.navigationDelegate = self
        let color = VoltSDKContainer.voltInstance?.primary_color ?? "FF6E31"
        self.view.backgroundColor = hexStringToUIColor(hex: color)
        self.navigationController?.navigationBar.backgroundColor = hexStringToUIColor(hex: color)
        self.navigationController?.navigationBar.standardAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        addBackButton()
        loadWebView()
    }

    private func addBackButton() {
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        //backButton.setTitle("Back", for: .normal)
        backButton.tintColor = .white
        backButton.setTitleColor(backButton.tintColor, for: .normal)
        backButton.addTarget(self, action: #selector(self.backAction(_:)), for: .touchUpInside)

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }

    @IBAction func backAction(_ sender: UIButton) {
       let _ = self.navigationController?.popViewController(animated: true)
    }

    private func loadWebView() {
        self.showProgressBar()
        voltWebView.load(NSURLRequest(url: voltUrl ?? URL(fileURLWithPath: "")) as URLRequest)
    }

    func hexStringToUIColor(hex: String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
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
