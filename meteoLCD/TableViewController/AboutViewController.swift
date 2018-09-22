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
import Firebase

class AboutViewController: UITableViewController {
    @IBOutlet var versionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        versionLabel.text = "Version \(Bundle.main.releaseVersionNumber!) (\(Bundle.main.buildVersionNumber!))"
        
        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
            AnalyticsParameterItemID: "About" as NSObject,
            AnalyticsParameterItemName: "About" as NSObject,
            AnalyticsParameterContentType: "about" as NSObject
            ])
        // Do any additional setup after loading the view.
    }
    
    @IBAction func openGithub(_ sender: Any) {
        // Create the alert controller
        let alertController = UIAlertController(title: "GitHub", message: "", preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "Open", style: UIAlertAction.Style.default) {
            UIAlertAction in
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL(string:"https://github.com/benoitfrisch/meteoLCD-iOS")!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
            } else {
                UIApplication.shared.openURL(URL(string:
                    "https://github.com/benoitfrisch/meteoLCD-iOS")!)
            }
        }
        let cancelAction = UIAlertAction(title: "Annuler", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        
        
        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
