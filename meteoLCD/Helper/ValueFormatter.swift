//
//  ValueFormatter.swift
//  meteoLCD
//
//  Created by Benoît Frisch on 03/10/2017.
//  Copyright © 2017 Benoît Frisch. All rights reserved.
//

import UIKit
import Charts

class ValueFormatter: NSObject, IAxisValueFormatter {
    var unit : String!
    
    convenience init(unit: String) {
        self.init()
        self.unit = unit
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return String(value)+" "+unit
    }
}
