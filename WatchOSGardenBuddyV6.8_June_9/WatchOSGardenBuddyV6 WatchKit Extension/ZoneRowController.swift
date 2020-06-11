//
//  ZoneRowController.swift
//  MasterV1 WatchKit Extension
//
//  Created by Angelo De Laurentis on 3/8/20.
//  Copyright © 2020 Angelo De Laurentis. All rights reserved.
//

import Foundation
import WatchKit
import WatchConnectivity

class ZoneRowController: NSObject{

    @IBOutlet weak var ZoneRowNumber: WKInterfaceLabel!
    @IBOutlet weak var ZoneRowLabel: WKInterfaceLabel!
    @IBOutlet weak var OperationState: WKInterfaceSwitch!
    var number: Int = 0

    
    @IBAction func SwitchChange(_ value: Bool) {
        print("got switch action \(value)")
        ZoneData.MasterZoneTable!.zones[number].enable = value
    }
    
    

    
    //End of WatchOS connection
}
