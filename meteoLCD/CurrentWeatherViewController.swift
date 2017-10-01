//
//  CurrentWeatherViewController.swift
//  meteoLCD
//
//  Created by Benoît Frisch on 01/10/2017.
//  Copyright © 2017 Benoît Frisch. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import EFInternetIndicator

class CurrentWeatherViewController: UIViewController, InternetStatusIndicable {
    private var weather: JSON! = nil
    private var url: String = "http://www.lcd.lu/meteo/current_json.php"
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
        self.loadCurrentWeather()
        
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.loadCurrentWeather()
    }
    
    @IBAction func refresh(_ sender: Any) {
        self.loadCurrentWeather()
    }
    
    func loadCurrentWeather() {
        Alamofire.request(url).responseJSON { response in
            if let json = response.result.value {
                self.weather = JSON(json)
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
        lastUpdatedLabel.text = "Dernière mise à jour:\n"+currentWeather.timestamp!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
