//
//  Rules.swift
//  BasketballBook
//
//  Created by 邱柏盛 on 2017/4/27.
//  Copyright © 2017年 BB. All rights reserved.
//

import UIKit

enum StopTypeOfGameClock {
    case last2MinsInClutchQuarter
    case anytime
    case doNotStop
}

class Rules: NSObject {
    // 節數
    var quarters: Int
    // 每節幾分鐘
    var secondsPerQ:TimeInterval
    // 延長賽幾分鐘
    var secondsPerOT:TimeInterval
    // 節與節之間休息時間
    var secondsBtwQs:TimeInterval
    // 中場休息時間
    var halfTime:TimeInterval
    // 犯滿離場限制
    var limitForFoulsOut: Int
    // 單節團犯限制
    var teamFoulsForBonus: Int
    // 上半場暫停次數
    var timeoutsOfFirstHalf: Int
    // 下半場暫停次數
    var timeoutsOfSecondHalf: Int
    // 延長賽暫停次數
    var timeoutsOfOT: Int
    // 是否有進攻時間的限制
    var isShotClockExist: Bool
    
    var stopTypeOfGameClock: StopTypeOfGameClock

    
    init(quartersShouldBeLoad: Int,
         secondsPerQShouldBeLoad: TimeInterval,
         secondsPerOTShouldBeLoad: TimeInterval,
         secondsBtwQsShouldBeLoad: TimeInterval,
         halfTimeShouldBeLoad: TimeInterval,
         limitForFoulsOutShouldBeLoad: Int,
         teamFoulsForBonusShouldBeLoad: Int,
         timeoutsOfFirstHalfShouldBeLoad: Int,
         timeoutsOfSecondHalfShouldBeLoad: Int,
         timeoutsOfOTShouldBeLoad: Int,
         isShotClockExistShouldBeLoad: Bool,
         stopTypeOfGameClockShouldBeLoad: StopTypeOfGameClock) {
        
        
        quarters = quartersShouldBeLoad
        secondsPerQ = secondsPerQShouldBeLoad
        secondsPerOT = secondsPerOTShouldBeLoad
        secondsBtwQs = secondsBtwQsShouldBeLoad
        halfTime = halfTimeShouldBeLoad
        limitForFoulsOut = limitForFoulsOutShouldBeLoad
        teamFoulsForBonus = teamFoulsForBonusShouldBeLoad
        timeoutsOfFirstHalf = timeoutsOfFirstHalfShouldBeLoad
        timeoutsOfSecondHalf = timeoutsOfSecondHalfShouldBeLoad
        timeoutsOfOT = timeoutsOfOTShouldBeLoad
        isShotClockExist = isShotClockExistShouldBeLoad
        stopTypeOfGameClock = stopTypeOfGameClockShouldBeLoad
        
        // 根據所設定的 rules 來改變一些數值
        // reset all static var in BoxScoreSingleton
        let boxScoreSingleton = BoxScoreSingleton.standard
        if quartersShouldBeLoad == 2 {
            boxScoreSingleton.quarterString = ["Ready to Start", "Q1", "Half Time", "Q2", "End of Regular", "OT1", "End of OT1", "OT2", "End of OT2", "OT3", "End of Game"]
            boxScoreSingleton.guestFouls = ["Q1":0, "Q2":0, "OT1":0, "OT2":0, "OT3":0]
            boxScoreSingleton.homeFouls = ["Q1":0, "Q2":0, "OT1":0, "OT2":0, "OT3":0]
        } else {
            boxScoreSingleton.quarterString = ["Ready to Start", "Q1", "End of Q1", "Q2", "Half Time", "Q3", "End of Q3", "Q4", "End of Regular", "OT1", "End of OT1", "OT2", "End of OT2", "OT3", "End of Game"]
            boxScoreSingleton.guestFouls = ["Q1":0, "Q2":0, "Q3":0, "Q4":0, "OT1":0, "OT2":0, "OT3":0]
            boxScoreSingleton.homeFouls = ["Q1":0, "Q2":0, "Q3":0, "Q4":0, "OT1":0, "OT2":0, "OT3":0]
        }
        
        boxScoreSingleton.guestScore = 0
        boxScoreSingleton.homeScore = 0
        
    }
    
    convenience override init() {
        self.init(quartersShouldBeLoad: 4, secondsPerQShouldBeLoad: 600.0, secondsPerOTShouldBeLoad: 300.0, secondsBtwQsShouldBeLoad: 120, halfTimeShouldBeLoad: 900, limitForFoulsOutShouldBeLoad: 5, teamFoulsForBonusShouldBeLoad: 5, timeoutsOfFirstHalfShouldBeLoad: 2, timeoutsOfSecondHalfShouldBeLoad: 3, timeoutsOfOTShouldBeLoad: 1, isShotClockExistShouldBeLoad: true, stopTypeOfGameClockShouldBeLoad: .last2MinsInClutchQuarter)
    }
    

}
