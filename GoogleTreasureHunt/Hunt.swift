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
                var clue: Clue = Clue()
                clue.id = cluesArray[i]["id"].string
                clue.type = cluesArray[i]["type"].string
                clue.shufflegroup = cluesArray[i]["shufflegroup"].int
                clue.displayName = cluesArray[i]["displayName"].string
                clue.displayText = cluesArray[i]["displayText"].string
                clue.displayImage = cluesArray[i]["displayImage"].string
                if let tagsArray = cluesArray[i]["tags"].array {
                    for(var t = 0; t < tagsArray.count; t++){
                        var tagId = tagsArray[t]["id"].string!
                        var ahTag: AHTag = AHTag(idPassed: tagId, clueIdPassed: clue.id)
                        clue.tags.append(ahTag)
                        
                        tagsFound.updateValue(false, forKey: tagId)
                    }
                }
                
                clue.question = TriviaQuestion(myQuestion: cluesArray[i]["question"]["question"].string!)
                clue.question?.bitmapID = cluesArray[i]["question"]["bitmap"].string
                    
                var answersArray = cluesArray[i]["question"]["answers"].array
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
            var clueIter:Clue = clues[i]
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
  
//    /** Saves the player's progress */
//    func save(){
//        var data: NSMutableData = NSMutableData()
//        var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
//        var path = paths.stringByAppendingPathComponent("data.plist")
//        var fileManager = NSFileManager.defaultManager()
//        if (!(fileManager.fileExistsAtPath(path)))
//        {
//            var bundle : NSString = NSBundle.mainBundle().pathForResource("data", ofType: "plist")!
//            fileManager.copyItemAtPath(bundle as String, toPath: path, error:nil)
//        }
//        for (var i = 0; i < tagsFound.count; i++){
//            data.setValue(tagsFound.values.array[i], forKey: tagsFound.keys.array[i])
//        }
//        data.setValue(hasSeenIntro, forKey: HAS_SEEN_INTRO_KEY)
//        data.setValue(questionState, forKey: QUESTION_STATE_KEY)
//        data.setValue(finishTime, forKey: FINISH_TIME_KEY)
//        //data.setObject(self.object, forKey: "object")
//        data.writeToFile(path, atomically: true)
//    }
//    
//    /** Loads player progress. */
//    func restore() {
//        //TODO restore data
//        var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
//        var path = paths.stringByAppendingPathComponent("data.plist")
//        
//        let save = NSDictionary(contentsOfFile: path)
//        
//        for (var i = 0; i < tagsFound.count; i++){
//            var val:Bool = (save?.valueForKey(tagsFound.keys.array[i])) as! Bool
//            tagsFound.updateValue(val, forKey: tagsFound.keys.array[i])
//        }
//        hasSeenIntro =  save?.valueForKey(HAS_SEEN_INTRO_KEY) as! Bool
//        questionState = save?.valueForKey(QUESTION_STATE_KEY) as! Int
//        finishTime = save?.valueForKey(FINISH_TIME_KEY) as! Double
//    }
//
//    /** Returns whether or not we're in a question so we can restore itself. */
//    func getQuestionState() ->Int {
//        return questionState;
//    }
//    
//    /** Deletes all player progress.*/
//    func reset() {
//        //tagsFound = Dictionary<String,Bool>()
///*
//        for tag :AHTag in tagList {
//            tagsFound.updateValue(false, forKey: tag.id)
//        }
//*/        // I'm not currently asking a question
//        questionState = QUESTION_STATE_NONE;
//        hasSeenIntro = false;
//        
//        //Delete data
//        DataManager.sharedInstance.deleteHunt()
//        var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
//        var path = paths.stringByAppendingPathComponent("data.plist")
//        path.removeAll(keepCapacity: true)
//    }
//    
//    func getCurrentClue() ->Clue? {
//        var length:Int = clues.count;
//        for (var i:Int = 0; i < length; i++) {
//            var clue:Clue = clues[i];
//    
//            if (isClueFinished(clue) && questionState != QUESTION_STATE_NONE) {
//                // We're still asking a question
//                return clue;
//            }
//    
//            if (!isClueFinished(clue)) {
//                return clue;
//            }
//        }
//        // The hunt is complete!
//        return nil
//    }
//    
//    /** What clue have I *just* completed? */
//    func getLastCompletedClue() -> Clue? {
//        var length:Int = clues.count
//        var lastBestClue:Clue?
//        for var i:Int = 0; i < length; i++ {
//            var clue:Clue = clues[i]
//    
//            if (!isClueFinished(clue)) {
//                return lastBestClue
//            }
//            lastBestClue = clue
//        }
//        // The hunt is complete.
//        return lastBestClue
//    }
//    
//    
//    func isTagFound(id:String ) -> Bool {
////        if ((tagsFound.indexForKey(id)) == nil) {
////            return false;
////        }
////        return tagsFound[id]!;
//        
//        for tag in getCurrentClue()!.tags{
//            if tag.id == id && tag.isFound == false{
//                return false
//            }
//        }
//        return true
//    }
//    
//    func tagIsFound(id:String){
//        let clueNum = getCurrentClue()!.number
//        var tagNum = 0
//        for (var h=0; h<getCurrentClue()!.tags.count; h++){
//            if getCurrentClue()!.tags[h].id == id{
//                tagNum = h
//            }
//        }
//        self.clues[clueNum].tags[tagNum].isFound = true
//        DataManager.sharedInstance.salvaHunt()
//    }
//    
//    func getTagFromId(id:String) -> AHTag?{
//        var tags = getCurrentClue()!.tags
//        for (var h=0; h<tags.count; h++){
//            if tags[h].id == id{
//                return tags[h]
//            }
//        }
//        return nil
//    }
//    
//    /**
//    * Called when a tag is scanned.  Checks the hunt
//    */
//    func findTag(tagId:String) -> String? {
//        println(tagId)
//        if (tagId == DECOY_ID) {
//            return DECOY;
//        }
//        // See if this tag is part of this clue
//        var clue:Clue = getCurrentClue()!;
//    
////        var tag:AHTag? = tags[tagId]!;
//        var tag:AHTag? = getTagFromId(tagId)
//        
//        if tag == nil {
//            return WRONG_CLUE
//        }
//    
//        if (clue.id == tag!.clueId) {
//            if (isTagFound(tagId)) {
//                return ALREADY_FOUND
//            }
//    
//            tagIsFound(tag!.id)
////            tagsFound.updateValue(true, forKey: tag!.id)
//    
//            if (isClueFinished(clue)) {
//                return CLUE_COMPLETE;
//            }
//            return ACK;
//        }
//        return WRONG_CLUE;
//    }
//    
//    /** Have we found all the clues?  Does not check question completeness. */
//    func isClueFinished(clue:Clue) ->Bool {
//        for tag :AHTag in clue.tags {
////            if (!isTagFound(tag.id)) {
//            if (tag.isFound == false) {
//                return false;
//            }
//        }
//        return true;
//    }
//    
//    func hasAnsweredQuestion(clue:Clue) -> Bool{
//        var currentClueNum:Int = getClueIndex(clue)
//        
//        // Find the first question in the list and see if we're past it.
//        var totalClues:Int = clues.count
//        for var i:Int = 0; i < totalClues; i++ {
//            if (clues[i].question != nil) {
//                return currentClueNum > i;
//            }
//        }
//        return false;
//    }
//    
//    /** Count from 1. */
//    func getClueDisplayNumber(clue:Clue) ->Int {
//        return  NSArray(array: clues).indexOfObject(clue)+1
//    }
//    
//    /** Count from 0. */
//    func getClueIndex(clue:Clue) ->Int {
//        return NSArray(array: clues).indexOfObject(clue);
//    }
//    
///*
//    func setClueImage() {
//        let clue:Clue = getCurrentClue()!;
//    
//        if (clue.displayImage == nil) {
//            imgView.setImageDrawable(res.getDrawable(R.drawable.ab_icon));
//        } else {
//            imgView.setImageDrawable(hrm.drawables.get(clue.displayImage));
//        }
//    }
//*/
//    
////    func getHasSeenIntro() -> Bool {
////        return hasSeenIntro
////    }
////    
////    func setIntroSeen(val:Bool) {
////        hasSeenIntro = val;
////    }
////
////    func setQuestionState(state:Int) {
////        questionState = state;
////    }
//    
//    func setStartTime() {
//        finishTime = CFAbsoluteTimeGetCurrent() + 15000;
//    }
//    
//    func getFinishTime() -> Double {
//        return CFAbsoluteTimeGetCurrent()
//    }
//    
//    func getSecondsLeft() -> Int{
//        return Int((finishTime - CFAbsoluteTimeGetCurrent()) / 1000.0)
//    }
//    
//    func isComplete() ->Bool {
//        return (getCurrentClue() == nil)
//    }
    
    
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
        var currentClue = getThisCLue()
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
        var currentClue = getThisCLue()
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
        var clue = getThisCLue()
        if clue != nil && clue!.question != nil && !clue!.question!.answers.isEmpty && questions[clue!.id] == ANSWARE_UNDONE{
            isThereQuestion = true
        }
        return isThereQuestion
    }
    
    func getThisCLue() -> Clue?{
        var length:Int = clues.count;
        for (var i:Int = 0; i < length; i++) {
            var clue:Clue = clues[i];
            
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
    
    func messageFromTag(tagId:String) -> String{
        if (tagId == DECOY_ID) {
            return DECOY;
        }
        // See if this tag is part of this clue
        var clue:Clue = getThisCLue()!;
        
        //        var tag:AHTag? = tags[tagId]!;
        var tag:AHTag? = getClueTagFromId(tagId)
        
        if tag == nil {
            return WRONG_CLUE
        }
        
        if (clue.id == tag!.clueId) {
            if (isClueTagFound(tagId)) {
                return ALREADY_FOUND
            }
            if (isClueComplete(clue)) {
                return CLUE_COMPLETE;
            }
            //setTagFound(tag!.id) //si setta dopo
            return ACK;
        }
        return WRONG_CLUE;
    }
    
    func setTagFound(id:String){
        DataManager.sharedInstance.hunt!.tagsFound.updateValue(true, forKey: id)
        DataManager.sharedInstance.salvaHunt()
        DataManager.sharedInstance.loadHunt()
    }
    
    func answerMessage(answer:Int) -> String{
        var currentClue = getThisCLue()!
        
        setAnswer(answer)
            
        if currentClue.question!.correctAnswer == answer{
            return currentClue.question!.rightMessage!
        }else{
            return currentClue.question!.wrongMessage!
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
        for (var i:Int = 0; i < cluesWithQuestion.count; i++) {
            var clue:Clue = cluesWithQuestion[i];
            var questionDone:Int = questions.values.array[i]
            if (clue.question?.correctAnswer == questionDone) {
                num++;
            }
        }
        return num
    }
    
    func setAnswer(answer:Int){
        var currentClue = getThisCLue()!
        DataManager.sharedInstance.hunt!.questions.updateValue(answer, forKey: currentClue.id)
        DataManager.sharedInstance.salvaHunt()
        DataManager.sharedInstance.loadHunt()
    }
}
