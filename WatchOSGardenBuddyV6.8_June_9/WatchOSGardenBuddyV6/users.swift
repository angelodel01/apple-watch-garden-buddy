//
//  users.swift
//  WatchOSGardenBuddyV6
//
//  Created by Angelo De Laurentis on 5/13/20.
//  Copyright © 2020 Angelo De Laurentis. All rights reserved.
//

import Foundation
import AWSDynamoDB


class users: AWSDynamoDBObjectModel, AWSDynamoDBModeling {
    
    @objc var _uid: String?
    @objc var _auth: String?
    @objc var _controllers: [Any] = []
    @objc var _email: String?
    @objc var _fullname: String?
    @objc var _lat: NSInteger = 0
    @objc var _lon: NSInteger = 0
    @objc var _zones: [[String : Any]] = []
    
    class func dynamoDBTableName() -> String {
        return "users"
    }

    class func hashKeyAttribute() -> String {
        return "_uid"
    }
    
    override class func jsonKeyPathsByPropertyKey() -> [AnyHashable: Any] {
        return [
            "_uid" : "uid",
            "_auth" : "auth",
            "_controllers" : "controllers",
            "_email" : "email",
            "_fullname": "fullname",
            "_lat" : "lat",
            "_lon" : "lon",
            "_zones" : "zones"
        ]
    }
    
}

class userData : Encodable {
    var zones : [Zone]?
    static var user : userData?
    
    
    init(){
        print("userData object initialized")
        self.zones = []
    }
    
    func encodeInJSON() -> String{
        var json = ""
        do{
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(userData.user!)
            json = String(data: jsonData, encoding: String.Encoding.utf8)!
        } catch {
            print("not Json encodable")
        }
        return json
    }
    
    func processResp(resp: [[String: Any]]){
        self.zones = []
        for in_zone in resp {
            var cov_val = false
            var en_val = false
            if Int(truncating: in_zone["enable"] as! NSNumber) == 1{
                en_val = true
            }
            if Int(truncating: in_zone["covered"] as! NSNumber) == 1{
                cov_val = true
            }
            
            let zone = Zone(
                covered: cov_val,
                enable: en_val,
                img_url: in_zone["img_url"] as! String,
                name: in_zone["name"] as! String,
                num: Int(truncating: in_zone["num"] as! NSNumber),
                shadow: (in_zone["shadow"] != nil),
                slope: Int(truncating: in_zone["slope"] as! NSNumber),
                sprinkler_type: Int(truncating: in_zone["sprinkler_type"] as! NSNumber)
            )
            self.zones?.append(zone)
        }
        print("response processed, master user zones \(String(describing: self.zones?[0].sprinkler_type))")
    }
    
    func processWatchResp(resp: [String: Any]){
        self.zones = []
        let input1 = resp["Message"] as? String
        var json: [String: [[String: Any]]]? = nil
        if let data = input1!.data(using: .utf8) {
            do {
                try json = (JSONSerialization.jsonObject(with: data, options: []) as? [String: [[String: Any]]])!
            } catch {
                print(error.localizedDescription)
            }
        }
        print("json from watch \(String(describing: json))")
        for in_zone in (json!["zones"])! {
            print("parsing zone data in_zone[enable]: \(in_zone["enable"]!), name: \(in_zone["name"]!)")
            var cov_val = false, en_val = false;
            
            if Int(truncating: in_zone["covered"] as! NSNumber) == 1{
                cov_val = true
            }
            if Int(truncating: in_zone["enable"] as! NSNumber) == 1{
                en_val = true
            }
            
            let zone = Zone(
                covered: cov_val,
                enable: en_val,
                img_url: in_zone["img_url"] as! String,
                name: in_zone["name"] as! String,
                num: Int(truncating: in_zone["num"] as! NSNumber),
                shadow: (in_zone["shadow"] != nil),
                slope: Int(truncating: in_zone["slope"] as! NSNumber),
                sprinkler_type: Int(truncating: in_zone["sprinkler_type"] as! NSNumber)
            )
            self.zones?.append(zone)
        }
    }
    
    

}

class Zone : Encodable{
    var covered : Bool?
    var enable : Bool?
    var img_url : String?
    var name : String?
    var num : Int?
    var shadow : Bool?
    var slope : Int?
    var sprinkler_type : Int?
    
    init(
        covered : Bool,
        enable : Bool,
        img_url : String,
        name : String,
        num : Int, //NSNumber,
        shadow : Bool,
        slope : Int, //NSNumber,
        sprinkler_type : Int//NSNumber
    ){
        self.covered = covered
        self.enable = enable
        self.img_url = img_url
        self.name = name
        self.num = num
        self.shadow = shadow
        self.slope = slope
        self.sprinkler_type = sprinkler_type
    }
//
//    required init(from decoder:Decoder) throws {
//
//    }
}


////
////  users.swift
////  WatchOSGardenBuddyV6
////
////  Created by Angelo De Laurentis on 5/13/20.
////  Copyright © 2020 Angelo De Laurentis. All rights reserved.
////
//
//import Foundation
//import AWSDynamoDB
//
//
//class users: AWSDynamoDBObjectModel, AWSDynamoDBModeling {
//
//    @objc var _uid: String?
//    @objc var _auth: String?
//    @objc var _controllers: [Any] = []
//    @objc var _email: String?
//    @objc var _fullname: String?
//    @objc var _lat: NSInteger = 0
//    @objc var _lon: NSInteger = 0
//    @objc var _zones: [[String : Any]] = []
//
//    class func dynamoDBTableName() -> String {
//        return "users"
//    }
//
//    class func hashKeyAttribute() -> String {
//        return "_uid"
//    }
//
//    override class func jsonKeyPathsByPropertyKey() -> [AnyHashable: Any] {
//        return [
//            "_uid" : "uid",
//            "_auth" : "auth",
//            "_controllers" : "controllers",
//            "_email" : "email",
//            "_fullname": "fullname",
//            "_lat" : "lat",
//            "_lon" : "lon",
//            "_zones" : "zones"
//        ]
//    }
//
//}
//
//class userData : Encodable {
//    var zones : [Zone]?
//    static var user : userData?
//
//
//    init(){
//        print("userData object initialized")
//        self.zones = []
//    }
//
//    func encodeInJSON() -> String{
//        var json = ""
//        do{
//            let jsonEncoder = JSONEncoder()
//            let jsonData = try jsonEncoder.encode(userData.user!)
//            json = String(data: jsonData, encoding: String.Encoding.utf8)!
//        } catch {
//            print("not Json encodable")
//        }
//        return json
//    }
//
//    func processResp(resp: [[String: Any]]){
//        self.zones = []
//        for in_zone in resp {
//            let zone = Zone(
//                covered: (in_zone["covered"] != nil),
//                enable: (in_zone["enable"] != nil),
//                img_url: in_zone["img_url"] as! String,
//                name: in_zone["name"] as! String,
//                num: Int(truncating: in_zone["num"] as! NSNumber),
//                shadow: (in_zone["shadow"] != nil),
//                slope: Int(truncating: in_zone["slope"] as! NSNumber),
//                sprinkler_type: Int(truncating: in_zone["sprinkler_type"] as! NSNumber)
//            )
//            self.zones?.append(zone)
//        }
//        print("response processed, master user zones \(String(describing: self.zones?[0].sprinkler_type))")
//    }
//
//}
//
//class Zone : Encodable{
//    var covered : Bool?
//    var enable : Bool?
//    var img_url : String?
//    var name : String?
//    var num : Int?
//    var shadow : Bool?
//    var slope : Int?
//    var sprinkler_type : Int?
//
//    init(
//        covered : Bool,
//        enable : Bool,
//        img_url : String,
//        name : String,
//        num : Int, //NSNumber,
//        shadow : Bool,
//        slope : Int, //NSNumber,
//        sprinkler_type : Int//NSNumber
//    ){
//        self.covered = covered
//        self.enable = enable
//        self.img_url = img_url
//        self.name = name
//        self.num = num
//        self.shadow = shadow
//        self.slope = slope
//        self.sprinkler_type = sprinkler_type
//    }
////
////    required init(froam decoder:Decoder) throws {
////
////    }
//}
