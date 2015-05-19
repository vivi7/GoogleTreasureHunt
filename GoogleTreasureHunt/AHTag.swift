//
//  AHTag.swift
//  TreasureHunt
//
//  Created by Vincenzo Favara on 25/09/14.
//  Copyright (c) 2014 Vincenzo Favara. All rights reserved.
//

import Foundation

class AHTag  : NSObject, NSCoding {
    
    var id:String!
    var clueId:String!
    //var isFound:Bool!
    
    init(idPassed:String, clueIdPassed:String) {
        id = idPassed;
        clueId = clueIdPassed
        //isFound = false
    }
    
    internal required init(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObjectForKey("kid") as! String
        self.clueId = aDecoder.decodeObjectForKey("kclueId") as! String
        //self.isFound = aDecoder.decodeObjectForKey("kisFound") as! Bool
    }
    
    func encodeWithCoder(encoder: NSCoder) {
        encoder.encodeObject(self.id, forKey: "kid")
        encoder.encodeObject(self.clueId, forKey: "kclueId")
        //encoder.encodeObject(self.isFound, forKey: "kisFound")
    }
}