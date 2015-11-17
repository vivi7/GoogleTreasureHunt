//
//  Hunt.swift
//  TreasureHunt
//
//  Created by Vincenzo Favara on 25/09/14.
//  Copyright (c) 2014 Vincenzo Favara. All rights reserved.
//

import Foundation

let QUESTION_STATE_NONE:Int = 0
let QUESTION_STATE_INTRO:Int = 1
let QUESTION_STATE_QUESTIONING:Int = 2
let QUESTION_STATE_KEY:String = "QUESTION_STATE_KEY"
let FINISH_TIME_KEY:String = "FINISH_TIME_KEY"
let HAS_SEEN_INTRO_KEY: String = "HAS_SEEN_INTRO_KEY";

let SOUND_COIN = "coin"
let SOUND_REPEAT = "repeat"
let SOUND_FOUNDITALL = "founditall"
let SOUND_FANFARE = "fanfare"
let SOUND_REJECTED = "rejected"

let WRONG_CLUE:String = "WRONG CLUE"
let ACK:String = "TAG FOUND"
let CLUE_COMPLETE:String = "CLUE COMPLETE"
let ALREADY_FOUND:String = "ALREADY FOUND"
let DECOY:String = "DECOY"

// The actual text for the DECOY clue.
let DECOY_ID:String = "decoy"

class Hunt : NSObject, NSCoding{
    
    var id: String!
    var type: String!
    var displayName: String!
    var clues: [Clue] = []
    //var clueListShuffleFinal: [Clue] = []
    //var tagList: Array<AHTag> = Array<AHTag>()
    //var triviaQuestion: TriviaQuestion?
    
    //var theHunt:Hunt
    var hrm:HuntResourceManager = HuntResourceManager()
    
    var isShuffled:Bool = false
    var questionState:Int = 0
    var finishTime:Double = 0.0
    
//    var soundManager:SoundManager = SoundManager()
//    var achievementManager:AchievementManager = AchievementManager()
    
    var tagsFound: Dictionary<String,Bool> = Dictionary<String,Bool>()
    var questions: Dictionary<String,Int> = Dictionary<String,Int>()
//    var tags: Dictionary<String,AHTag> = Dictionary<String,AHTag>()
    
    var hasSeenIntro:Bool = false;
    
    override init(){
        super.init()
    }
    
    internal required init(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObjectForKey("kid") as! String
        self.type = aDecoder.decodeObjectForKey("ktype") as! String
        self.displayName = aDecoder.decodeObjectForKey("kdisplayName") as! String
        self.clues = aDecoder.decodeObjectForKey("kclues") as! [Clue]
        self.tagsFound = aDecoder.decodeObjectForKey("ktagsFound") as! Dictionary<String,Bool>
        self.questions = aDecoder.decodeObjectForKey("kquestions") as! Dictionary<String,Int>
    }
    
    func encodeWithCoder(encoder: NSCoder) {
        encoder.encodeObject(self.id, forKey: "kid")
        encoder.encodeObject(self.type, forKey: "ktype")
        encoder.encodeObject(self.displayName, forKey: "kdisplayName")
        encoder.encodeObject(self.clues, forKey: "kclues")
        encoder.encodeObject(self.tagsFound, forKey: "ktagsFound")
        encoder.encodeObject(self.questions, forKey: "kquestions")
    }
    
    func getHunt() -> Hunt{
        return self
    }
    
    /** Generates the entire hunt structure from JSON */
    func createHunt(){
        
        let jsonData = hrm.getJsonData()
        let json = JSON(data: jsonData)
        
        id = json["id"].string
        type = json["type"].string
        displayName = json["displayName"].string
        
        if let cluesArray = json["clues"].array {
            for(var i = 0; i < cluesArray.count; i++){
                let clue: Clue = Clue()
                clue.id = cluesArray[i]["id"].string
                clue.type = cluesArray[i]["type"].string
                clue.shufflegroup = cluesArray[i]["shufflegroup"].int
                clue.displayName = cluesArray[i]["displayName"].string
                clue.displayText = cluesArray[i]["displayText"].string
                clue.displayImage = cluesArray[i]["displayImage"].string
                if let tagsArray = cluesArray[i]["tags"].array {
                    for(var t = 0; t < tagsArray.count; t++){
                        let tagId = tagsArray[t]["id"].string!
                        let ahTag: AHTag = AHTag(idPassed: tagId, clueIdPassed: clue.id)
                        clue.tags.append(ahTag)
                        
                        tagsFound.updateValue(false, forKey: tagId)
                    }
                }
                
                clue.question = TriviaQuestion(myQuestion: cluesArray[i]["question"]["question"].string!)
                clue.question?.bitmapID = cluesArray[i]["question"]["bitmap"].string
                    
                let answersArray = cluesArray[i]["question"]["answers"].array
                if answersArray != nil && !answersArray!.isEmpty{
                    for answear in answersArray! {
                        clue.question?.answers.append(answear.string!)
                    }
                    questions.updateValue(ANSWARE_UNDONE, forKey: clue.id)
                }
                clue.question?.correctAnswer = cluesArray[i]["question"]["correctAnswer"].int!
                clue.question?.rightMessage = cluesArray[i]["question"]["rightMessage"].string
                clue.question?.wrongMessage = cluesArray[i]["question"]["wrongMessage"].string
                
                //clue.number = i
                
                clues.append(clue)
            }
        }
        shuffle()
    }
    
    
    /** Shuffles the clues.  Note that each clue is marked with
    *  a difficulty group, so that, say, a hard clue can't preceed
    *  an easier clue.
    */
    func shuffle() {
        if (isShuffled) {
            return;
        }
        
        var cluesToShuffle:[Clue] = [];
    
        let firstClue:Clue = clues[0]
        let lastClue:Clue = clues[clues.count-1]
        
        //Divide Clues for shufflegroup
        for var i:Int = 0; i < clues.count; i++ {
            let clueIter:Clue = clues[i]
            if (clueIter.shufflegroup != firstClue.shufflegroup &&
                clueIter.shufflegroup != lastClue.shufflegroup) {
                cluesToShuffle.append(clueIter)
            }
        }
        //Shuffle clues divided
        var clueListShuffle:[Clue] = shuffleClues(cluesToShuffle)
        
        //empy clues
        clues.removeAll(keepCapacity: true)
        
        //Set clueListShufflFinal
        clues.append(firstClue)
        for (var i=0; i<clueListShuffle.count; i++) {
            clues.append(clueListShuffle[i])
        }
        clues.append(lastClue)
            
        isShuffled = true;
    }
    
    func shuffleClues(var list: [Clue]) -> [Clue] {
        for i in 0..<list.count {
            let j = Int(arc4random_uniform(UInt32(list.count - i))) + i
            list.insert(list.removeAtIndex(j), atIndex: i)
        }
        return list
    }   
    
    // MARK: - new controls
    
    func tagIsFound(tagId:String) -> Bool{
        for tagDic in tagsFound{
            if tagDic.0 == tagId && tagDic.1 == true{
                return true
            }
        }
        return false
    }
    
    //go to question
    func readyForAnswers() -> Bool{
        getThisCLue()
        if tagsRemain() == 0  && isThereQuestionToAnswer() == true{
            return true
        }
        return false
    }
    
    //go to congratulation
    func isHuntComplete() -> Bool{
        for clue in clues{
            if isClueComplete(clue) == false{
                return false
            }
        }
        return true
    }
    
    //go to next clue
    func isClueComplete() -> Bool{
        if tagsRemain() == 0  && isThereQuestionToAnswer() == false{
            return true
        }
        return false
    }
    func isClueComplete(clue:Clue) -> Bool{
        for tag :AHTag in clue.tags {
            if (tagIsFound(tag.id) == false) {
                return false;
            }
        }
        if clue.question != nil && questions[clue.id] == ANSWARE_UNDONE{
            return false
        }
        return true
    }
    
    func getNumClueView() -> Int{
        var num = 0
        for clue in clues{
            for tag in clue.tags{
                if tagIsFound(tag.id){
                    num++
                }
            }
        }
        num = (num/2)+1
        return num
    }
    
    func getTotalClues() -> Int {
        return clues.count;
    }
    
    func tagsRemain() -> Int{ //0,1,2
        var tagsRemain = 0
        let currentClue = getThisCLue()
        if currentClue != nil{
            for tag :AHTag in currentClue!.tags {
                if (tagIsFound(tag.id) == false) {
                    tagsRemain++
                }
            }
        }
        return tagsRemain
    }
    
    func isThereQuestionToAnswer() -> Bool{
        var isThereQuestion = false
        let clue = getThisCLue()
        if clue != nil && clue!.question != nil && !clue!.question!.answers.isEmpty && questions[clue!.id] == ANSWARE_UNDONE{
            isThereQuestion = true
        }
        return isThereQuestion
    }
    
    func getThisCLue() -> Clue?{
        let length:Int = clues.count;
        for (var i:Int = 0; i < length; i++) {
            let clue:Clue = clues[i];
            
            if (!isClueComplete(clue)) {
                return clue;
            }
        }
        // The hunt is complete!
        return nil;
    }
    
    func getClueTagFromId(id:String) -> AHTag?{
        var tags = getThisCLue()!.tags
        for (var h=0; h<tags.count; h++){
            if tags[h].id == id{
                return tags[h]
            }
        }
        return nil
    }
    
    func isClueTagFound(id:String ) -> Bool {
        for tag in getThisCLue()!.tags{
            if (tagIsFound(tag.id) == false) {
                return false
            }
        }
        return true
    }
    
    func messageFromTag(tagId:String) -> (String,String){
        if (tagId == DECOY_ID) {
            return (DECOY, SOUND_REJECTED);
        }
        // See if this tag is part of this clue
        let clue:Clue = getThisCLue()!;
        
        //        var tag:AHTag? = tags[tagId]!;
        let tag:AHTag? = getClueTagFromId(tagId)
        
        if tag == nil {
            return (WRONG_CLUE, SOUND_REJECTED)
        }
        
        if (clue.id == tag!.clueId) {
            if (isClueTagFound(tagId)) {
                return (ALREADY_FOUND, SOUND_REPEAT)
            }
            if (isClueComplete(clue)) {
                return (CLUE_COMPLETE, SOUND_FOUNDITALL)
            }
            //setTagFound(tag!.id) //si setta dopo
            return (ACK, SOUND_COIN)
        }
        return (WRONG_CLUE, SOUND_REJECTED)
    }
    
    func setTagFound(id:String){
        DataManager.sharedInstance.hunt!.tagsFound.updateValue(true, forKey: id)
        DataManager.sharedInstance.salvaHunt()
        DataManager.sharedInstance.loadHunt()
    }
    
    func answerMessage(answer:Int) -> (String,Bool){
        let currentClue = getThisCLue()!
        
        setAnswer(answer)
            
        if currentClue.question!.correctAnswer == answer{
            return (currentClue.question!.rightMessage!, true)
        }else{
            return (currentClue.question!.wrongMessage!, false)
        }
    }
    
    func numAnswersCorrect() -> Int{
        var cluesWithQuestion : [Clue] = []
        for clue in clues{
            if clue.question != nil{
                cluesWithQuestion.append(clue)
            }
        }
        var num = 0
        let arrValFromDict = Array(questions.values)
        for (var i:Int = 0; i < cluesWithQuestion.count; i++) {
            let clue:Clue = cluesWithQuestion[i];
//            let questionDone:Int = questions.values.array[i]
            let questionDone:Int = arrValFromDict[i]
            if (clue.question?.correctAnswer == questionDone) {
                num++;
            }
        }
        return num
    }
    
    func setAnswer(answer:Int){
        let currentClue = getThisCLue()!
        DataManager.sharedInstance.hunt!.questions.updateValue(answer, forKey: currentClue.id)
        DataManager.sharedInstance.salvaHunt()
        DataManager.sharedInstance.loadHunt()
    }
}
