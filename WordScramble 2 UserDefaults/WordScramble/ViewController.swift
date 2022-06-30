//
//  ViewController.swift
//  WordScramble
//
//  Created by Rev on 23/01/2022.
//

import UIKit

class ViewController: UITableViewController {
    var allWords : [String] = []
    var usedWords : [String] = []
    let initialDefaultRow = "Empty for now, add a new word!"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let startWordFilesUrl = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let contentOfFile = try? String(contentsOf: startWordFilesUrl) {
                allWords = contentOfFile.components(separatedBy: "\n")
            }
        }
        
        if allWords.isEmpty {
            allWords = ["silkworm", "armstorm"]
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForInput))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(restartGame))
        
        
        startGame()
        
        showBasicAlertAndReprompt(title: "Rules", message: "Please use the + button above to Add a new word that can be created from the letters of the shown word above, it has 8 letters.\nPress the Refresh button to restart the game with a new word!", reprompt: false)
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WordRow", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }

    
    @objc func startGame() {
        let defaults = UserDefaults.standard
        let savedWord = defaults.string(forKey: "chosenWord")
        let savedAnswers = defaults.object(forKey: "usedWords") as? [String]
        let chosenWord = savedWord ?? allWords.randomElement()
        title = chosenWord
        usedWords = savedAnswers ?? [initialDefaultRow]
        defaults.set(chosenWord, forKey: "chosenWord")
        saveAnswers()
        tableView.reloadData()
    }
    
    @objc func promptForInput(action : UIAlertAction? = nil) {
        // the arg above for better UX, when we show error after submitting we open it again by passing it as handler for the showBasicAlert Action
        
        let ac = UIAlertController(title: "Add a word", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak ac] _ in
            guard let inputedWord = ac?.textFields?[0].text else { return }
            self?.submitWord(inputedWord)
            
        }
        
        ac.addAction(UIAlertAction(title: "Close", style: .cancel))
        ac.addAction(submitAction)
        present(ac, animated: true)
        
    }
    
    
    func submitWord(_ word : String) {
        let errorTitle : String?
        let errorMessage : String?
        let word = word.lowercased()
        
        guard word != title else {
            errorTitle = "Obvious!"
            errorMessage = "Can't use the same magic word"
            showBasicAlertAndReprompt(title: errorTitle, message: errorMessage)
            return
        }
        
        guard word.count > 3 else {
            errorTitle = "Too Short!"
            errorMessage = "Words should at least be 4 characters long"
            showBasicAlertAndReprompt(title: errorTitle, message: errorMessage)
            return
        }
        
        if(isPossible(word)) {
            if(isOriginal(word)) {
                if(isReal(word)) {
                    // adding the word to the table
                    if !usedWords.isEmpty && usedWords[0] == initialDefaultRow {
                        usedWords.remove(at: 0)
                        tableView.reloadData()
                    }
                    
                    usedWords.insert(word, at: 0)
                    let idxPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [idxPath], with: .automatic)
                    saveAnswers()
                    return
                    
                } else {
                    errorTitle = "Invalid Word!"
                    errorMessage = "Nice word but \(word) doesn't exist in our dictionary, if it does please report to the goverment"
                }
            } else {
                errorTitle = "Already Exists!"
                errorMessage = "You already registered the word \(word), get more creative!"
            }
        } else {
            errorTitle = "Not Possible!"
            errorMessage = "It's not possible to make the word \(word) from the letters of \(title!)"
        }
        
        showBasicAlertAndReprompt(title: errorTitle, message: errorMessage)
    }
    
    func isPossible(_ word : String) -> Bool {
        guard var tempWord : String = title else { return false }
        for letter in word {
            if let idx = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: idx)
            } else {
                return false
            }
        }
        
        return true
    }

    func isOriginal(_ word : String) -> Bool {
        return !usedWords.contains(word)
    }
    
    func isReal(_ word : String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    
    
    func showBasicAlertAndReprompt(title: String? , message: String?, reprompt : Bool? = true) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: reprompt == true ? promptForInput : nil))
        present(ac, animated: true)
    }
    
    func saveAnswers() {
        let defaults = UserDefaults.standard
        defaults.set(usedWords, forKey: "usedWords")
    }
    
    @objc func restartGame() {
        let defaults = UserDefaults.standard
        defaults.set(nil, forKey: "chosenWord")
        defaults.set(nil, forKey: "usedWords")
        startGame()
    }
    

}

