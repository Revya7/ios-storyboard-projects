//
//  DetailViewController.swift
//  Project1
//
//  Created by Rev on 1/15/22.
//  Copyright © 2022 Rev. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var myImageView: UIImageView!
    var selectedImago : String?
    
    override func viewDidLoad() {
        
        assert(selectedImago != nil, "Should not intistantiate this view without passing the image")
        
        title = selectedImago
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        super.viewDidLoad()

        if let imageToLoad = selectedImago {
            myImageView.image = UIImage(named: imageToLoad)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.hidesBarsOnTap = false
    }
    
    @objc func shareTapped() {
        guard let imageOnScreen = myImageView.image?.jpegData(compressionQuality: 0.8) else {
            print("No image found in this view's image view")
            return
        }
        
        let vc = UIActivityViewController(activityItems: [imageOnScreen, selectedImago!], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
        
    }
    

}
