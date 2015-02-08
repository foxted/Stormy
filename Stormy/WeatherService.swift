//
//  WeatherService.swift
//  Stormy
//
//  Created by Morgan Clayton on 2015-02-05.
//  Copyright (c) 2015 Foxted. All rights reserved.
//

import Foundation
import UIKit

struct WeatherService {
    
    static let apiKey = "4f9288af14b2c172d497f4538a8dfc80"
    var coordinates: String = ""
    
    static func getCurrentWeatherData(
        #currentView: WeatherController,
        completionHandler: (CurrentWeather) -> Void,
        errorHandler: () -> Void
    ) -> Void {
        
        let baseURL = NSURL(string: "https://api.forecast.io/forecast/\(apiKey)/")
        if currentView.location != nil {
            let coordinates = "\(currentView.location.latitude),\(currentView.location.longitude)"
            let forecastURL = NSURL(string: coordinates, relativeToURL: baseURL)
            
            let sharedSession = NSURLSession.sharedSession()
            let downloadTask: NSURLSessionDownloadTask = sharedSession.downloadTaskWithURL(forecastURL!, completionHandler:{( location: NSURL!, response:NSURLResponse!, error: NSError!) -> Void in
                
                if(error == nil) {
                    let dataObject = NSData(contentsOfURL: location)
                    
                    var weatherDictionary: NSDictionary = NSJSONSerialization.JSONObjectWithData(dataObject!, options: nil, error: nil) as NSDictionary
                    
                    let currentWeather = CurrentWeather(currentLocation: currentView.locationName, weatherDictionary: weatherDictionary)
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        completionHandler(currentWeather)
                    })
                    
                } else {
                    let networkIssueController = UIAlertController(title: "Network Error", message: "Unable to connect to the Internet", preferredStyle: .Alert)
                    
                    let okButton = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    networkIssueController.addAction(okButton)
                    
                    let settingsButton = UIAlertAction(title: "Settings", style: .Default) { (_) -> Void in
                        let settingsUrl = NSURL(string: UIApplicationOpenSettingsURLString)
                        if let url = settingsUrl {
                            UIApplication.sharedApplication().openURL(url)
                        }
                    }
                    networkIssueController.addAction(settingsButton)
                    
                    currentView.presentViewController(networkIssueController, animated: true, completion: nil)
                    
                    dispatch_async(dispatch_get_main_queue(), errorHandler)
                }
                
            })
            downloadTask.resume()
        }
    }
}