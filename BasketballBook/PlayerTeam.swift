//
//  Player.swift
//  BasketballBook
//
//  Created by 邱柏盛 on 2017/4/27.
//  Copyright © 2017年 BB. All rights reserved.
//

import UIKit

enum GuestOrHome {
    case Guest
    case Home
}

enum PlayerStatus {
    case Pitch
    case Bench
    case FoulOut
    case Injury
}

class Player: NSObject {
    private let playerId: String
    private let jerseyNum: Int
    private let guestOrHome: GuestOrHome
    private let myTeamString: String
    // 敵對名
    private let opponentString: String
    private var personalPts: Int
    private var personalFouls: Int
    // ***** 只有在場上的人才可以按按鈕(在計分板要加入的功能)
    var status: PlayerStatus
    let boxScoreSingleton = BoxScoreSingleton.standard
    
    init(playerIdShouldBeLoad: String, jerseyNumShouldBeLoad: Int, statusShouldBeSet: PlayerStatus, guestOrHomeShouldBeLoad: GuestOrHome) {
        playerId = playerIdShouldBeLoad
        jerseyNum = jerseyNumShouldBeLoad
        status = statusShouldBeSet
        guestOrHome = guestOrHomeShouldBeLoad
        
        if guestOrHome == GuestOrHome.Guest {
            myTeamString = boxScoreSingleton.guestId
            opponentString = boxScoreSingleton.homeId
        } else {
            myTeamString = boxScoreSingleton.homeId
            opponentString = boxScoreSingleton.guestId
        }
        personalPts = 0
        personalFouls = 0
        super.init()
    }
    
    func addFieldGoalMades() {
        personalPts += 2
        changeTeamScore(score: 2)
        playerLog(description: "+2 Pts.")
    }
    
    func add3PtsMade() {
        personalPts += 3
        changeTeamScore(score: 3)
        playerLog(description: "+3 Pts.")
    }
    
    func addFreeThrowMade() {
        personalPts += 1
        changeTeamScore(score: 1)
        playerLog(description: "Free Throw.")
    }
    
    // ***** 加入其他數據
    
    func addPersonalFoul() {
        if !boxScoreSingleton.isRestClockHidden {
            personalFouls += 1
            let quarterNowString = boxScoreSingleton.quarterNowString()
            if self.guestOrHome == GuestOrHome.Guest {
                boxScoreSingleton.guestFouls[quarterNowString]! += 1
            } else {
                boxScoreSingleton.homeFouls[quarterNowString]! += 1
            }
            
            // 判斷是否犯滿離場
            if personalFouls == boxScoreSingleton.rules!.limitForFoulsOut {
                print("\(myTeamString) \(jerseyNum) \(playerId) Foul Out")
            }
            
            // 判斷是否進入加罰
            if boxScoreSingleton.guestFouls[quarterNowString]! >= boxScoreSingleton.rules!.teamFoulsForBonus || boxScoreSingleton.homeFouls[quarterNowString]! >= boxScoreSingleton.rules!.teamFoulsForBonus {
                print("\(opponentString) Enter The Bonus Situation")
            }
            playerLog(description: "Foul")
        }
    }
    
    func changeTeamScore(score: Int) {
        if self.guestOrHome == GuestOrHome.Guest {
            boxScoreSingleton.guestScore += score
        } else {
            boxScoreSingleton.homeScore += score
        }
    }
    
    // 文字轉播
    private func playerLog(description: String) {
        print("\(myTeamString) \(jerseyNum) \(playerId) \(description)")
    }
}

class Team: NSObject {
    let teamId: String
    var teammates = [Player]()
    
    init(teamIdShouldBeLoad: String, teammatesShouldBeLoad: Player...) {
        teamId = teamIdShouldBeLoad
        for player in teammatesShouldBeLoad {
            teammates.append(player)
        }
        super.init()
    }
}
