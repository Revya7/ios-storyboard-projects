//
//  Custom.swift
//  JSONApp
//
//  Created by Rev on 02/02/2022.
//

import Foundation


struct Petition : Codable {
    var title : String
    var body : String
}


struct Petitions : Codable {
    var results : [Petition]
}
