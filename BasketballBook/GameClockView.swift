//
//  GameClockView.swift
//  BasketballBook
//
//  Created by 邱柏盛 on 2017/5/11.
//  Copyright © 2017年 BB. All rights reserved.
//

import UIKit
import SwiftyButton
import PureLayout

class GameClockView: ClockView {
    // ShotClock
    var shotClock: ShotClockView?
    // 休息鐘
    var restClock: RestClockView!
    var periodLbl: UILabel!
    var homeScoreLbl: UILabel!
    var homeAccumulatedFoulsThisQtrLbl: UILabel!
    var guestScoreLbl: UILabel!
    var guestAccumulatedFoulsThisQtrLbl: UILabel!
    var timeoutRequestFromHomeBtn:FlatButton!
    var timeoutRequestFromGuestBtn:FlatButton!
    // 判斷有無影響到大錶的暫停
    var isTimeoutCalledInfluencingGameClock: Bool = false
    
    let boxScoreSingleton = BoxScoreSingleton.standard
    
//    func layout1() {
//        periodLbl = UILabel.newAutoLayout()
//        homeScoreLbl = UILabel.newAutoLayout()
//        homeAccumulatedFoulsThisQtrLbl = UILabel.newAutoLayout()
//        guestScoreLbl = UILabel.newAutoLayout()
//        guestAccumulatedFoulsThisQtrLbl = UILabel.newAutoLayout()
//        timeoutRequestFromHomeBtn = FlatButton.newAutoLayout()
//        timeoutRequestFromGuestBtn = FlatButton.newAutoLayout()
//        shotClock = ClockView.newAutoLayout() as? ShotClockView
//    }
    
    override init(frame: CGRect, countdownFromShouldBeLoad: TimeInterval) {
        
        super.init(frame: frame, countdownFromShouldBeLoad: countdownFromShouldBeLoad)
        
        // 若沒有開啟 24 秒進攻限制則 shotClock 不給按
        if boxScoreSingleton.rules.isShotClockExist {
            // GC 有開啟switch
//            subtractClockTimeBtn.frame = CGRect.init(x: (lastedTimeLbl.frame.width/3)-10, y: self.frame.height/3, width: 40, height: 40)
//            subtractClockTimeBtn.backgroundColor = UIColor.red
//            lastedTimeLbl.frame = CGRect.init(x: 0, y: 0, width: self.frame.width, height: self.frame.height/3)
//            startPauseResumeClockBtn.frame = CGRect.init(x: 0, y: 0, width: self.frame.width, height: self.frame.height/3)
//            addClockTimeBtn.frame = CGRect.init(x: lastedTimeLbl.frame.width/1.5, y: self.frame.height/3, width: 40, height: 40)
            self.GameClockConstraint()
            addClockTimeBtn.backgroundColor = UIColor.red
            
            // SC
            let shotClockFrame = CGRect.init(x: 0, y: (self.frame.height - lastedTimeLbl.frame.height)/2, width: self.frame.width, height: (self.frame.height - lastedTimeLbl.frame.height)/2)
            shotClock = ShotClockView.init(frame: shotClockFrame, countdownFromShouldBeLoad: 24)
            shotClock!.shotClockConstraint()
            shotClock!.sendSubview(toBack:addClockTimeBtn)
            shotClock!.sendSubview(toBack:subtractClockTimeBtn)
            self.insertSubview(shotClock!, at: 0)

        } else {
            // GC 沒開啟switch
            subtractClockTimeBtn.frame = CGRect.init(x: (lastedTimeLbl.frame.width/3)-10, y: (self.frame.height/2)-20, width: 40, height: 40)
            lastedTimeLbl.frame = CGRect.init(x: 0, y: (self.frame.height/15)-30, width: self.frame.width, height: self.frame.height/2)
            startPauseResumeClockBtn.frame = CGRect.init(x: 0, y: (self.frame.height/15)-30, width: self.frame.width, height: self.frame.height/2)
            addClockTimeBtn.frame = CGRect.init(x: lastedTimeLbl.frame.width/1.5, y: (self.frame.height/2)-20, width: 40, height: 40)
        }
        
        
        
        // Other labels & buttons
        periodLbl = UILabel.init(frame: CGRect.init(x: (self.frame.width/2)-40, y: (self.frame.height/1.5)+10, width: 75, height: 75))
        periodLbl.font = UIFont.systemFont(ofSize: 12)
        periodLbl.textAlignment = .center
//        periodLbl.backgroundColor = UIColor.red
        self.addSubview(periodLbl)
        
        homeScoreLbl = UILabel.init(frame: CGRect.init(x: (self.frame.width/2)-210, y: (self.frame.height/1.5)-20, width: 150, height: 50))
        homeScoreLbl.textAlignment = .center
        self.addSubview(homeScoreLbl)
        
        homeAccumulatedFoulsThisQtrLbl = UILabel.init(frame: CGRect.init(x: (self.frame.width/2)-200, y: (self.frame.height/1.5)+35, width: 50, height: 50))
        homeAccumulatedFoulsThisQtrLbl.textAlignment = .center
        homeAccumulatedFoulsThisQtrLbl.backgroundColor = UIColor.red
        self.addSubview(homeAccumulatedFoulsThisQtrLbl)
        
        guestScoreLbl = UILabel.init(frame: CGRect.init(x: (self.frame.width/2)+55, y: (self.frame.height/1.5)-20, width: 150, height: 50))
        guestScoreLbl.textAlignment = .center
        self.addSubview(guestScoreLbl)
        
        guestAccumulatedFoulsThisQtrLbl = UILabel.init(frame: CGRect.init(x: (self.frame.width/1.5)+80, y: (self.frame.height/1.5)+35, width: 50, height: 50))
        guestAccumulatedFoulsThisQtrLbl.textAlignment = .center
        guestAccumulatedFoulsThisQtrLbl.backgroundColor = UIColor.red
        self.addSubview(guestAccumulatedFoulsThisQtrLbl)
        
        timeoutRequestFromHomeBtn = FlatButton.init(frame: CGRect(x: (self.frame.width/2)-125, y: (self.frame.height/1.5)+35, width: 50, height: 50))
        timeoutRequestFromHomeBtn.addTarget(self, action: #selector(callTimeout(_:)), for: .touchUpInside)
        timeoutRequestFromHomeBtn.setTitle(String(boxScoreSingleton.rules.timeoutsOfFirstHalf), for: .normal)
        timeoutRequestFromHomeBtn.titleLabel?.textAlignment = .center
        self.addSubview(timeoutRequestFromHomeBtn)
        timeoutRequestFromHomeBtn.isEnabled = false
        
        timeoutRequestFromGuestBtn = FlatButton.init(frame: CGRect(x: (self.frame.width/1.5)-5, y: (self.frame.height/1.5)+35, width: 50, height: 50))
        timeoutRequestFromGuestBtn.addTarget(self, action: #selector(callTimeout(_:)), for: .touchUpInside)
        timeoutRequestFromGuestBtn.setTitle(String(boxScoreSingleton.rules.timeoutsOfFirstHalf), for: .normal)
        timeoutRequestFromGuestBtn.titleLabel?.textAlignment = .center
        self.addSubview(timeoutRequestFromGuestBtn)
        timeoutRequestFromGuestBtn.isEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func startPauseResumeClockBtnPressed(_ sender: UIButton) {
        if let shotClock = shotClock {
            shotClock.isTimeRunning = isTimeRunning
            shotClock.isResumeTapped = isResumeTapped
            shotClock.startPauseResumeClockBtnPressed(sender)
        }
        
        super.startPauseResumeClockBtnPressed(sender)
    }
    
    override func startCountdown() {
        timeStartedFrom = NSDate()
        timeEndAt = timeStartedFrom.addingTimeInterval(countdownFrom)
        runTimer()
        isTimeRunning = true
        addClockTimeBtn.isEnabled = true
        subtractClockTimeBtn.isEnabled = true
        timeoutRequestFromHomeBtn.isEnabled = true
        timeoutRequestFromGuestBtn.isEnabled = true
        boxScoreSingleton.quarterNow += 1
    }
    
    override func updateTimer() {
        lastedTime = timeEndAt.timeIntervalSinceNow
        
        if let shotClock = shotClock {
            if lastedTime < shotClock.lastedTime {
                shotClock.showInvalidShotClockLbl()
            }
        }
        
        if lastedTime < 0 {
            timer.invalidate()
            timeUp()
        } else if isTimeoutCalledInfluencingGameClock {// 判斷有無暫停大錶的需求
            isResumeTapped = false
            startPauseResumeClockBtnPressed(startPauseResumeClockBtn)
            isTimeoutCalledInfluencingGameClock = false
        } else {
            lastedTimeLbl.text = timeString(time: lastedTime!)
        }
    }
    
    override func pauseResume() {
        if isResumeTapped {// Run resume
            timeEndAt = NSDate.init(timeIntervalSinceNow: lastedTime)
            runTimer()
            isResumeTapped = false
            if let shotClock = shotClock {
                shotClock.startPauseResumeClockBtn.isEnabled = true
            }
        } else {// Run pause
            timer.invalidate()
            isResumeTapped = true
            if let shotClock = shotClock {
                shotClock.startPauseResumeClockBtn.isEnabled = false
            }
        }
    }
    
    override func timeUp() {
        // 所有的按鈕都不准按
        super.timeUp()
        if let shotClock = shotClock {
            shotClock.timeUp()
        }
        
        let restClockFrame = CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: self.subtractClockTimeBtn.frame.size.height)
        // 若為 Regular 節間的結束, 進入休息時間
        if boxScoreSingleton.quarterNow < boxScoreSingleton.rules.quarters * 2 - 1 {
            boxScoreSingleton.quarterNow += 1
            
            // 判斷是否進入下半場
            if boxScoreSingleton.quarterNow == boxScoreSingleton.rules.quarters + 1 {
                // 中場休息倒數
                initRestClock(frame: restClockFrame, secondsForRest: boxScoreSingleton.rules.halfTime)
                // 在 VC 改變可用暫停數
                
            } else {
                // 一般休息時間倒數
                initRestClock(frame: restClockFrame, secondsForRest: boxScoreSingleton.rules.secondsBtwQs)
            }
        } else {
            // 否則進行主客隊分數比較
            // 若比分相同, 進入延長賽
            if boxScoreSingleton.guestScore == boxScoreSingleton.homeScore {
                boxScoreSingleton.quarterNow += 1
                // OT 休息時間倒數
                initRestClock(frame: restClockFrame, secondsForRest: boxScoreSingleton.rules.secondsBtwQs)
                // 在 VC 改變可用暫停數
            } else {
                // 否則輸出報表到資料庫
                // 跳轉頁面到記錄
                // ***** 東哥的部份
            }
        }
    }
    
    func initRestClock(frame: CGRect, secondsForRest: TimeInterval) {
        restClock = RestClockView.init(frame: frame, countdownFromShouldBeLoad: secondsForRest)
        if let shotClock = shotClock {
            self.insertSubview(restClock, aboveSubview: shotClock)
        } else {
            self.addSubview(restClock)
            self.bringSubview(toFront: restClock)
        }
        restClock.startCountdown()
        // 將按鈕全部隱藏
        restClock.addClockTimeBtn.isHidden = true
        restClock.subtractClockTimeBtn.isHidden = true
        restClock.startPauseResumeClockBtn.isHidden = true
    }
    
    // TimeoutRequest
    func callTimeout(_ sender: UIButton) {
        var timeoutlasted = Int((sender.titleLabel?.text)!)
        
        // 判斷剩餘請求暫停數是否大於 0
        if timeoutlasted! > 0 {
            timeoutlasted! -= 1
            sender.setTitle(String(timeoutlasted!), for: .normal)
            if let shotClock = shotClock {
                shotClock.isResumeTapped = false
                shotClock.pauseResume()
            }
            
            // 生成休息錶
            initRestClock(frame: CGRect.init(x: sender.frame.minX, y: sender.frame.maxY, width: sender.frame.size.width, height: sender.frame.size.height), secondsForRest: 5)
            
            if boxScoreSingleton.rules.stopTypeOfGameClock == .last2MinsInClutchQuarter {
                
                // 判斷是否為決勝節
                if boxScoreSingleton.quarterNow > boxScoreSingleton.rules.quarters - 2 && lastedTime < 120 {
                    
                    // 若 restClock 的 timeEndAt 在 大錶的剩餘兩分鐘內, 則 isTimeoutCalledWithinLast2Mins 為 true
                    let gameClocksLast2Mins = timeEndAt.addingTimeInterval(-120)
                    if restClock.timeEndAt.compare(gameClocksLast2Mins as Date) == .orderedDescending {
                        isTimeoutCalledInfluencingGameClock = true
                    }
                }
            } else if boxScoreSingleton.rules.stopTypeOfGameClock == .anytime {
                isTimeoutCalledInfluencingGameClock = true
            }
            
        }
    }

}
