/**
 * This file is part of meteoLCD.
 *
 * Copyright (c) 2017 Benoît FRISCH
 *
 * meteoLCD is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * meteoLCD is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with meteoLCD If not, see <http://www.gnu.org/licenses/>.
 */

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
