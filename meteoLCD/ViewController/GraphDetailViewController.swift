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
import Alamofire
import Charts
import PKHUD
import EFInternetIndicator
import SwiftyJSON
import Firebase

class GraphDetailViewController: UIViewController, InternetStatusIndicable {
    private var graph: JSON! = nil
    private var url: String = "http://www.lcd.lu/meteo/graph_json.php?id="
    public var id: String! = nil
    public var label: String! = nil
    public var unit: String! = nil
    private var downloader : DownloadHelper! = nil
    var internetConnectionIndicator: InternetViewIndicator?
    @IBOutlet var graphView: LineChartView!
    
    override func viewDidLoad() {
        self.startMonitoringInternet()
        self.navigationItem.title = label
        self.navigationItem.title = label
        
        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
            AnalyticsParameterItemID: "GraphDetail_\(self.id!)" as NSObject,
            AnalyticsParameterItemName: "GraphDetail_\(self.id!)" as NSObject,
            AnalyticsParameterContentType: "graph" as NSObject
            ])
        
        self.updateGraph()
        super.viewDidLoad()
    }
    
    @IBAction func refresh(_ sender: Any) {
         self.updateGraph()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.updateGraph()
    }
    
    func updateGraph() {
        self.graphView.clear()
        var dataPoints = [ChartDataEntry]()
        var dateEntry = [String]()
        
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        
        Alamofire.request(self.url + self.id).responseJSON { response in
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                //print("Data: \(utf8Text)") // original server data as UTF8 string
                if let dataFromString = utf8Text.data(using: .utf8, allowLossyConversion: false) {
                    do {
                        self.graph = try JSON(data: dataFromString)
                    } catch { }
                        DispatchQueue.main.async(execute: { () -> Void in
                            PKHUD.sharedHUD.hide(afterDelay: 1.0) { success in
                                if (self.graph["history"].arrayValue.count > 0) {
                                    let history = self.graph["history"].arrayValue
                                    
                                    for i in 0...history.count-2 {
                                        let value = ChartDataEntry(x: Double(i), y: Double(history[i]["value"].doubleValue))
                                        let date = history[i]["date"].stringValue
                                        self.unit = history[i]["unit"].stringValue
                                        dataPoints.append(value)
                                        dateEntry.append(date)
                                    }
                                    
                                    let gradientColors = [UIColor(red:0.51, green:0.65, blue:0.73, alpha:1.0).cgColor, UIColor.clear.cgColor] as CFArray
                                    let colorLocations:[CGFloat] = [1.0, 0.0]
                                    let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations)
                                    
                                    
                                    let historyLine = LineChartDataSet(values: dataPoints, label: self.label)
                                    historyLine.fill = Fill.fillWithLinearGradient(gradient!, angle: 90.0)
                                    historyLine.drawFilledEnabled = true
                                    historyLine.drawCirclesEnabled = false
                                    historyLine.highlightColor = UIColor.orange
                                    historyLine.colors = [UIColor(red:0.51, green:0.65, blue:0.73, alpha:1.0)]
                                    
                                    let data = LineChartData()
                                    data.addDataSet(historyLine)
                                    
                                    let valueFormat = ValueFormatter(unit: self.unit)
                                    self.graphView.data = data
                                    self.graphView.chartDescription?.text = ""
                                    self.graphView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dateEntry)
                                    self.graphView.leftAxis.valueFormatter = valueFormat
                                    self.graphView.rightAxis.enabled = false
                                    self.graphView.xAxis.labelRotationAngle = CGFloat(270.0)
                                    self.graphView.xAxis.labelPosition = XAxis.LabelPosition.bottom;
                                    self.graphView.legend.enabled = false
                                    self.graphView.highlightPerTapEnabled = false
                                    self.graphView.highlightPerDragEnabled = false
                                    self.graphView.reloadInputViews()
                                }
                            }
                        })
                    }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
