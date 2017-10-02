//
//  DownloadHelper.swift
//  meteoLCD
//
//  Created by Benoît Frisch on 02/10/2017.
//  Copyright © 2017 Benoît Frisch. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class DownloadHelper: NSObject {
    var url : String!
    var file : String!
    
    init(url : String, file : String) {
        self.url = url
        self.file = file
    }
    
    public func download() -> JSON {
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent(self.file)
            
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        Alamofire.download(self.url, to: destination).response { response in
        }
        return self.parse()
    }
    
    func parse() -> JSON {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let path = dir.appendingPathComponent(file)
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
