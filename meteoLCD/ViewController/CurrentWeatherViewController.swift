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
import EFInternetIndicator

class CurrentWeatherViewController: UIViewController, InternetStatusIndicable {
    private var weather: JSON! = nil
    private var url: String = "http://www.lcd.lu/meteo/current_json.php"
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
        self.parseCurrent()
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.parseCurrent()
        
    }
    
    @IBAction func refresh(_ sender: Any) {
        self.parseCurrent()
        
    }
    
    func parseCurrent() {
        DispatchQueue.global(qos: .background).async {
            self.downloader = DownloadHelper(url: self.url, file: self.FILE_NAME)
            DispatchQueue.main.async(flags: .barrier) {
                self.weather = self.downloader.download()
            }
            DispatchQueue.main.async(flags: .barrier) {
                self.currentWeather = CurrentWeatherClass(temperature: self.weather["temperature"].stringValue, pression: self.weather["pression"].stringValue, icon: self.weather["icon"].stringValue, timestamp: self.weather["lastupdate"].stringValue)
                self.displayCurrentWeather()
            }
        }
    }
    
    func displayCurrentWeather() {
        backgroundImage.image = UIImage(named: currentWeather.icon!+"_back")
        currentWeatherImage.image = UIImage(named: currentWeather.icon!)
        currentTemperatureLabel.text = currentWeather.temperature
        currentPressionLabel.text = currentWeather.pression
        currentWeatherBoxLabel.backgroundColor = currentWeather.backgroundColor
        lastUpdatedLabel.text = "Dernière mise à jour:\n"+currentWeather.timestamp!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
