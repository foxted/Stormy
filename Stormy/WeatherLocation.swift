//
//  WeatherLocation.swift
//  Stormy
//
//  Created by Morgan Clayton on 2015-02-07.
//  Copyright (c) 2015 Foxted. All rights reserved.
//

import Foundation
import CoreLocation

class WeatherLocation: NSObject, CLLocationManagerDelegate {
    
    var delegate: CLLocationManager = CLLocationManager()
    
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
    
        println("Updated!")
        
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        
        println("Error!!")
        
    }
    
}