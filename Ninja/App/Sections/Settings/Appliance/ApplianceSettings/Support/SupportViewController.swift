//
//  SupportViewController.swift
//  Ninja - Unstable
//
//  Created by Martin Burch on 9/27/22.
//

import UIKit
import WebKit

class SupportViewController: BaseViewController<WKWebView> {
    
    private let viewModel: SettingsViewModel = .shared()
                
    override func setupViews() {
        hidesBottomBarWhenPushed = true
        tabBarController?.tabBar.isHidden = true
        
        subview.navigationDelegate = self
        loadAppropriateSupportPage()
    }
    
    func loadAppropriateSupportPage() {
        guard let url = viewModel.getSupportURL() else { return }
        let request = URLRequest(url: url)
        subview.load(request)
    }
}

extension SupportViewController: WKNavigationDelegate {
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
