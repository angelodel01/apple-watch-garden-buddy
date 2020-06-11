//
//  ZoneData.swift
//  WatchOSGardenBuddyV6 WatchKit Extension
//
//  Created by Angelo De Laurentis on 5/20/20.
//  Copyright © 2020 Angelo De Laurentis. All rights reserved.
//

import Foundation

class ZoneData: Encodable{
    var zones: [Zone]
    public static var MasterZoneTable: ZoneData?
    
    init(){
        self.zones = []
    }
    
    func encodeInJSON() -> String{
        var json = ""
        do{
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(ZoneData.MasterZoneTable!)
            json = String(data: jsonData, encoding: String.Encoding.utf8)!
        } catch {
            print("not Json encodable")
        }
        return json
    }
        
    
    func processPhoneMessage(resp: [String:Any]){
        print("                 in processPhoneMessage: \(resp) ")
        let input1 = resp["Message"] as? String
        var json: [String: [[String: Any]]]? = nil
        if let data = input1!.data(using: .utf8) {
            do {
                try json = (JSONSerialization.jsonObject(with: data, options: []) as? [String: [[String: Any]]])!
            } catch {
                print(error.localizedDescription)
            }
        }
        print("json \(String(describing: json))")
        for z in (json!["zones"])!{
            let temp = Zone(
                covered : z["covered"] as! Bool ,
                enable : z["enable"] as! Bool,
                img_url : z["img_url"] as! String,
                name : z["name"] as! String,
                num : z["num"] as! Int,
                shadow : (z["shadow"] != nil),
                slope : z["slope"] as! Int,
                sprinkler_type : z["sprinkler_type"] as! Int
            )
            self.zones.append(temp)
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
}
