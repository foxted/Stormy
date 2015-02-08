// Playground - noun: a place where people can play

import UIKit
import CoreLocation

class GeoCordDelegate: NSObject, CLLocationManagerDelegate {
    
    let locationMgr = CLLocationManager()
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        println("Updated Location")
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Error while updating location " + error.localizedDescription)
    }
    
    func locationManagerDidResumeLocationUpdates(manager: CLLocationManager!){
        println("Nah!")
    }
    
}


let locationMgr = CLLocationManager()

locationMgr.delegate = GeoCordDelegate()
locationMgr.desiredAccuracy = kCLLocationAccuracyBest


locationMgr.startUpdatingLocation()
locationMgr.location