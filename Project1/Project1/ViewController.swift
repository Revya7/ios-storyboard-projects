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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        print(path)
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasSuffix(".jpg") || item.hasSuffix(".png") {
                pics.append(item)
            }
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pics.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Pichere", for: indexPath)
        cell.textLabel?.text = pics[indexPath.row]
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detaily") as? DetailViewController {
            vc.selectedImago = pics[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }

}

