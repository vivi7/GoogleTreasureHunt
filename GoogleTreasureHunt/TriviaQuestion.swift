//
//  TriviaQuestion.swift
//  TreasureHunt
//
//  Created by Vincenzo Favara on 25/09/14.
//  Copyright (c) 2014 Vincenzo Favara. All rights reserved.
//

import Foundation

let ANSWARE_UNDONE = -2

class TriviaQuestion : NSObject, NSCoding {
    
    var question: String
    var bitmapID: String?
    var answers: [String] = []
    var correctAnswer: Int!
    var rightMessage: String?
    var wrongMessage: String?
    
    //var doneAnswer: Int!
    
    init(myQuestion: String){
        question = myQuestion
        correctAnswer = -1
        //doneAnswer = ANSWARE_UNDONE
    }
    
    init(triviaQuestions: JSON) {
        question = triviaQuestions["question"].string!
        bitmapID = triviaQuestions["bitmap"].string
        
        var answersString = triviaQuestions["answers"][0].string
        var answersArray = answersString?.componentsSeparatedByString(",")
        
        for answear in answersArray! {
            answers.append(answear)
        }
        correctAnswer = triviaQuestions["correctAnswer"].int!
        rightMessage = triviaQuestions["rightMessage"].string
        wrongMessage = triviaQuestions["wrongMessage"].string
    }
    
    internal required init(coder aDecoder: NSCoder) {
        self.question = aDecoder.decodeObjectForKey("kquestion") as! String
        self.bitmapID = aDecoder.decodeObjectForKey("kbitmapID") as? String
        self.answers = aDecoder.decodeObjectForKey("kanswers") as! [String]
        self.correctAnswer = aDecoder.decodeObjectForKey("kcorrectAnswer") as! Int
        self.rightMessage = aDecoder.decodeObjectForKey("krightMessage") as? String
        self.wrongMessage = aDecoder.decodeObjectForKey("kwrongMessage") as? String
        //self.doneAnswer = aDecoder.decodeObjectForKey("kdoneAnswer") as! Int
    }
    
    func encodeWithCoder(encoder: NSCoder) {
        encoder.encodeObject(self.question, forKey: "kquestion")
        encoder.encodeObject(self.bitmapID, forKey: "kbitmapID")
        encoder.encodeObject(self.answers, forKey: "kanswers")
        encoder.encodeObject(self.correctAnswer, forKey: "kcorrectAnswer")
        encoder.encodeObject(self.rightMessage, forKey: "krightMessage")
        encoder.encodeObject(self.wrongMessage, forKey: "kwrongMessage")
        //encoder.encodeObject(self.doneAnswer, forKey: "kdoneAnswer")
    }

}