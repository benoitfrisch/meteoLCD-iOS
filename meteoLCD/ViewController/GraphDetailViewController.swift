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
import Charts

class GraphDetailViewController: UIViewController, InternetStatusIndicable {
    private var graph: JSON! = nil
    private var url: String = "http://www.lcd.lu/meteo/graph_json.php?id="
    public var id: String! = nil
    public var label: String! = nil
    private var downloader : DownloadHelper! = nil
    var internetConnectionIndicator: InternetViewIndicator?
    
    @IBOutlet var graphView: LineChartView!
    
    override func viewDidLoad() {
        self.startMonitoringInternet()
        self.navigationItem.title = label
        
        self.updateGraph()
        
        
        super.viewDidLoad()
    }
    
    func parseCurrent() {
        self.downloader = DownloadHelper(url: self.url+self.id, file: "graph_" + self.id + ".json")
        self.downloader.download()
        self.graph = self.downloader.parse()
    }

    func updateGraph() {
        var dataPoints  = [ChartDataEntry]()
        var dateEntry  = [String]()
        
        while (graph==nil) {
            self.parseCurrent()
            if (graph["history"].arrayValue.count>0) {
                break
            }
        }
        
        while (graph["history"].arrayValue.count==0) {
            self.parseCurrent()
            if (graph["history"].arrayValue.count>0) {
                break
            }
        }
        
        let history = graph["history"].arrayValue

        for i in 0...history.count-2 {
            let value = ChartDataEntry(x: Double(i), y: Double(history[i]["value"].doubleValue))
            let date = history[i]["date"].stringValue
            dataPoints.append(value)
            dateEntry.append(date)
        }
        
        let gradientColors = [UIColor(red:0.51, green:0.65, blue:0.73, alpha:1.0).cgColor, UIColor.clear.cgColor] as CFArray
        let colorLocations:[CGFloat] = [1.0, 0.0]
        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations)
        
        
        let historyLine = LineChartDataSet(values: dataPoints, label: label)
        historyLine.fill = Fill.fillWithLinearGradient(gradient!, angle: 90.0)
        historyLine.drawFilledEnabled = true
        historyLine.drawCirclesEnabled = false
        historyLine.highlightColor = UIColor.orange
        historyLine.colors = [UIColor(red:0.51, green:0.65, blue:0.73, alpha:1.0)]
        
        let data = LineChartData()
        data.addDataSet(historyLine)
        
        graphView.data = data
        graphView.chartDescription?.text = ""
        graphView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dateEntry)
        graphView.xAxis.labelRotationAngle = CGFloat(270.0)
        graphView.xAxis.labelPosition = XAxis.LabelPosition.bottom;
        graphView.legend.enabled = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
