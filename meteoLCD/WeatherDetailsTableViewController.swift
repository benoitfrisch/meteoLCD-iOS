//
//  WeatherDetailsTableViewController.swift
//  meteoLCD
//
//  Created by Benoît Frisch on 01/10/2017.
//  Copyright © 2017 Benoît Frisch. All rights reserved.
//

import UIKit

class WeatherDetailsTableViewController: UITableViewController {

    override func viewDidLoad() {
        self.parseCurrent()
        self.navigationItem.title = "Weather Details"
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 10
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "WeatherDetailTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? WeatherDetailTableViewCell else {
            fatalError("The dequeued cell is not an instance of WeatherDetail.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        //let subject = exams[self.section]["subjects"][indexPath.row]
        
        cell.descriptionLabel.text = "Temp"
        cell.valueLabel.text = "11"
        
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
