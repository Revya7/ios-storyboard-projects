//
//  ViewController.swift
//  Map Capital P16
//
//  Created by Rev on 26/02/2022.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let capitalsInfo : [String : [Double]] = [
            "London" : [51.507222, -0.1275],
            "Oslo" : [59.95, 10.75],
            "Paris": [48.8567, 2.3508],
            "Rome": [41.9, 12.5],
            "Washington": [38.895111, -77.036667],
            "Beirut": [33.8938, 35.5018],
        ]
        
        for (capitalName, capitalCoords) in capitalsInfo {
            let location = CLLocationCoordinate2D(latitude: capitalCoords[0], longitude: capitalCoords[1])
            let newCapital = Capital(location: location, info: "This is the capital: \(capitalName)", title: capitalName)
            mapView.addAnnotations([newCapital])
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(showMapModes))
        
        title = "Map"

    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Capital else { return nil }
        
        let identifier = "Capital"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier:  identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            annotationView?.annotation = annotation
        }
        
        if let annotationPin = annotationView as? MKPinAnnotationView {
            annotationPin.pinTintColor = .purple
        }
        
        return annotationView
    }


    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capitalAnnotation = view.annotation as? Capital else { return }
        
        //let ac = UIAlertController(title: capitalAnnotation.title, message: capitalAnnotation.info, preferredStyle: .alert)
        //ac.addAction(UIAlertAction(title: "OK", style: .default))
        //present(ac, animated: true)
        
        if let url = URL(string: "https://wikipedia.org/wiki/\(capitalAnnotation.title ?? "")") {
            let theWebView = DetailWebViewController()
            theWebView.url = url
            navigationController?.pushViewController(theWebView, animated: true)
        }
        
    }
    
    @objc func showMapModes() {
        let ac = UIAlertController(title: "Mode", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Standard", style: .default, handler: changeMapType))
        ac.addAction(UIAlertAction(title: "Satellite", style: .default, handler: changeMapType))
        ac.addAction(UIAlertAction(title: "Hybrid", style: .default, handler: changeMapType))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        
        present(ac, animated: true)
        
    }
    
    func changeMapType(action : UIAlertAction) {
        guard let actionTitle = action.title else { return }
        switch actionTitle {
        case "Standard":
            mapView.mapType = .standard
            break
        case "Satellite":
            mapView.mapType = .satellite
            break
        case "Hybrid":
            mapView.mapType = .hybrid
            break
        default:
        mapView.mapType = .standard
            break
        }
    }
    
}

