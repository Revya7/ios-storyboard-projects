//
//  DetailWebViewController.swift
//  Map Capital P16
//
//  Created by Rev on 26/02/2022.
//

import UIKit
import WebKit

class DetailWebViewController : UIViewController {
    var webView : WKWebView!
    var url : URL?
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Wikipedia"
        if let url = url {
            webView.load(URLRequest(url: url))
        }
    }

}

