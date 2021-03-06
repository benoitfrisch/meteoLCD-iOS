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
import Firebase
import PKHUD

class WeatherDetailsTableViewController: UITableViewController, InternetStatusIndicable {
    private var weather: JSON! = nil
    private var url: String = "https://www.lcd.lu/meteo/current_json.php"
    private let FILE_NAME = "current.json"
    private var downloader : DownloadHelper! = nil
    private var currentWeather: CurrentWeatherClass!
    var internetConnectionIndicator: InternetViewIndicator?
    var refresher : UIRefreshControl!
    
    override func viewDidLoad() {
        self.startMonitoringInternet()
        self.navigationItem.title = "Weather Details"
        self.parseCurrent()
        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
            AnalyticsParameterItemID: "WeatherDetails" as NSObject,
            AnalyticsParameterItemName: "WeatherDetails" as NSObject,
            AnalyticsParameterContentType: "current-details" as NSObject
            ])
        self.tableView.rowHeight = 60.0
        refresher = UIRefreshControl()
        tableView.addSubview(refresher)
        refresher.addTarget(self, action: #selector(pullRefresh), for: .valueChanged)
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.parseCurrent()
    }
    
    @IBAction func refresh(_ sender: Any) {
        self.parseCurrent()
    }
    
    @objc func pullRefresh() {
        DispatchQueue.main.async {
            self.parseCurrent()
            self.refresher.endRefreshing()
        }
    }
    
    func parseCurrent() {
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        
        Alamofire.request(self.url).responseJSON { response in
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                if let dataFromString = utf8Text.data(using: .utf8, allowLossyConversion: false) {
                    do {
                        try self.weather = JSON(data: dataFromString)
                        DispatchQueue.main.async(execute: { () -> Void in
                            PKHUD.sharedHUD.hide(afterDelay: 1.0) { success in
                                self.tableView.reloadData()
                            }
                        })
                    } catch {
                    }
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.weather != nil ? self.weather["weather"].arrayValue.count : 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weather["weather"][section].arrayValue.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "WeatherDetailTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? WeatherDetailTableViewCell else {
            fatalError("The dequeued cell is not an instance of WeatherDetail.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let item = weather["weather"][indexPath.section][indexPath.row]
        
        cell.descriptionLabel.text = item["label"].stringValue
        cell.valueLabel.text = item["value"].stringValue
        
        return cell
    }
}
