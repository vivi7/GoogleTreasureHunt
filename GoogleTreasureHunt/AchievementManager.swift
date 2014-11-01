//
//  AchievementManager.swift
//  TreasureHunt
//
//  Created by Vincenzo Favara on 25/09/14.
//  Copyright (c) 2014 Vincenzo Favara. All rights reserved.
//

import Foundation

class AchievementManager{
    var ID_FIRST_CLUE:String = "";
    var ID_HALFWAY:String = "";
    var ID_SPEEDRUN:String = "";
    var ID_TEACHERS_PET:String = "";
    var ID_5_TRIVIA_CORRECTLY:String = "";
    var ID_DOUBLE_SCAN:String = "";
    var ID_FOUND_ALEX:String = "";
    var ID_LEADERBOARD:String = "";
    
    let FOUND_ACHIEVEMENTS_KEY:String = "FOUND_ACHIEVEMENTS_KEY";
    
    let PAR_QUESTIONS:Int = 3;
    let TOTAL_QUESTIONS:Int = 5;
    
    var tagScannedTimes:Array<Double> = Array<Double>();
    
    
    var points:Int = 0;
    
    init(){
        //TODO: load
    }
    
    
}