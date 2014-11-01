//
//  Clue.swift
//  TreasureHunt
//
//  Created by Vincenzo Favara on 25/09/14.
//  Copyright (c) 2014 Vincenzo Favara. All rights reserved.
//

import Foundation

class Clue {
    
    var type:String!
    var id:String!
    var shufflegroup:Int!
    var displayName:String!
    var displayText:String!
    var displayImage:String!
    var tags:Array<AHTag>!
    var question:TriviaQuestion?
    var number:Int!
    
/*
    init(idPassed:String, displayNamePassed:String, displayTextPassed:String, displayImagePassed:String, shufflegroupPassed:Int, numberPassed:Int) {
        
        id = idPassed
        shufflegroup = shufflegroupPassed
        displayName = displayNamePassed
        displayText = displayTextPassed
        displayImage = displayImagePassed
    
        tags = Array<AHTag>()
        number = numberPassed
    }
*/
    init(){
    
    }
    
    func getCluesFound(hunt:Hunt) -> Int {
        var count:Int = 0;
        for tag:AHTag in tags {
            if (hunt.isTagFound(tag.id)) {
                count++;
            }
        }
        return count;
    }
    
    func getStatus(hunt:Hunt) -> NSString {
        return "/(getCluesFound(hunt)) //(tags.count)";
    }
    
    func addTag(tag:AHTag) {
        tags.append(tag);
    }

}