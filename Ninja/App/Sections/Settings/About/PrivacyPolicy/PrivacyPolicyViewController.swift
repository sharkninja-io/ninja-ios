//
//  PrivacyPolicyWebViewController.swift
//  Ninja
//
//  Created by Richard Jacobson on 6/9/23.
//

import Foundation
import WebKit

class PrivacyPolicyViewController: BaseViewController<WKWebView> {
    
    private var viewModel: SettingsViewModel = .shared()
    
    override func setupViews() {
        subview.navigationDelegate = self
        loadWebPage()
    }
    
    func loadWebPage() {
        guard let url = viewModel.getPrivacyPolicyURL() else { return }
        let request = URLRequest(url: url)
        subview.load(request)
    }
}

extension PrivacyPolicyViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard navigationAction.navigationType == .linkActivated else {
            decisionHandler(.allow)
            return
        }
        
        guard let url = navigationAction.request.url else {
            decisionHandler(.allow)
            return
        }
        
        if url.absoluteString.hasPrefix("tel:"), let phoneURL = URL(string: url.absoluteString.replacingOccurrences(of: "tel:", with: "tel://")) {
            if UIApplication.shared.canOpenURL(phoneURL) {
                UIApplication.shared.open(phoneURL)
            }
        } else {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
        
        decisionHandler(.cancel)
    }
}
