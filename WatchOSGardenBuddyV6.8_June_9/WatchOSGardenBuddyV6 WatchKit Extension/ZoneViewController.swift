//
//  ZoneViewController.swift
//  MasterV1 WatchKit Extension
//
//  Created by Angelo De Laurentis on 3/8/20.
//  Copyright © 2020 Angelo De Laurentis. All rights reserved.
//

import Foundation
import WatchKit

class ZoneViewController: InterfaceController{

    @IBOutlet weak var ZoneName: WKInterfaceTextField!
    @IBOutlet weak var OperationState: WKInterfaceSwitch!
    @IBOutlet weak var ZoneNum: WKInterfaceTextField!
    weak var zone:Zone?
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        print("context: \(context!)")
        self.zone = ZoneData.MasterZoneTable!.zones[context as! Int]
        OperationState.setOn((self.zone?.enable)!)
        ZoneNum.setText("Zone: \((self.zone!.num)!)")
        ZoneName.setText("\((self.zone!.name)!)")
    }
    
    override func willActivate() {
        super.willActivate()
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
}
