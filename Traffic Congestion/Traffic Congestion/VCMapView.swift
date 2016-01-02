//
//  VCMapView.swift
//  Traffic Congestion
//
//  Created by Oguz Cam on 12/4/15.
//  Copyright © 2015 Oguz Cam. All rights reserved.
//

import Foundation
import MapKit

extension ViewController: MKMapViewDelegate {
    
    // 1
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? MacfitClub {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
                as? MKPinAnnotationView { // 2
                    dequeuedView.annotation = annotation
                    view = dequeuedView
            } else {
                // 3
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton.init(type: UIButtonType.DetailDisclosure) as UIView
            }
            return view
        }
        return nil
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView,
        calloutAccessoryControlTapped control: UIControl) {
            let location = view.annotation as! MacfitClub
            let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
            location.mapItem().openInMapsWithLaunchOptions(launchOptions)
    }
}