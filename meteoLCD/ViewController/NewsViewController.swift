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

class NewsViewController: UIViewController, InternetStatusIndicable {
    @IBOutlet var webView: UIWebView!
    var internetConnectionIndicator: InternetViewIndicator?
    
    override func viewDidLoad() {
        self.startMonitoringInternet()
        self.navigationItem.title = "News"
        webView.loadRequest(NSURLRequest(url: NSURL(string: "https://lcd.fresh.lu/getnews.php")! as URL) as URLRequest)
        
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}