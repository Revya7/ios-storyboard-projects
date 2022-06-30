//
//  ViewController.swift
//  FlagGame
//
//  Created by Rev on 1/16/22.
//  Copyright © 2022 Rev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = ["estonia", "germany", "us", "uk", "france", "italy", "ireland", "nigeria", "poland", "russia", "spain", "monaco"]
    var score : Int = 0
    var correctAnswer : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        askQuestion()
    }
    
    
    func askQuestion(action: UIAlertAction! = nil) {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        title = countries[correctAnswer].uppercased()
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
    }
    
    
    
    @IBAction func flagButtonPress(_ sender: UIButton) {
        let acTitle : String = sender.tag == correctAnswer ? "Correct" : "Wrong"
        score = sender.tag == correctAnswer ? score + 1 : score - 1
        
        let ac = UIAlertController(title: acTitle, message: "Your score is \(score)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
        present(ac, animated: true)
    
    }
    

}
