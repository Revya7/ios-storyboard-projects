//
//  ViewController.swift
//  Project1
//
//  Created by Rev on 1/14/22.
//  Copyright © 2022 Rev. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var pics : [String] = []
    var visitsDict : [String: Int] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        print(path)
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        if let dict = UserDefaults.standard.object(forKey: "visits") as? [String: Int] {
            visitsDict = dict
        }
        
        for item in items {
            if item.hasSuffix(".jpg") || item.hasSuffix(".png") {
                pics.append(item)
                if visitsDict[item] == nil {
                    visitsDict[item] = 0
                }
            }
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pics.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Pichere", for: indexPath)
        cell.textLabel?.text = pics[indexPath.row] + " (visited \(visitsDict[pics[indexPath.row]] ?? 0) times)"
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detaily") as? DetailViewController {
            vc.selectedImago = pics[indexPath.row]
            visitsDict[pics[indexPath.row]]? +=  1
            saveDict()
            navigationController?.pushViewController(vc, animated: true)
            tableView.reloadData()
        }
    }
    
    func saveDict() {
        let defaults = UserDefaults.standard
        defaults.set(visitsDict, forKey: "visits")
    }

}

