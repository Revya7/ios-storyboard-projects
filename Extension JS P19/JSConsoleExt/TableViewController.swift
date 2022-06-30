//
//  TableViewController.swift
//  JSConsoleExt
//
//  Created by Rev on 01/03/2022.
//

import UIKit

class TableViewController: UITableViewController {
    
    var scripts = [[String: String]]()
    weak var textView : UITextView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ScriptCell")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scripts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "ScriptCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: identifier)
        }
        
        let scriptObj = scripts[indexPath.row]
        cell!.textLabel?.text = scriptObj["name"]
        cell!.detailTextLabel?.text = scriptObj["content"]

        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let scriptObj = scripts[indexPath.row]
        textView?.text = scriptObj["content"]
        _ = navigationController?.popViewController(animated: true)
    }


}
