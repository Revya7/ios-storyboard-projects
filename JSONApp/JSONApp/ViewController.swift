//
//  ViewController.swift
//  JSONApp
//
//  Created by Rev on 02/02/2022.
//

import UIKit

class ViewController: UITableViewController {
    var petitions : [Petition] = []
    var petitionsCache : [Petition] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // sync approach (bad)
        let urlString : String
        
        // maybe download these JSON files and put locally and access as local url
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                addSearch()
                parse(json: data)
                return
            }
        }
        
        showError()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = petitions[indexPath.row].title
        cell.detailTextLabel?.text = petitions[indexPath.row].body
        return cell
    }

    func parse(json : Data) {
        let decoder = JSONDecoder()
        if let jsonObj = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonObj.results
            petitionsCache = jsonObj.results
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showError() {
        let ac = UIAlertController(title: "Loading Error", message: "Please check your connection and try again later", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    
    func addSearch() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(callSearchAc))
    }
    
    @objc func callSearchAc() {
        let ac = UIAlertController(title: "Search Petition", message: "Type anything inside the title or the body of a petition to search (min 3 characters or empty for reset)", preferredStyle: .alert)
        ac.addTextField()
        let searchAction = UIAlertAction(title: "Search", style: .default) {
            [weak self, weak ac] _ in
            guard let userInput = ac?.textFields?[0].text else { return }
            self?.searchPetition(userInput)
        }
        ac.addAction(searchAction)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func searchPetition(_ str : String) {
        var newArr : [Petition] = []
        if str.count == 0 {
            petitions = petitionsCache
            tableView.reloadData()
            return
        }
        guard str.count > 2 else { return }
        let str = str.lowercased()
        for petition in petitions {
            if(petition.title.lowercased().contains(str) || petition.body.lowercased().contains(str)) {
                newArr.append(petition)
            }
        }
        
        petitions = newArr
        tableView.reloadData()
    }

}

