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

import SwiftyJSON
import Alamofire
import EFInternetIndicator
import Firebase

class GraphsTableViewController: UITableViewController, InternetStatusIndicable {
    private var weather: JSON! = nil
    private var url: String = "http://www.lcd.lu/meteo/graph_json.php"
    private let FILE_NAME = "graphs.json"
    private var downloader : DownloadHelper! = nil
    var internetConnectionIndicator: InternetViewIndicator?
    var refresher : UIRefreshControl!
    
    override func viewDidLoad() {
        self.startMonitoringInternet()
        self.navigationItem.title = "Graphs (7 days)"
        self.parseCurrent()
        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
            AnalyticsParameterItemID: "GraphOverview" as NSObject,
            AnalyticsParameterItemName: "GraphOverview" as NSObject,
            AnalyticsParameterContentType: "graph" as NSObject
            ])
        self.tableView.rowHeight = 60.0
        refresher = UIRefreshControl()
        tableView.addSubview(refresher)
        refresher.addTarget(self, action: #selector(pullRefresh), for: .valueChanged)
        self.tableView.reloadData()
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.async(execute: { () -> Void in
            self.parseCurrent()
            self.tableView.reloadData()
        })
    }
    
    @IBAction func refresh(_ sender: Any) {
        self.parseCurrent()
    }
    
    @objc func pullRefresh() {
        DispatchQueue.main.async(execute: { () -> Void in
            self.parseCurrent()
            self.refresher.endRefreshing()
        })
    }
    
    func parseCurrent() {
        self.downloader = DownloadHelper(url: self.url, file: self.FILE_NAME)
        self.downloader.download()
        self.weather = self.downloader.parse()
        
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weather.arrayValue.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "WeatherDetailTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? WeatherDetailTableViewCell else {
            fatalError("The dequeued cell is not an instance of WeatherDetail.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let item = weather[indexPath.row]
        
        cell.descriptionLabel.text = item["label"].stringValue
        
        return cell
    }

    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "graph") {
            let graphVc = segue.destination as! GraphDetailViewController
            graphVc.label = weather[(tableView.indexPathForSelectedRow?.row)!]["label"].stringValue
            graphVc.id = weather[(tableView.indexPathForSelectedRow?.row)!]["id"].stringValue
        }
    }
    
}
