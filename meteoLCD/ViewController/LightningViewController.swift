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
import EFInternetIndicator
import Firebase

class LightningViewController:  UIViewController, UIWebViewDelegate, InternetStatusIndicable {
    var internetConnectionIndicator: InternetViewIndicator?
    
    @IBOutlet var webView: UIWebView!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        self.startMonitoringInternet()
        self.navigationItem.title = "Lightning Radar"
        webView.loadRequest(NSURLRequest(url: NSURL(string: "http://meteo.lcd.lu/lightning/public_html/lcdflash.jpg")! as URL) as URLRequest)
        spinner.startAnimating()
        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
            AnalyticsParameterItemID: "LightningRadar" as NSObject,
            AnalyticsParameterItemName: "LightningRadar" as NSObject,
            AnalyticsParameterContentType: "lightning" as NSObject
            ])
        super.viewDidLoad()
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        spinner.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        spinner.stopAnimating()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

