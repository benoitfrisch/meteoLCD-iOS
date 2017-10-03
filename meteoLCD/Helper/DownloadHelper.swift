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
import SwiftyJSON

class DownloadHelper: NSObject {
    var url : String!
    var fileName : String!
    
    init(url : String, file : String) {
        self.url = url
        self.fileName = file
    }
    
    public func download() {
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent(self.fileName)
            
            print(fileURL)
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        Alamofire.download(self.url, to: destination).response { response in
        }
    }
    
    func parse() -> JSON {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let path = dir.appendingPathComponent(fileName)
            do {
                let weatherString = try String(contentsOf: path, encoding: String.Encoding.utf8)
                if let dataFromString = weatherString.data(using: .utf8, allowLossyConversion: false) {
                    return JSON(data: dataFromString)
                }
            } catch {
            }
        }
        return JSON("error")
    }
}
