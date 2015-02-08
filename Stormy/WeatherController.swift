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
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var precipitationLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var refreshActivityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        
        super.viewDidLoad()

        localizeDevice()
        
        refreshActivityIndicator.hidden = true
        
        getCurrentWeatherData()
        
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }

    @IBAction func refresh() {
        
        getCurrentWeatherData()
        
        refreshButton.hidden = true
        refreshActivityIndicator.hidden = false
        refreshActivityIndicator.startAnimating()
        
    }
    
    func localizeDevice() -> Void {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    /*
        Get current weather data from service
    */
    func getCurrentWeatherData() -> Void {
        
        // Find the weather at this location
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
    
    func locationManager(manager:CLLocationManager, didUpdateLocations locations:[AnyObject]) {
        println("locations = \(locations)")
        manager.stopUpdatingLocation()
    }

}

