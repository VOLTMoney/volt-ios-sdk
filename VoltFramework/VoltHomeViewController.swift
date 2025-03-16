//
//  VoltHomeViewController.swift
//  VoltFramework
//
//  Created by
//

import UIKit
import WebKit
import Foundation
import SafariServices

public class VoltHomeViewController: BaseViewController, SFSafariViewControllerDelegate, WKScriptMessageHandler {
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {

        if let messageBody = message.body as? String, messageBody.contains("closeActivity") {
            // The message contains "closePop"
            // Add your logic here to handle the "closePop" message
            DispatchQueue.main.async {
                  if let navigationController = self.navigationController {
                      navigationController.popViewController(animated: true)
                  } else {
                      self.dismiss(animated: true, completion: nil)
                  }
              }
        }
        
        
        if let messageBody = message.body as? String, messageBody.contains("DSP") {
            isLenderDsp = true
            // Add your logic here to handle the "closePop" message
        }
        
    
        if let messageBody = message.body as? String, messageBody.contains("FAQ") {
            exitCallback?("FAQ_CLICKED")
            // The message contains "closePop"
            // Add your logic here to handle the "closePop" message
            DispatchQueue.main.async {
                  if let navigationController = self.navigationController {
                      navigationController.popViewController(animated: true)
                  } else {
                      self.dismiss(animated: true, completion: nil)
                  }
              }
            // Add your logic here to handle the "closePop" message
        }
        if let messageBody = message.body as? String, messageBody.contains("closePop") {
            // The message contains "closePop"
             closeSafariViewController()
            // Add your logic here to handle the "closePop" message
        }
        
        if let messageBody = message.body as? String, messageBody.contains("KYCPOD") {
            // The message contains "closePop"
            showLinksClicked(urlStr: messageBody)

            // Add your logic here to handle the "closePop" message
        }
        
        if let messageBody = message.body as? String, messageBody.contains("agreementSetup") {
            // The message contains "closePop"
            showLinksClicked(urlStr: messageBody)
            // Add your logic here to handle the "closePop" message
        }
        
        if let messageBody = message.body as? String, messageBody.contains("mandateSetup"){
            // The message contains "closePop"
            showLinksClicked(urlStr: messageBody)
            // Add your logic here to handle the "closePop" message
        }
        if let messageBody = message.body as? String, messageBody.contains("tech_process_v2"){
            // The message contains "closePop"
            showLinksClicked(urlStr: messageBody)
            // Add your logic here to handle the "closePop" message
        }
        //agreementSetup
    }
    

    //@IBOutlet public weak var customNavigationView: UIView!
    @IBOutlet public  var voltWebView: WKWebView!

    private var voltUrl: URL?
    public static var authToken: String?
    public static var platformCode: String?
    public  var isLenderDsp : Bool?
    private var safarWebView: SFSafariViewController?
    var exitCallback: ((String) -> Void)?

    
    private var indicator: UIActivityIndicatorView?
    var nvgStatus = false

    // MARK: Object Lifecycle

    public init(authToken: String, platformCode: String ,hideNavigationBar: Bool,  exitCallback: ((String) -> Void)?) {
        super.init(nibName: "VoltHomeViewController", bundle: Bundle(for: VoltHomeViewController.self))
        nvgStatus = hideNavigationBar
        
        self.exitCallback = exitCallback
        Task {
            if let url = await VoltSDKContainer.initVoltSDK(authToken: authToken, platformCode: platformCode) {
                voltUrl = url
                loadWebView(newUrl: url)
            } else {
                voltUrl = nil
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupHeader() {
        
        
        if (VoltSDKContainer.voltInstance?.showSDKHeader ?? false) {
            let headerView = UIView()
            headerView.backgroundColor = hexStringToUIColor(hex: VoltSDKContainer.voltInstance?.primary_color ?? "#1434cb")
            headerView.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(headerView)
            
            let backButton = UIButton(type: .system)
            backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
            backButton.tintColor = .white
            backButton.addTarget(self, action: #selector(closeWebView), for: .touchUpInside)
            backButton.translatesAutoresizingMaskIntoConstraints = false
            let titleLabel = UILabel()
            
            // Set the text for the label
            titleLabel.text = "Loan Against Mutual Fund"
            
            // Set text alignment to center
            titleLabel.textAlignment = .center
            
            // Set font and color if needed
            titleLabel.font = UIFont.systemFont(ofSize: 18)  // Example font
            titleLabel.textColor = .white  // Or any color you'd like
            
            // Add the label to the header view
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            
            
            headerView.addSubview(backButton)
            headerView.addSubview(titleLabel)
            
            
            NSLayoutConstraint.activate([
                titleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor), // Center horizontally
                titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor), // Center vertically
                titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: headerView.leadingAnchor, constant: 10), // Add some margin to the left
                titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: headerView.trailingAnchor, constant: -10) // Add some margin to the right
            ])
            
            
            // Constraints for headerView
            NSLayoutConstraint.activate([
                headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                headerView.heightAnchor.constraint(equalToConstant: 50)
            ])
            
            // Constraints for backButton
            NSLayoutConstraint.activate([
                backButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
                backButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
            ])
        }
    }

    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let isEnabled = navigationController?.interactivePopGestureRecognizer?.isEnabled
        
        self.view.isUserInteractionEnabled = true

           // Create a left swipe gesture recognizer
           let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeLeft.direction = .right

           // Add the gesture recognizer to the view
           self.view.addGestureRecognizer(swipeLeft)

        self.navigationController?.navigationBar.isHidden = nvgStatus
               title = "Loan Against Mutual Fund"
               let color = VoltSDKContainer.voltInstance?.primary_color ?? "FF6E31"
               self.view.backgroundColor = hexStringToUIColor(hex: color)
               self.navigationController?.navigationBar.backgroundColor = hexStringToUIColor(hex: color)
               self.navigationController?.navigationBar.standardAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

               // Configure the WebView
               let contentController = WKUserContentController()
               contentController.add(self, name: "voltMessageHandler")
               
               let config = WKWebViewConfiguration()
               config.userContentController = contentController
               
               // Inject the meta viewport tag to disable zoom
     
               

        

        //add white/black bg to prevent flicker when webview loads
        voltWebView.backgroundColor = traitCollection.userInterfaceStyle == .dark ? .black : .white
        

        
        
                    NSLayoutConstraint.activate([
                           voltWebView.topAnchor.constraint(equalTo: view.topAnchor , constant: VoltSDKContainer.voltInstance?.showSDKHeader ?? false ? 50 : 0),
                           voltWebView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                           voltWebView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                           voltWebView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                           voltWebView.heightAnchor.constraint(equalToConstant: 1) // Set a minimal height initially

                       ])
        
        

        
        if voltWebView == nil {
            print("voltWebView is nil. Initialization failed.")
        } else {
            print("VoltWebView initialized successfully.")
        }
               // Set delegates
               voltWebView.uiDelegate = self
               voltWebView.navigationDelegate = self
        if #available(iOS 16.4, *) {
            voltWebView.isInspectable = true
        } else {
            // Fallback on earlier versions
        }
               // Add voltWebView to the view hierarchy
               self.view.addSubview(voltWebView)
           
           // Load the web content if necessary
         

           // Add back button and fetch data
           addBackButton()
           fetchData()
           setupHeader()
    }
    
    @objc func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .right {
            // If presented modally, dismiss the view controller
            if self.presentingViewController != nil {
                self.dismiss(animated: true, completion: nil)
            } else if let navigationController = self.navigationController {
                // If in a navigation stack, pop the view controller
                navigationController.popViewController(animated: true)
            }
        }
    }

    func fetchData() {
        // Create URL
        guard let url = URL(string: "https://api.staging.voltmoney.in/app/pf/details/") else {
            print("Invalid URL")
            return
        }
        
        // Create URL Request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Set Headers
        request.setValue("Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ2b2x0LXNkay1zdGFnaW5nQHZvbHRtb25leS5pbiIsImV4cCI6MTcxMDIzNDE5OCwiaWF0IjoxNzEwMjMzMjk4fQ.WurrQkz1WuKeyk6izcITIzjHLFZLbeQ2st5qBMj51eI", forHTTPHeaderField: "authorization")

        
        // Create URLSession
        let session = URLSession.shared
        
        // Create Data Task
        let task = session.dataTask(with: request) { data, response, error in
            // Check for Error
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            // Check for Data
            guard let data = data else {
                print("No data received")
                return
            }
            
            // Print Response
            if let httpResponse = response as? HTTPURLResponse {
                print("Status Code: \(httpResponse.statusCode)")
            }
            
            // Convert Data to String
            if let dataString = String(data: data, encoding: .utf8) {
                print("Response Data: \(dataString)")
            }
        }
        
        // Resume Task
        task.resume()
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

    private func loadWebView(newUrl : URL) {
        
   
        if voltWebView == nil {
            print("voltWebView is nil. Initialization failed. on load")
        } else {
            print("voltWebView initialized successfully. on load")
        }
        let request = URLRequest(url: newUrl)
        voltWebView.load(request)

//        voltWebView.load(NSURLRequest(url: voltUrl ?? URL(fileURLWithPath: "")) as URLRequest)
        
    }
    
    // Close action
    @objc private func closeWebView() {
        if let _ = self.presentingViewController {
            // If the view controller was presented modally
            self.dismiss(animated: true, completion: nil)
        } else if self.navigationController != nil {
            // If the view controller is part of a navigation stack
            self.navigationController?.popViewController(animated: true)
        }
        exitCallback?("APP_CLOSED")
    }
    
  
    


    func hexStringToUIColor(hex: String) -> UIColor {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        // Remove the "#" if present
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }

        // If the string is not 6 or 8 characters, return gray color
        if cString.count != 6 && cString.count != 8 {
            return UIColor.gray
        }

        // Default alpha value to 1.0 (fully opaque)
        var alpha: CGFloat = 1.0

        // If there are 8 characters, extract the alpha value from the last 2 characters
        if cString.count == 8 {
            let alphaHex = String(cString.suffix(2))
            if let alphaValue = Int(alphaHex, radix: 16) {
                alpha = CGFloat(alphaValue) / 255.0
            }
            cString = String(cString.prefix(6)) // Remove the last 2 characters (alpha part)
        }

        // Convert RGB components
        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }

    
    func showLinksClicked(urlStr: String) {
        if safarWebView == nil, let url = URL(string: urlStr) {
            safarWebView = SFSafariViewController(url:url)
            
        }
        if let vc = safarWebView {
            present(vc, animated: true, completion: nil)
            safarWebView?.delegate = self
        }
    }
    func closeSafariViewController() {
        if safarWebView != nil {
            dismiss(animated: true, completion: nil)
            safarWebView = nil // Optional: Set to nil to clear reference
        }
    }
    public func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
            controller.dismiss(animated: true, completion: nil)
    }
    
    public func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool){
        print("\(String(describing: controller.userActivity?.webpageURL?.absoluteString))")
    }
    public func safariViewController(_ controller: SFSafariViewController, initialLoadDidRedirectTo URL: URL) {
        if URL.absoluteString == "WHATEVER YOUR LINK IS"{
            controller.dismiss(animated: true, completion: nil)
        }
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
        }
//        else if let url = webView.url?.absoluteString, url.contains("KYCPOD/Index") {
//           showLinksClicked(urlStr: url)
//           decisionHandler(.cancel)
//       }
        
        
        else if isLenderDsp ?? false{
            decisionHandler(.allow)
        }
     
        else if let url = webView.url?.absoluteString, url.contains("tech_process_v2") {
           decisionHandler(.cancel)
            showLinksClicked(urlStr: url)

       }
        else if let url = webView.url?.absoluteString, url.contains("digitallocker") {
            showLinksClicked(urlStr: url)
            decisionHandler(.cancel)
        }
     
        else if let url = webView.url?.absoluteString, url.contains("closePop") {
            safarWebView?.dismiss(animated: true)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
//    public func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
//        print("did Receive")
//    }

    public func webView(_ webView: WKWebView, shouldPreviewElement elementInfo: WKContextMenuElementInfo) -> Bool {
        print("should Preview")
        return true
    }
    
    
}


