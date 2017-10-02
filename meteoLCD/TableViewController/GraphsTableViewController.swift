//
//  GraphsTableViewController.swift
//  meteoLCD
//
//  Created by Benoît Frisch on 02/10/2017.
//  Copyright © 2017 Benoît Frisch. All rights reserved.
//

import SwiftyJSON
import Alamofire
import EFInternetIndicator

class GraphsTableViewController: UITableViewController, InternetStatusIndicable {
    private var weather: JSON! = nil
    private var url: String = "http://www.lcd.lu/meteo/graph_json.php"
    private let FILE_NAME = "graphs.json"
    private var downloader : DownloadHelper! = nil
    var internetConnectionIndicator: InternetViewIndicator?
    
    override func viewDidLoad() {
        self.startMonitoringInternet()
        self.navigationItem.title = "Graphs"
        self.parseCurrent()
        self.tableView.rowHeight = 60.0
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.parseCurrent()
        
    }
    
    @IBAction func refresh(_ sender: Any) {
        self.parseCurrent()
        
    }
    
    func parseCurrent() {
        self.downloader = DownloadHelper(url: url, file: FILE_NAME)
        self.weather = self.downloader.download()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return weather["weather"].arrayValue.count
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
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
