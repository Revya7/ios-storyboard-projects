//
//  DetailViewController.swift
//  JSONApp
//
//  Created by Rev on 04/02/2022.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    var webView : WKWebView!
    var detailItem : Petition?
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let detailItem = detailItem else { return }
        
        let htmlString = """
            <html>
                <head>
                <meta name="viewport" content="width=device-width, initial-scale=1" />
                <style>
                    body {
                        padding: 10px;
                    }
                    .theBody {
                        font-size: 140%;
                        text-align: justify;
                    }
                </style>
                </head>
                <body>
                    <h1>\(detailItem.title)</h1>
                    <div class="theBody">
                        \(detailItem.body)
                    </div>
                </body>
            </html>
        """
        
        webView.loadHTMLString(htmlString, baseURL: nil)

        
    }
    

}
