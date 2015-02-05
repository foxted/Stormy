//
//  ViewController.swift
//  Stormy
//
//  Created by Morgan Clayton on 2015-02-04.
//  Copyright (c) 2015 Foxted. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private let apiKey = "4f9288af14b2c172d497f4538a8dfc80"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let baseURL = NSURL(string: "https://api.forecast.io/forecast/\(apiKey)/")
        let forecastURL = NSURL(string: "49.275568,-123.127829", relativeToURL: baseURL)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

