//
//  ActionViewController.swift
//  JSConsoleExt
//
//  Created by Rev on 28/02/2022.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

class ActionViewController: UIViewController {

    @IBOutlet var script: UITextView!
    var scriptsList : [[String:String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        //navigationItem.leftBarButtonItem = UIBarButtonItem(title: "More", style: .plain, target: self, action: #selector(showCodeExampleList))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "More", style: .plain, target: self, action: #selector(showMoreList))
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        if let inputItem = extensionContext!.inputItems.first as? NSExtensionItem {
            if let itemProvider = inputItem.attachments?.first {
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) {
                    [weak self] (dict, error) in
                    let itemDictionary = dict as! NSDictionary
                    let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as! NSDictionary

                    DispatchQueue.main.async {
                        self?.title = javaScriptValues["title"] as? String ?? "Title"
                    }
                }
            }
        }
        
        fetchScripts()
        
    }

    @objc func done() {
        let item = NSExtensionItem()
        guard let jscode = script.text else { return }
        let argument: NSDictionary = ["customJavaScript": jscode]
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
        item.attachments = [customJavaScript]

        extensionContext!.completeRequest(returningItems: [item])
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }

        let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            script.contentInset = UIEdgeInsets.zero
        } else {
            script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        script.scrollIndicatorInsets = script.contentInset

        let selectedRange = script.selectedRange
        script.scrollRangeToVisible(selectedRange)
    }
    
    @objc func showCodeExampleList() {
        let ac = UIAlertController(title: "Example Script", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Simple Alert", style: .default, handler: addTemplateCodeToScript))
        ac.addAction(UIAlertAction(title: "Alert current date", style: .default, handler: addTemplateCodeToScript))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        ac.popoverPresentationController?.barButtonItem = navigationItem.leftBarButtonItem
        
        present(ac, animated: true)
    }
    
    func addTemplateCodeToScript(action : UIAlertAction) {
        guard let actionTitle = action.title else { return }
        switch actionTitle {
        case "Simple Alert":
            script.text = "alert(document.title);"
            break
        case "Alert current date":
            script.text = """
            var today = new Date();
            var date = today.getFullYear()+'-'+(today.getMonth()+1)+'-'+today.getDate();
            alert(date);
            """
            break
        default:
            script.text = ""
        }
    }
    
    
    @objc func showMoreList() {
        let ac = UIAlertController(title: "More...", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Save", style: .default, handler: promptName))
        ac.addAction(UIAlertAction(title: "Load Scripts Table", style: .default, handler: loadScriptsTable))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        ac.popoverPresentationController?.barButtonItem = navigationItem.leftBarButtonItem
        
        present(ac, animated: true)
    }
    
    func promptName(action : UIAlertAction) {
        let ac = UIAlertController(title: "Enter a name", message: "Please enter a name for the script", preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Save", style: .default, handler: {
            [weak self, weak ac] _ in
            guard let theName = ac?.textFields?[0].text else { return }
            self?.saveScript(name: theName)
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
    }
    
    func fetchScripts() {
        let defaults = UserDefaults.standard
        if let savedPeople = defaults.object(forKey: "scriptsList") as? Data
         {
            let jsonDecoder = JSONDecoder()
            do {
                scriptsList = try jsonDecoder.decode([[String: String]].self, from: savedPeople)
            } catch {
                print("Failed to load people")
            }
        }
    }
    
    func loadScriptsTable(action : UIAlertAction) {
        let tableView = TableViewController()
        tableView.scripts = scriptsList
        tableView.textView = script
        navigationController?.pushViewController(tableView, animated: true)
    }
    
    func saveScript(name newName: String) {
        guard let scriptContent = script.text else { return }
        let newScriptObj = ["name" : newName, "content": scriptContent]
        var overwrite : Bool = false
        
        for (idx, scriptObj) in scriptsList.enumerated() {
            if scriptObj["name"] == newName {
//                showAlert(title: "Error", msg: "The name provided is already used for another script")
//                return
                scriptsList[idx] = newScriptObj
                overwrite = true
            }
        }
        
        if !overwrite {
            scriptsList.append(newScriptObj)
        }
        
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(scriptsList) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "scriptsList")
            showAlert(title: "\(overwrite ? "Overwritten!" : "Saved!")")
        } else {
            print("Wont really happen but coulnd save people, they ded")
        }
    }
    
    func showAlert(title : String? = nil, msg: String? = nil) {
        let ac = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(ac, animated: true)
    }

}
