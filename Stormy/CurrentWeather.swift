//
//  CurrentWeather.swift
//  Stormy
//
//  Created by Morgan Clayton on 2015-02-04.
//  Copyright (c) 2015 Foxted. All rights reserved.
//

import Foundation
import UIKit

struct CurrentWeather {
    
    var currentTime: String {
        var date = NSDate()
        var outputFormat = NSDateFormatter()
        outputFormat.locale = NSLocale(localeIdentifier:"en_US")
        outputFormat.dateFormat = "HH:mm:ss"
        return outputFormat.stringFromDate(date)
    }
    var temperature: Int
    var temperatureCelcius: Int {
        return Int(Double(temperature - 32) / 1.8)
    }
    var humidity: Double
    var humidityRatio: Int {
        return Int(humidity * 100)
    }
    var precipProbability: Double
    var precipProbabilityRatio: Int {
        return Int(precipProbability * 100)
    }
    var summary: String
    var icon: UIImage?
    var locationName: String!
    
    init(currentLocation: String?, weatherDictionary: NSDictionary) {
        let currentWeather = weatherDictionary["currently"] as NSDictionary

        temperature = currentWeather["temperature"] as Int
        humidity = currentWeather["humidity"] as Double
        precipProbability = currentWeather["precipProbability"] as Double
        summary = currentWeather["summary"] as String
        
        let iconString = currentWeather["icon"] as String
        icon = weatherIconFromString(iconString)
        
        if currentLocation != nil {
            locationName = currentLocation
        }
    }
    
    func dateStringFromUnixTime(unixTime: Int) -> String {
        let timeInSeconds = NSTimeInterval(unixTime)
        let weatherDate = NSDate(timeIntervalSince1970: timeInSeconds)
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = .ShortStyle
        dateFormatter.timeZone = NSTimeZone(name: "America/Vancouver")
        
        return dateFormatter.stringFromDate(weatherDate)
    }
    
    func weatherIconFromString(stringIcon: String) -> UIImage {
        
        var imageName: String
        
        switch stringIcon {
        case "clear-day":
            imageName = "clear-day"
        case "clear-night":
            imageName = "clear-night"
        case "rain":
            imageName = "rain"
        case "snow":
            imageName = "snow"
        case "sleet":
            imageName = "sleet"
        case "wind":
            imageName = "wind"
        case "fog":
            imageName = "fog"
        case "cloudy":
            imageName = "cloudy"
        case "partly-cloudy-day":
            imageName = "partly-cloudy"
        case "partly-cloudy-night":
            imageName = "cloudy-night"
        default:
            imageName = "default"
        }
        
        return UIImage(named: imageName)!
        
        
    }
    
}