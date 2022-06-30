//
//  SiteTableTableViewController.swift
//  Simple Browser
//
//  Created by Rev on 23/01/2022.
//

import UIKit

class SiteTableTableViewController: UITableViewController {
    var safeSites = ["semicolonlb.net", "facebook.com", "apple.com", "google.com"]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sites Table"

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return safeSites.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SiteHere", for: indexPath)
        cell.textLabel?.text = safeSites[indexPath.row]
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let wvc = storyboard?.instantiateViewController(withIdentifier: "TheWebView") as? ViewController {
            wvc.safeSites = safeSites
            wvc.selectedSiteIdx = indexPath.row
            navigationController?.pushViewController(wvc, animated: true)
        }
    }


}
