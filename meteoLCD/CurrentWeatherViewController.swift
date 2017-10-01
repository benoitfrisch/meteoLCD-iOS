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
        self.parseCurrent()
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.parseCurrent()
        
    }
    
    @IBAction func refresh(_ sender: Any) {
        self.parseCurrent()
        
    }
    
    func downloadCurrent() {
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent("current.json")
            
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        Alamofire.download(url, to: destination).response { response in
            self.loadCurrent()
        }
    }
    
    func loadCurrent() {
        let file = "current.json"
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let path = dir.appendingPathComponent(file)
            do {
                let weatherString = try String(contentsOf: path, encoding: String.Encoding.utf8)
                if let dataFromString = weatherString.data(using: .utf8, allowLossyConversion: false) {
                    self.weather = JSON(data: dataFromString)
                    self.currentWeather = CurrentWeatherClass(temperature: self.weather["temperature"].stringValue, pression: self.weather["pression"].stringValue, icon: self.weather["icon"].stringValue, timestamp: self.weather["lastupdate"].stringValue)
                    self.displayCurrentWeather()
                }
            } catch {
            }
        }
    }
    
    func parseCurrent() {
        self.downloadCurrent()
        self.loadCurrent()
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
