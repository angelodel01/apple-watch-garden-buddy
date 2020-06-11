//
//  InterfaceController.swift
//  MasterV1 WatchKit Extension
//
//  Created by Angelo De Laurentis on 3/8/20.
//  Copyright © 2020 Angelo De Laurentis. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController, WCSessionDelegate {

    @IBOutlet weak var ZoneTable: WKInterfaceTable!
    
    var ZoneTableData:[Zone] = []
    

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        print("watch awake")
        loadZoneTableData()
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
    func sendWatchMessage() {
        if (WCSession.default.isReachable) {
            print("sending watch message")
            if (ZoneData.MasterZoneTable != nil){
                let message = ["Message": ZoneData.MasterZoneTable!.encodeInJSON()]
                WCSession.default.sendMessage(message, replyHandler: nil, errorHandler: nil)
            }else{
                let action = WKAlertAction(title: "Issue", style: WKAlertActionStyle.default) {
                    print("Ok")
                }
                presentAlert(withTitle: "Error", message: "No data to send", preferredStyle: WKAlertControllerStyle.alert, actions:[action])
            }
        }else{
            print("PHONE NOT REACHABLE")
        }
    }
    
    @IBAction func sendDataBtn() {
        print("WCSession.default.isReachable: \(WCSession.default.isReachable)")
        sendWatchMessage()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("session activated")
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("Gotten IOS message: \(message)")
        let action = WKAlertAction(title: "Thanks", style: WKAlertActionStyle.default) {
            print("Ok")
        }
        presentAlert(withTitle: "From Phone", message: "New Data in!", preferredStyle: WKAlertControllerStyle.alert, actions:[action])
        ZoneData.MasterZoneTable = ZoneData()
        ZoneData.MasterZoneTable?.processPhoneMessage(resp: message)
        setZoneTable()
    }
    
    func setZoneTable(){
        ZoneTableData = []
        for zone in ZoneData.MasterZoneTable!.zones{
            ZoneTableData.append(zone)
        }
        loadZoneTableData()
    }
    

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    private func loadZoneTableData(){
        print("loading zone table")
        if (ZoneTable != nil){
            ZoneTable.setNumberOfRows(ZoneTableData.count, withRowType: "ZoneRowController")
            for(index, _) in ZoneTableData.enumerated() {
                if let rowController = ZoneTable.rowController(at: index) as? ZoneRowController{
                    let zone = ZoneTableData[index]
                    rowController.ZoneRowNumber.setText(String(describing: zone.num!))
                    rowController.ZoneRowLabel.setText(zone.name)
                    rowController.OperationState.setOn(zone.enable!)
                    rowController.number = index
                }
            }
        }
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        _ = ZoneTableData[rowIndex]
        print("pushing num: \(rowIndex)")
        pushController(withName: "ZoneViewController", context: rowIndex)
    }
    
}
