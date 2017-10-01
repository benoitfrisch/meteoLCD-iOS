//
//  CurrentWeatherClass.swift
//  meteoLCD
//
//  Created by Benoît Frisch on 01/10/2017.
//  Copyright © 2017 Benoît Frisch. All rights reserved.
//

import UIKit

class CurrentWeatherClass {
    var temperature : String?
    var pression : String?
    var icon : String?
    var backgroundColor : UIColor?
    var timestamp : String?
    
    init(temperature : String, pression : String, icon: String, timestamp: String) {
        self.temperature = temperature
        self.pression = pression
        self.icon = icon
        self.timestamp = timestamp
        
        if (self.icon == "sun") {
            backgroundColor = UIColor(red:0.89, green:0.67, blue:0.20, alpha:1.0)
        } else if (self.icon == "clouds") {
             backgroundColor = UIColor(red:0.27, green:0.33, blue:0.38, alpha:1.0)
        } else if (self.icon == "rain") {
            backgroundColor = UIColor(red:0.44, green:0.45, blue:0.44, alpha:1.0)
        } else if (self.icon == "moon") {
            backgroundColor = UIColor(red:0.15, green:0.16, blue:0.16, alpha:1.0)
        } else if (self.icon == "partly_cloudy_day") {
            backgroundColor = UIColor(red:0.51, green:0.65, blue:0.73, alpha:1.0)
        }
    }
}
