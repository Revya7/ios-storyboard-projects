//
//  Custom.swift
//  Faces to Names P9
//
//  Created by Rev on 13/02/2022.
//

import Foundation

class Person : NSObject {
    var name : String
    var imagePath : URL
    
    init(name : String, imagePath : URL) {
        self.name = name
        self.imagePath = imagePath
    }
}
