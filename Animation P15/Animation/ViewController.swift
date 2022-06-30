//
//  ViewController.swift
//  Animation
//
//  Created by Rev on 24/02/2022.
//

import UIKit

class ViewController: UIViewController {
    var currentAnimation = 0
    var imageView : UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView = UIImageView(image: UIImage(named: "penguin"))
        imageView.center = view.center
        view.addSubview(imageView)
    }

    @IBAction func tapped(_ sender: UIButton) {
        sender.isHidden = true
        
        //UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations: {
            switch self.currentAnimation {
            case 0:
                self.imageView.transform = CGAffineTransform(scaleX: 2, y: 2)
                break
            case 1:
                self.imageView.transform = .identity
                break
            case 2:
                self.imageView.transform = CGAffineTransform(translationX: -100, y: -100)
                break
            case 3:
                self.imageView.transform = .identity
            case 4:
                self.imageView.transform = CGAffineTransform(rotationAngle: .pi)
                break
            case 5:
                self.imageView.transform = .identity
                break
            case 6:
                self.imageView.alpha = 0
                break
            case 7:
                self.imageView.alpha = 1
            default:
                break
            }
        }, completion: {
            finished in
            sender.isHidden = false
        })
    
        currentAnimation += 1
        if currentAnimation > 7 {
            currentAnimation = 0
        }
        
    }
    
}

