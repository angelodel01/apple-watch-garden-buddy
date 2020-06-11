//
//  WatchController.swift
//  WatchOSGardenBuddyV6
//
//  Created by Angelo De Laurentis on 5/24/20.
//  Copyright © 2020 Angelo De Laurentis. All rights reserved.
//

import Foundation
import UIKit
import WatchConnectivity

class WatchController: UIViewController, WCSessionDelegate {
    
    @IBOutlet var ZoneTable: UITableView!
    
    var ZoneTableData:[String] = []//= ["row1", "row2", "row3"]
    var ZoneBools:[Bool] = []//= [true, false, true]
    override func viewDidLoad() {
        super.viewDidLoad()
        if (WCSession.isSupported()) {
            let session = WCSession.default
            session.delegate = self
            session.activate()
            print("watch session activated")
        }
        populateTables()
        ZoneTable.delegate = self
        ZoneTable.dataSource = self
    }
    
    @IBAction func sendDataButtonTap(_ sender: Any) {
        print("sendDataButtonTap hit")
        sendWatchMessage()
    }
    
    //WatchOS Connection STUFF
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
    
    func showAlertMessage(message:String, viewController: UIViewController) {
        DispatchQueue.main.async {
            let alertMessage = UIAlertController(title: "", message: message, preferredStyle: .alert)

            let cancelAction = UIAlertAction(title: "Ok", style: .cancel)

            alertMessage.addAction(cancelAction)

            viewController.present(alertMessage, animated: true, completion: nil)
        }
    }
    
    func reloadTableData() {
        DispatchQueue.main.async {
            self.populateTables()
            self.ZoneTable.reloadData()
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("Gotten watch message: \(message)")
        showAlertMessage(message: "New Data From Watch!", viewController: self)
        userData.user!.processWatchResp(resp: message)
//        print("LOGGING USER DATA IN OBJECT: \( userData.user?.zones?[0].name!): \(userData.user?.zones?[0].enable!)")
        reloadTableData()
    }

    func sessionDidBecomeInactive(_ session: WCSession) {
    }

    func sessionDidDeactivate(_ session: WCSession) {
    }
    
    func sendWatchMessage() {
        if (WCSession.default.isReachable) {
            print("sending watch message")
            let message = ["Message": userData.user!.encodeInJSON()]
            WCSession.default.sendMessage(message, replyHandler: nil)
        }
    }
    
    //End of WatchOS connection
    
}

extension WatchController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped me!")
    }
    
}

extension WatchController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ZoneTableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ZoneCell", for: indexPath)
        cell.textLabel?.text = ZoneTableData[indexPath.row]
        let switchView = UISwitch(frame: .zero)
        switchView.setOn(ZoneBools[indexPath.row] , animated: true)
        switchView.tag = indexPath.row
        switchView.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
        cell.accessoryView = switchView
        return cell
    }
    
    @objc func switchChanged(_ sender: UISwitch){
        print("Tabel row switch changed \(sender.tag)")
        userData.user?.zones![sender.tag].enable = sender.isOn
        print("changing \(String(describing: userData.user?.zones![sender.tag].name))")
    }
    
    func populateTables(){
        ZoneTableData = []
        ZoneBools = []
        for zone in userData.user!.zones!{
            ZoneTableData.append(zone.name!)
            ZoneBools.append(zone.enable!)
        }
    }
}


////
////  WatchController.swift
////  WatchOSGardenBuddyV6
////
////  Created by Angelo De Laurentis on 5/24/20.
////  Copyright © 2020 Angelo De Laurentis. All rights reserved.
////
//
//import Foundation
//import UIKit
//import WatchConnectivity
//
//class WatchController: UIViewController, WCSessionDelegate {
//
//    @IBOutlet var ZoneTable: UITableView!
//
//    var ZoneTableData:[String] = []//= ["row1", "row2", "row3"]
//    var ZoneBools:[Bool] = []//= [true, false, true]
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        if (WCSession.isSupported()) {
//            let session = WCSession.default
//            session.delegate = self
//            session.activate()
//            print("watch session activated")
//        }
//        populateTables()
//        ZoneTable.delegate = self
//        ZoneTable.dataSource = self
//    }
//
//    @IBAction func sendDataButtonTap(_ sender: Any) {
//        print("sendDataButtonTap hit")
//        sendWatchMessage()
//    }
//
//    //WatchOS Connection STUFF
//    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
//    }
//
//    func showAlertMessage(message:String, viewController: UIViewController) {
//        DispatchQueue.main.async {
//            let alertMessage = UIAlertController(title: "", message: message, preferredStyle: .alert)
//
//            let cancelAction = UIAlertAction(title: "Ok", style: .cancel)
//
//            alertMessage.addAction(cancelAction)
//
//            viewController.present(alertMessage, animated: true, completion: nil)
//        }
//    }
//
//    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
//        print("Gotten watch message: \(message)")
//        showAlertMessage(message: "New Data From Watch!", viewController: self)
//        let resp = message["Message"] as! [String : Any]
//        userData.user!.processResp(resp: resp["zones"] as! [[String : Any]])
//        ZoneTable.reloadData()
//    }
//
//    func sessionDidBecomeInactive(_ session: WCSession) {
//    }
//
//    func sessionDidDeactivate(_ session: WCSession) {
//    }
//
//    func sendWatchMessage() {
//        if (WCSession.default.isReachable) {
//            print("sending watch message")
//            let message = ["Message": userData.user!.encodeInJSON()]
//            WCSession.default.sendMessage(message, replyHandler: nil)
//        }
//    }
//
//    //End of WatchOS connection
//
//}
//
//extension WatchController: UITableViewDelegate{
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("You tapped me!")
//    }
//
//}
//
//extension WatchController: UITableViewDataSource{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return ZoneTableData.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ZoneCell", for: indexPath)
//        cell.textLabel?.text = ZoneTableData[indexPath.row]
//        let switchView = UISwitch(frame: .zero)
//        switchView.setOn(ZoneBools[indexPath.row] , animated: true)
//        switchView.tag = indexPath.row
//        switchView.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
////        cell.textLabel!.text = "Hello World"
//        cell.accessoryView = switchView
//        return cell
//    }
//
//    @objc func switchChanged(_ sender: UISwitch){
//        print("Tabel row switch changed \(sender.tag)")
//        userData.user?.zones![sender.tag].enable = sender.isOn
//        print("changing \(String(describing: userData.user?.zones![sender.tag].name))")
//    }
//
//    func populateTables(){
//        for zone in userData.user!.zones!{
//            ZoneTableData.append(zone.name!)
//            ZoneBools.append(zone.enable!)
//        }
//    }
//}
