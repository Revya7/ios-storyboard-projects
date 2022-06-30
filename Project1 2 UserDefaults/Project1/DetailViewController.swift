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
        
        title = selectedImago
        navigationItem.largeTitleDisplayMode = .never
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
