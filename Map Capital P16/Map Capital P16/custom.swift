//
//  custom.swift
//  Map Capital P16
//
//  Created by Rev on 26/02/2022.
//

import Foundation
import MapKit

class Capital : NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title : String?
    var info : String
    
    init(location : CLLocationCoordinate2D, info: String, title: String? = nil) {
        self.coordinate = location
        self.title = title
        self.info = info
    }
}
