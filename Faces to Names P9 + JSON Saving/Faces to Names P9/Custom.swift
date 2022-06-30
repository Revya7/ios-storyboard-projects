//
//  Custom.swift
//  Faces to Names P9
//
//  Created by Rev on 13/02/2022.
//

import Foundation

class Person : NSObject, Codable {
    var name : String
    var imageName : String
    
    init(name : String, imageName : String) {
        self.name = name
        self.imageName = imageName
    }
}


extension FileManager {
    func urls(for directory: FileManager.SearchPathDirectory, skipsHiddenFiles: Bool = true ) -> [URL]? {
        let documentsURL = urls(for: directory, in: .userDomainMask)[0]
        let fileURLs = try? contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil, options: skipsHiddenFiles ? .skipsHiddenFiles : [] )
        return fileURLs
    }
}


