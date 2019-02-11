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
import SwiftyJSON
import Alamofire
import AlamofireImage
import EFInternetIndicator
import Firebase
import PKHUD

class CurrentWeatherViewController: UIViewController, InternetStatusIndicable {
    private var weather: JSON! = nil
    private var url: String = "https://www.lcd.lu/meteo/current_json.php"
    private let FILE_NAME = "current.json"
    private var downloader : DownloadHelper! = nil
    private var currentWeather: CurrentWeatherClass!
    var internetConnectionIndicator: InternetViewIndicator?
    
    @IBOutlet var backgroundImage: UIImageView!
    @IBOutlet var currentWeatherBoxLabel: UILabel!
    @IBOutlet var currentWeatherImage: UIImageView!
    @IBOutlet var currentTemperatureLabel: UILabel!
    @IBOutlet var currentPressionLabel: UILabel!
    @IBOutlet var lastUpdatedLabel: UILabel!
    
    override func viewDidLoad() {
        self.startMonitoringInternet()
        self.navigationItem.title = "Current Weather"
        self.displayCurrentWeather()
        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
            AnalyticsParameterItemID: "CurrentWeatherLoad" as NSObject,
            AnalyticsParameterItemName: "CurrentWeatherLoad" as NSObject,
            AnalyticsParameterContentType: "current" as NSObject
            ])
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.displayCurrentWeather()
        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
            AnalyticsParameterItemID: "CurrentWeatherAppear" as NSObject,
            AnalyticsParameterItemName: "CurrentWeatherAppear" as NSObject,
            AnalyticsParameterContentType: "current" as NSObject
            ])
    }
    
    @IBAction func refresh(_ sender: Any) {
        self.displayCurrentWeather()
    }
    
    func displayCurrentWeather() {
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        
        Alamofire.request(self.url).responseJSON { response in
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                //print("Data: \(utf8Text)") // original server data as UTF8 string
                if let dataFromString = utf8Text.data(using: .utf8, allowLossyConversion: false) {
                    do {
                        self.weather = try JSON(data: dataFromString)
                    } catch{}
                        DispatchQueue.main.async(execute: { () -> Void in
                            PKHUD.sharedHUD.hide(afterDelay: 1.0) { success in
                                self.currentWeather = CurrentWeatherClass(temperature: self.weather["temperature"].stringValue, pression: self.weather["pression"].stringValue, icon: self.weather["icon"].stringValue, timestamp: self.weather["lastupdate"].stringValue)
                                self.loadCurrentImage()
                                self.currentWeatherImage.image = UIImage(named: self.currentWeather.icon!)
                                self.currentTemperatureLabel.text = self.currentWeather.temperature
                                self.currentPressionLabel.text = self.currentWeather.pression
                                self.currentWeatherBoxLabel.backgroundColor = self.currentWeather.backgroundColor
                                self.lastUpdatedLabel.text = "Dernière mise à jour:\n"+self.currentWeather.timestamp!
                            }
                    })
                }
            }
        }
    }
    
    func loadCurrentImage() {
        Alamofire.request("https://meteo.lcd.lu/current.jpg").responseImage { response in
            if let image = response.result.value {
                self.backgroundImage.image = image
            } else {
                self.backgroundImage.image = UIImage(named: self.currentWeather.icon!+"_back")
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
