//
//  WeatherController.swift
//  Stormy
//
//  Created by Morgan Clayton on 2015-02-04.
//  Copyright (c) 2015 Foxted. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager!
    var location: CLLocationCoordinate2D!
    var locationName: String!
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var precipitationLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var refreshActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var locationLabel: UILabel!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        refreshActivityIndicator.hidden = true
        
        getLocalizedWeather()
        
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }

    @IBAction func refresh() {
        
        getLocalizedWeather()
        
        refreshButton.hidden = true
        refreshActivityIndicator.hidden = false
        refreshActivityIndicator.startAnimating()
        
    }
    
    func getLocalizedWeather() -> Void {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager:CLLocationManager, didUpdateLocations locations:[AnyObject]) -> Void {
        
        location = manager.location.coordinate
        
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: {(placemarks, error) -> Void in
            
            if error != nil {
                println("Reverse geocoder failed with error" + error.localizedDescription)
                return
            }
            if placemarks.count > 0 {
                let pm = placemarks[0] as CLPlacemark
                
                self.locationName = "\(pm.locality), \(pm.administrativeArea)"
            }
                
                
            else {
                println("Problem with the data received from geocoder")
            }
        
        })
        
        WeatherService.getCurrentWeatherData(currentView: self, completionHandler: updateViewLabels, errorHandler: stopRefreshButton)
        
    }
    
    /*
        Update labels on the view with current weather
    */
    func updateViewLabels(currentWeather: CurrentWeather) -> Void {    
        
        temperatureLabel.text = "\(currentWeather.temperatureCelcius)"
        iconView.image = currentWeather.icon!
        currentTimeLabel.text = "At \(currentWeather.currentTime!) it is"
        humidityLabel.text = "\(currentWeather.humidityRatio)%"
        precipitationLabel.text = "\(currentWeather.precipProbabilityRatio)%"
        summaryLabel.text = "\(currentWeather.summary)"
        if currentWeather.locationName != nil {
            locationLabel.text = "\(currentWeather.locationName)"
        }
        
        stopRefreshButton()
        
    }
    
    /*
        Stop refresh button
    */
    func stopRefreshButton() -> Void {
        
        refreshActivityIndicator.stopAnimating()
        refreshActivityIndicator.hidden = true
        refreshButton.hidden = false
        
    }

}

