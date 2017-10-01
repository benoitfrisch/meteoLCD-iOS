//
//  CurrentWeatherClass.swift
//  meteoLCD
//
//  Created by Benoît Frisch on 01/10/2017.
//  Copyright © 2017 Benoît Frisch. All rights reserved.
//

class CurrentWeatherClass {
    var temperature : String?
    var pression : String?
    var icon : String?
    var timestamp : String?
    
    init(temperature : String, pression : String, icon: String, timestamp: String) {
        self.temperature = temperature
        self.pression = pression
        self.icon = icon
        self.timestamp = timestamp
    }
}
