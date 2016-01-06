//
//  ViewController.swift
//  Traffic Congestion
//
//  Created by Oguz Cam on 12/4/15.
//  Copyright © 2015 Oguz Cam. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var manager = CLLocationManager()
    var speed = -1.0
    var intervalTime = 10
    var mapCentralized = false
    let formatter = NSDateFormatter()

    var timer:NSTimer!
    var lastLocation:CLLocation!
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBAction func playBtnPressed(sender: AnyObject) {
        if timer == nil {
            lastLocation = nil
            speed = -1.0
            manager.requestLocation()
            timer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(intervalTime), target: self, selector: "timerDone", userInfo: nil, repeats: true)
        }
    }
    
    @IBAction func stopBtnPressed(sender: AnyObject) {
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
    }
    
    @IBAction func refreshBtnPressed(sender: AnyObject) {
        stopBtnPressed(NSObject())
        let mapOverlays = mapView.overlays
        mapView.removeOverlays(mapOverlays)
        let mapAnnotations = mapView.annotations
        mapView.removeAnnotations(mapAnnotations)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MapView Delegate Self
        mapView.delegate = self
        
        // Core Location
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.requestLocation()
        // Core Location
        
        // Show User Location
        mapView.showsUserLocation = true
        
        formatter.dateFormat = "HH:mm:ss"
    }
    
    func timerDone() {
        manager.requestLocation()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let date = NSDate()
        
        let userLocation:CLLocation = locations.last!
        let latitudeByUserLocation = userLocation.coordinate.latitude
        let longitudeByUserLocation = userLocation.coordinate.longitude
        
        speedLabel.text = "Speed: " + String(userLocation.speed) + " m/s"
        timeLabel.text = "Time: " + formatter.stringFromDate(date)
        
        // Location Update
        let locationCore:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitudeByUserLocation , longitude: longitudeByUserLocation) //Coordinates
        
        centerMapOnLocation(locationCore)
        
        if lastLocation == nil {
            lastLocation = userLocation
            addPinToMap(locationCore, title: "Start point", subtitle: "")
        } else {
            let startPlacemark = MKPlacemark(coordinate: CLLocationCoordinate2DMake(
                lastLocation.coordinate.latitude, lastLocation.coordinate.longitude
                ), addressDictionary: nil)
            let startMapItem = MKMapItem(placemark: startPlacemark)
            let endMapItem = MKMapItem.mapItemForCurrentLocation()
            
            let autoMobileRouteRequest = MKDirectionsRequest();
            autoMobileRouteRequest.transportType = MKDirectionsTransportType.Automobile;
            autoMobileRouteRequest.source = startMapItem
            autoMobileRouteRequest.destination = endMapItem
            autoMobileRouteRequest.requestsAlternateRoutes = false
            
            let directions = MKDirections(request: autoMobileRouteRequest)
            directions.calculateDirectionsWithCompletionHandler {(response, errors) -> Void in
                if (errors != nil) {
                    print(errors)
                } else {
                    for route in response!.routes {
                        print("\(route.distance) meters")
                        self.speed = route.distance * 6 * 60 / 1000
                        
                        self.addPinToMap(locationCore, kmPerHour: self.speed, date: date)
                        
                        self.mapView.addOverlay(route.polyline,
                            level: MKOverlayLevel.AboveRoads)
                        self.lastLocation = userLocation
                        break
                    }
                    
                }
            }
        }
    }
    
    
    // Set map on screen
    func centerMapOnLocation(location: CLLocationCoordinate2D) {
        let theSpan = MKCoordinateSpanMake(0.01, 0.01)
        let coordinateRegion = MKCoordinateRegionMake(location, theSpan)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    
    // Add pin
    func addPinToMap(location: CLLocationCoordinate2D, kmPerHour: Double, date: NSDate) {
        // add pin
        let currentLoc = MKPointAnnotation()
        currentLoc.title = String(kmPerHour) + " km/h"
        currentLoc.subtitle = formatter.stringFromDate(date)
        currentLoc.coordinate = location
        
        mapView.addAnnotation(currentLoc)
    }
    
    func addPinToMap(location: CLLocationCoordinate2D, title: String, subtitle: String) {
        // add pin
        let currentLoc = MKPointAnnotation()
        currentLoc.title = title
        currentLoc.subtitle = subtitle
        currentLoc.coordinate = location
        
        mapView.addAnnotation(currentLoc)
    }
    
    // This one draws the rout on the map using map overlays
    // you need to make sure that the delegate for the mapview in the storyboard
    // is set to this class
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer
    {
        let draw = MKPolylineRenderer(overlay: overlay)
        
        switch(speed){
        case 0...20:
            draw.strokeColor = UIColor.redColor()
        case 21...40:
            draw.strokeColor = UIColor.orangeColor()
        case 41...60:
            draw.strokeColor = UIColor.yellowColor()
        case 61...500:
            draw.strokeColor = UIColor.greenColor()
        default:
            // Light Blue
            draw.strokeColor = UIColor.init(colorLiteralRed: 0.0, green: 0.8, blue: 1.0, alpha: 1)
        }
        draw.lineWidth = 5.0
        return draw
    }
    
    // Function to catch any errors
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Location has failed \(error)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

    