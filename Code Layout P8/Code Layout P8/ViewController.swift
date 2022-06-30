//
//  ViewController.swift
//  Code Layout P8
//
//  Created by Rev on 06/02/2022.
//

import UIKit

class ViewController: UIViewController {
    var scoreLabel: UILabel!
    var cluesLabel : UILabel!
    var answerLabel: UILabel!
    var currentAnswer : UITextField!
    var lettersButtons = [UIButton]()
    var submitButton : UIButton!
    var clearButton : UIButton!
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var level = 1
    var allCorrectAnswers = [String]()
    var allLettersBits = [String]()
    var activatedButtons = [UIButton]()
    var correctAnswerGuessed = [String]()
    
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.text = "Score: \(score)"
        scoreLabel.textAlignment = .right
        view.addSubview(scoreLabel)
        
        cluesLabel = UILabel()
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        cluesLabel.text = "CLUES HERE"
        cluesLabel.numberOfLines = 0
        cluesLabel.font = UIFont.systemFont(ofSize: 24)
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(cluesLabel)
        
        answerLabel = UILabel()
        answerLabel.translatesAutoresizingMaskIntoConstraints = false
        answerLabel.text = "ANSWERS HERE"
        answerLabel.textAlignment = .right
        answerLabel.numberOfLines = 0
        answerLabel.font = UIFont.systemFont(ofSize: 24)
        answerLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(answerLabel)
        
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.isUserInteractionEnabled = false
        currentAnswer.placeholder = "Tab letters to guess"
        currentAnswer.font = UIFont.systemFont(ofSize: 44)
        view.addSubview(currentAnswer)
        
        
        submitButton = UIButton(type: .system)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.setTitle("Submit", for: .normal)
        submitButton.addTarget(self, action: #selector(submitAnswer), for: .touchUpInside)
        view.addSubview(submitButton)
        
        clearButton = UIButton(type: .system)
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        clearButton.setTitle("Clear", for: .normal)
        clearButton.addTarget(self, action: #selector(clearAnswer), for: .touchUpInside)
        view.addSubview(clearButton)
        
        
        let buttonContainer = UIView()
        buttonContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonContainer)
        //buttonContainer.layer.borderWidth = 1
        //buttonContainer.layer.borderColor = UIColor.gray.cgColor
        
        
        
        NSLayoutConstraint.activate([
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            
            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
            cluesLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6, constant: -100),
            
            answerLabel.topAnchor.constraint(equalTo: cluesLabel.topAnchor),
            answerLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
            answerLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
            answerLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4, constant: -100),
            
            currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            submitButton.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            submitButton.heightAnchor.constraint(equalToConstant: 44),
            clearButton.topAnchor.constraint(equalTo: submitButton.topAnchor),
            clearButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            clearButton.heightAnchor.constraint(equalToConstant: 44),
            clearButton.centerYAnchor.constraint(equalTo: submitButton.centerYAnchor),
            
            buttonContainer.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 20),
            buttonContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonContainer.widthAnchor.constraint(equalToConstant: 750),
            buttonContainer.heightAnchor.constraint(equalToConstant: 320),
            buttonContainer.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
            
        ])
        
        let buttonWidth = 150
        let buttonHeight = 80
        
        for row in 0..<4 {
            for column in 0..<5 {
                let button = UIButton(type: .system)
                button.setTitle("WWW", for: .normal)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                let frame = CGRect(x: column * buttonWidth, y: row * buttonHeight, width: buttonWidth, height: buttonHeight)
                button.frame = frame
                button.addTarget(self, action: #selector(letterButtonClicked), for: .touchUpInside)
                lettersButtons.append(button)
                buttonContainer.addSubview(button)
            }
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadLevel()
    }


    @objc func submitAnswer(_ sender : UIButton) {
        guard let answer = currentAnswer.text else { return }
        if let pos = allCorrectAnswers.firstIndex(of: answer) {
            score += 1
            activatedButtons.removeAll(keepingCapacity: true)
            currentAnswer.text = ""
            
            if var lines = answerLabel.text?.components(separatedBy: "\n") {
                lines[pos] = answer
                answerLabel.text = lines.joined(separator: "\n")
            }
            
            correctAnswerGuessed.append(answer)
            
            if correctAnswerGuessed.count % allCorrectAnswers.count == 0 {
                levelUp()
            }
        } else {
            let ac = UIAlertController(title: "Wrong!", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            score -= 1
        }
    }
    
    @objc func clearAnswer(_ sender : UIButton) {
        currentAnswer.text = ""
        for btn in activatedButtons {
            btn.isHidden = false
        }
        activatedButtons.removeAll(keepingCapacity: true)
    }
    
    @objc func letterButtonClicked(_ sender : UIButton) {
        guard let buttonTitle = sender.title(for: .normal) else { return }
        sender.isHidden = true
        activatedButtons.append(sender)
        currentAnswer.text? += buttonTitle
        
    }
    
    func loadLevel() {
        cluesLabel.text = ""
        answerLabel.text = ""
        allCorrectAnswers = []
        allLettersBits = []
        correctAnswerGuessed = []
        
        var cluesString = ""
        var answersString = ""
        
        DispatchQueue.global(qos: .userInteractive).async {
            [weak self] in
            if let levelUrl = Bundle.main.url(forResource: "level\(self?.level ?? 0)", withExtension: "txt") {
                if let content = try? String.init(contentsOf: levelUrl) {
                    // TH|NG|SE: Hint here
                    var lines = content.components(separatedBy: "\n")
                    lines.shuffle()
                    
                    for (idx, line) in lines.enumerated() {
                        let parts = line.components(separatedBy: ": ")
                        let lettersMech = parts[0]
                        let clue = parts[1]
                        
                        let solution = lettersMech.replacingOccurrences(of: "|", with: "")
                        self?.allCorrectAnswers.append(solution)
                        
                        // adding letters bit to the global array
                        let theLettersBit = lettersMech.components(separatedBy: "|")
                        self?.allLettersBits += theLettersBit
                        
                        // updating the labelses string, will be set after all if any trimmed
                        cluesString += "\(idx+1). \(clue)\n"
                        answersString += "\(solution.count) letters\n"
                    
                    }
                }
            } else {
                DispatchQueue.main.async {
                    [weak self] in
                    let ac = UIAlertController(title: "GG!", message: "You have finished the last level, there's no more levels to load. Good game!\nScore: \(self?.score ?? 0)", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "Reset Game", style: .default, handler: {
                        [weak self] _ in
                        self?.resetGame()
                    }))
                    
                    self?.present(ac , animated: true)
                    return
                }
            }
            
            DispatchQueue.main.async {
                [weak self] in
                
                // enabling all buttons again here
                for btn in self?.lettersButtons ?? [] {
                    btn.isHidden = false
                }
                
                self?.cluesLabel.text = cluesString.trimmingCharacters(in: .whitespacesAndNewlines)
                self?.answerLabel.text = answersString.trimmingCharacters(in: .whitespacesAndNewlines)
                
                if self?.allLettersBits.count == self?.lettersButtons.count {
                    self?.allLettersBits.shuffle()
                    
                    for (i , button) in self?.lettersButtons.enumerated() ?? [].enumerated() {
                        button.setTitle(self?.allLettersBits[i], for: .normal)
                    }
                } else {
                    print("The letter bits should be equal to the number of buttons which is fixed for now and is equal to \(self?.lettersButtons.count ?? 0)")
                }
                
            }
        }
    }
    
    
    func levelUp() {
        level += 1
        let ac = UIAlertController(title: "Level Complete!", message: "You have finished this level, it's time to load the next one!", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Let's Go!", style: .default, handler: {
            [weak self] _ in
            self?.loadLevel()
        }))
        present(ac, animated: true)
    }
    
    func resetGame() {
        level = 1
        score = 0
        loadLevel()
    }
    
}

