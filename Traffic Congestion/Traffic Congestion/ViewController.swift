//
//  ViewController.swift
//  Traffic Congestion
//
//  Created by Oguz Cam on 12/4/15.
//  Copyright © 2015 Oguz Cam. All rights reserved.
//

import UIKit
import MapKit
import AddressBook

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    let regionRadius: CLLocationDistance = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        // set initial location in Honolulu
        let initialLocation = CLLocation(latitude: 41.055423, longitude: 29.024039)
        
        centerMapOnLocation(initialLocation)
        
        // show artwork on map
        let macfitClub = MacfitClub(title: "Macfit Ortaköy",
            locationName: "Ortaköy",
            discipline: "Sculpture",
            coordinate: CLLocationCoordinate2D(latitude: 41.048235, longitude:29.024365))
        
        mapView.addAnnotation(macfitClub)
    }

    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

