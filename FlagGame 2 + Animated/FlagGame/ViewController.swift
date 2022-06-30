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
    var questionsAsked : Int = 0
    let maxQuestions : Int = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action , target: self, action: #selector(shareScore))
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        askQuestion()
    }
    
    
    func askQuestion(action: UIAlertAction! = nil) {
        questionsAsked += 1
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        title = countries[correctAnswer].uppercased() + " (Questions Left: \(maxQuestions - questionsAsked))"
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
    }
    
    
    func resetGame(action: UIAlertAction! = nil) {
        score = 0
        questionsAsked = 0
        askQuestion()
    }
    
    
    @IBAction func flagButtonPress(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1, delay: 0, options: []) {
            sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        } completion: { finished in
            UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 3, options: []) {
                sender.transform = .identity
            } completion: { finished in
                    
            }
        }

        
        var acTitle : String = sender.tag == correctAnswer ? "Correct" : "Wrong.\nYou selected the flag of \(countries[sender.tag].uppercased())"
        
        if (questionsAsked == maxQuestions - 1) {
                acTitle += "\nThe next question will be the last!"
        }
        
        score = sender.tag == correctAnswer ? score + 1 : score - 1
        
        let ac = UIAlertController(title: acTitle, message: "Your score is \(score) \(questionsAsked >= maxQuestions ? "\nGame Over!" : "")", preferredStyle: .alert)
        
        if (questionsAsked < maxQuestions) {
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
        } else {
            ac.addAction(UIAlertAction(title: "Restart", style: .default, handler: resetGame))
        }
        
        present(ac, animated: true)
    
    }
    
    
    @objc func shareScore() {
        
        let vc = UIActivityViewController(activityItems: ["Your Score is \(score)"], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    

}

