
import Foundation
import WebKit
import SwiftUI

class SupportViewController: UIViewController, WKNavigationDelegate {
    var targetUrl: String
    private var webView: WKWebView!
    
    init(targetUrl: String) {
        self.targetUrl = targetUrl
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        overrideUserInterfaceStyle = .dark
        
        navigationController?.navigationBar.backgroundColor = .black
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.isTranslucent = false
        
        setupWebView()
        setupToolbar()
        if let url = URL(string: self.targetUrl) {
            let request = URLRequest(url: url)
            self.webView.load(request)
        }
    }

    private func setupWebView() {
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.allowsInlineMediaPlayback = true
        
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.allowsBackForwardNavigationGestures = true
        webView.navigationDelegate = self
        webView.backgroundColor = .black
        webView.scrollView.backgroundColor = .black
        
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        webView.scrollView.bounces = false
        
        webView.scrollView.minimumZoomScale = 1.0
        webView.scrollView.maximumZoomScale = 2.0
        webView.scrollView.zoomScale = 1.0
        
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.showsHorizontalScrollIndicator = false
        
        webView.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        webView.scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        webView.scrollView.delaysContentTouches = false
        webView.scrollView.canCancelContentTouches = true
        
        view.addSubview(webView)
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if let finalURL = webView.url {
            if UserDefaults.standard.string(forKey: "finalURL") == nil {
                UserDefaults.standard.set(finalURL.absoluteString, forKey: "finalURL")
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.webView.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            self.webView.scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    private func setupToolbar() {
        navigationController?.isToolbarHidden = false
        
        navigationController?.toolbar.backgroundColor = .black
        navigationController?.toolbar.barTintColor = .black
        navigationController?.toolbar.isTranslucent = false
        
        let backButton = UIBarButtonItem(
            title: "←",
            style: .plain,
            target: self,
            action: #selector(goBack)
        )
        backButton.tintColor = .white
        
        let forwardButton = UIBarButtonItem(
            title: "→",
            style: .plain,
            target: self,
            action: #selector(goForward)
        )
        forwardButton.tintColor = .white
        
        toolbarItems = [
            backButton,
            UIBarButtonItem.flexibleSpace(),
            forwardButton
        ]
    }
    
    @objc private func goBack() {
        if webView.canGoBack {
            webView.goBack()
        }
    }
    
    @objc private func goForward() {
        if webView.canGoForward {
            webView.goForward()
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            if UIApplication.shared.delegate is AppDelegate {
                let viewController = ViewController()
                viewController.openApp()
            }
        }
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            if UIApplication.shared.delegate is AppDelegate {
                let viewController = ViewController()
                viewController.openApp()
            }
        }
    }
}
