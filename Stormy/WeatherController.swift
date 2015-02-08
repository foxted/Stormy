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
                self.showGeolocationError()

                self.backtoDefault()
            }
            if placemarks.count > 0 {
                let pm = placemarks[0] as CLPlacemark
                
                if pm.locality != nil {
                    switch(pm.country){
                        case "Canada", "US":
                            self.locationName = "\(pm.locality), \(pm.administrativeArea)"
                        default:
                            self.locationName = "\(pm.locality)"
                    }
                }
                else if pm.country != nil{
                    self.locationName = "\(pm.country)"
                }
            }
            else {
                self.showGeolocationError()
                self.backtoDefault()
            }
        
        })
        
        WeatherService.getCurrentWeatherData(currentView: self, completionHandler: updateViewLabels, errorHandler: stopRefreshButton)
        
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        
        showGeolocationError()
        
        backtoDefault()

    }
    
    /*
        Update labels on the view with current weather
    */
    func updateViewLabels(currentWeather: CurrentWeather) -> Void {    
        
        temperatureLabel.text = "\(currentWeather.temperatureCelcius)"
        iconView.image = currentWeather.icon!
        currentTimeLabel.text = "\(currentWeather.currentTime)"
        humidityLabel.text = "\(currentWeather.humidityRatio)%"
        precipitationLabel.text = "\(currentWeather.precipProbabilityRatio)%"
        summaryLabel.text = "\(currentWeather.summary)"
        if currentWeather.locationName != nil {
            locationLabel.text = "\(currentWeather.locationName)"
        }
        
        stopRefreshButton()
        
    }
    
    /*
    Update labels on the view with current weather
    */
    func backtoDefault() -> Void {
        
        temperatureLabel.text = "0"
        iconView.image = UIImage(named: "default.png")
        currentTimeLabel.text = ""
        humidityLabel.text = "-"
        precipitationLabel.text = "-"
        summaryLabel.text = ""
        locationLabel.text = ""
        
        stopRefreshButton()
        
    }
    
    func showGeolocationError() -> Void {
        let networkIssueController = UIAlertController(title: "Location Error", message: "Unable to find your location.", preferredStyle: .Alert)
        
        let okButton = UIAlertAction(title: "OK", style: .Default, handler: nil)
        networkIssueController.addAction(okButton)
        
        self.presentViewController(networkIssueController, animated: true, completion: nil)
        
        self.locationManager.stopUpdatingLocation()
        
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

