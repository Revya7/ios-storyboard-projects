//
//  ViewController.swift
//  Simple Browser
//
//  Created by Rev on 21/01/2022.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    var webView : WKWebView!
    var safeSites = ["apple.com", "google.com"] // will be set from the table but will leave this as default
    var selectedSiteIdx : Int? = 0
    var progressView : UIProgressView!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print(#keyPath(WKWebView.estimatedProgress))
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        // enabling toolbar
        navigationController?.isToolbarHidden = false
        
        // creating progressView and wrap it in bar button
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        
        // creating spacer
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: webView, action: #selector(webView.goBack))
        let forwardButton = UIBarButtonItem(title: "Forward", style: .plain, target: webView, action: #selector(webView.goForward))
        
        // setting toolbar items
        toolbarItems = [backButton, spacer, progressButton, spacer, refreshButton, spacer, forwardButton]
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openSiteList))
        
        let defaultUrl = URL(string: "https://" + safeSites[selectedSiteIdx!])!
        webView.load(URLRequest(url: defaultUrl))
        
    }
    
    
    @objc func openSiteList() {
        let ac = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        
        for site in safeSites {
            ac.addAction(UIAlertAction(title: site, style: .default, handler: loadTheSite))
        }
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
    }
    
    
    func loadTheSite(action: UIAlertAction) {
        if let siteName = action.title {
            let theUrl = URL(string: "https://" + siteName)!
            webView.load(URLRequest(url: theUrl))
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        let url = navigationAction.request.url
        
        if let siteUrl = url?.host {
            
            // we check if the string siteUrl contains any element of the array not vv, since str.contains like indexOf
            for site in safeSites {
                if siteUrl.contains(site) {
                    decisionHandler(.allow)
                    return
                }
            }
            
            print("the site that failed is: " + siteUrl)
            let ac = UIAlertController(title: "Sorry", message: "The site is blocked", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default))
            present(ac, animated: true)

        }
        
        decisionHandler(.cancel)
        
    }
    
}
