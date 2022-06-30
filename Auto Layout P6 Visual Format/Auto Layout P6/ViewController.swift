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
            
            view.addConstraints(NSLayoutConstraint.constraints(
                withVisualFormat: "H:|[label\(num)]|", options: [], metrics: nil, views: viewDictionary))
        }
        
        let metrics = [ "labelHeight" : 88 ]
        
        view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[label0(labelHeight@999)]-[label1(label0)]-[label2(label0)]-[label3(label0)]-[label4(label0)]-(>=10)-|", options: [], metrics: metrics, views: viewDictionary))
        
        
        
        
    }


}

