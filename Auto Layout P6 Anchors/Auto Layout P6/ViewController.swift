//
//  ViewController.swift
//  Auto Layout P6
//
//  Created by Rev on 29/01/2022.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var viewDictionary : [String: UILabel] = [:]
        var labelsArr : [UILabel] = []
        
        let textArr = ["These", "Labels" ,"Are", "SO", "Cool"]
        let colors = [UIColor.red, UIColor.cyan, UIColor.yellow, UIColor.green, UIColor.orange]
        
        guard textArr.count == colors.count else { print("Check arrays should be same count"); return}
        
        for num in 0...textArr.count-1 {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = textArr[num]
            label.backgroundColor = colors[num]
            viewDictionary["label\(num)"] = label
            label.sizeToFit()
            
            view.addSubview(label)
            
            labelsArr.append(label)
            
        }
        
        
        var prevLabel : UILabel?
        for (idx, label) in labelsArr.enumerated() {
            
            label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
            
            label.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/5, constant: -10).isActive = true
            
            if let prevLabel = prevLabel {
                label.topAnchor.constraint(equalTo: prevLabel.bottomAnchor, constant: 10).isActive = true
            } else {
                // first label, we want to exclude that area in the iphone 11+ that has battery and wifi etc
                label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
            }
            
            prevLabel = label
            
            if(idx == labelsArr.count-1) {
                label.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
            }
            
        }
        

        
        
        
        
    }


}

