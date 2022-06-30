//
//  ViewController.swift
//  Faces to Names P9
//
//  Created by Rev on 13/02/2022.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    var people : [Person] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        loadPeople()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
        

        
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TheCell", for: indexPath) as? PersonCell else { fatalError("Cant dequeue PersonCell") }
        let person = people[indexPath.item]
        cell.nameLabel.text = person.name
        let imgPath = getDocumentsDirectory().appendingPathComponent(people[indexPath.item].imageName)
        cell.imageView.image = UIImage(contentsOfFile: imgPath.path)
        cell.imageView.layer.borderColor = UIColor.gray.cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        return cell
        
    }
    
    @objc func addNewPerson() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        let imgName = UUID().uuidString
        let imgPath = getDocumentsDirectory().appendingPathComponent(imgName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            // no need to check really it wont fail
            do {
                try jpegData.write(to: imgPath)
            } catch {
                print("failed to write image")
            }
            
        } else {
            print("failed to read image")
        }
        
        let person = Person(name: "Unknown", imageName: imgName)
        people.append(person)
        collectionView.reloadData()
        save()
        dismiss(animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let ac = UIAlertController(title: "Choose Action...", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Rename", style: .default, handler: {
            [weak self] _ in
            self?.showRenameAlert(indexPath: indexPath)
        }))
        
        ac.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {
            [weak self] _ in
            if let person = self?.people.remove(at: indexPath.item) {
                let imgPath = self?.getDocumentsDirectory().appendingPathComponent(person.imageName)
                self?.removeItemInDirectory(path: imgPath!)
                self?.collectionView.reloadData()
                self?.save()
            }
        }))
        
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        
        present(ac, animated: true)
    }

    
    func showRenameAlert(indexPath : IndexPath) {
        let ac = UIAlertController(title: "Rename", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "Rename", style: .default) {
            [weak self, weak ac] _ in
            guard let newName = ac?.textFields?[0].text else { return }
            if let person = self?.people[indexPath.item] {
                person.name = newName.trimmingCharacters(in: .whitespacesAndNewlines)
                self?.collectionView.reloadData()
                self?.save()
            }
        })
        
        present(ac, animated: true)
    }
    
    func removeItemInDirectory(path: URL) {
        let fileManager = FileManager.default
        guard fileManager.fileExists(atPath: path.path) else { return }
        
        do {
            try fileManager.removeItem(atPath: path.path)
            print("deleted!")
        } catch {
            print("Unexpected error: \(error). Could not delete")
        }
        
    }
    
    func save() {
        let encoder = JSONEncoder()
        if let encodedPeople = try? encoder.encode(people) {
            let defaults = UserDefaults.standard
            defaults.set(encodedPeople, forKey: "people")
            print("Saving done")
        } else {
            print("Couldnt save people, they all dead :(")
        }
    }
    
    func loadPeople() {
        let defaults = UserDefaults.standard
        if let savedPeople = defaults.object(forKey: "people") as? Data {
            let decoder = JSONDecoder()
            do {
                let peopleArr = try decoder.decode([Person].self, from: savedPeople)
                people = peopleArr
            } catch {
                print("Could not load people array")
            }
        }
    }
    
}

