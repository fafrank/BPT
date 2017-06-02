//
//  ClockView.swift
//  BasketballBook
//
//  Created by 邱柏盛 on 2017/5/11.
//  Copyright © 2017年 BB. All rights reserved.
//

import UIKit

class ClockView: UIView {
    // 剩餘的時間
    var lastedTime: TimeInterval!
    // 開始計時的時間點
    var timeStartedFrom: NSDate!
    // 預定的結束時間點
    var timeEndAt: NSDate!
    // 用來跑計時器
    var timer = Timer()
    // 計時器的狀態(有在跑嗎？)
    var isTimeRunning = false
    // 暫停或繼續
    var isResumeTapped = false
    // 自幾秒開始倒數
    let countdownFrom: TimeInterval
    
    // Lbl and Btns
    var lastedTimeLbl: UILabel!
    let startPauseResumeClockBtn = UIButton.init(type: UIButtonType.system)
    let addClockTimeBtn = UIButton.init(type: UIButtonType.system)
    let subtractClockTimeBtn = UIButton.init(type: .system)
    
    
    // frame 在 VC 中宣告
    init(frame: CGRect, countdownFromShouldBeLoad: TimeInterval) {
        countdownFrom = countdownFromShouldBeLoad
        super.init(frame: frame)
        // ***** 現在還是 hard code
        lastedTimeLbl = UILabel.init(frame: CGRect.init(x: 37.5, y: 0, width: 300, height: 100))
        lastedTimeLbl.backgroundColor = UIColor.clear
        lastedTimeLbl.text = timeString(time: countdownFrom)
        lastedTimeLbl.adjustsFontForContentSizeCategory = true
        lastedTimeLbl.font = UIFont.systemFont(ofSize: 115)
        //配合屏幕大小改變字體大小
        lastedTimeLbl.adjustsFontSizeToFitWidth = true
        lastedTimeLbl.textColor = UIColor.white
        lastedTimeLbl.textAlignment = NSTextAlignment.center
        
        startPauseResumeClockBtn.frame = lastedTimeLbl.frame
        startPauseResumeClockBtn.addTarget(self, action: #selector(startPauseResumeClockBtnPressed(_:)), for: .touchUpInside)
//        startPauseResumeClockBtn.autoresizesSubviews = true
        startPauseResumeClockBtn.setTitle("", for: .normal)
        
        addClockTimeBtn.frame = CGRect.init(x: 337.5, y: 0, width: 37.5, height: 100)
        addClockTimeBtn.addTarget(self, action: #selector(addClockTimeBtnPressed(_:)), for: .touchUpInside)
        addClockTimeBtn.setTitle("+", for: .normal)
//        addClockTimeBtn.backgroundColor = UIColor.red
        addClockTimeBtn.titleLabel?.textAlignment = .center
        
        subtractClockTimeBtn.frame = CGRect.init(x: 0, y: 0, width: 37.5, height: 100)
        subtractClockTimeBtn.addTarget(self, action: #selector(subtractClockTimeBtnPressed(_:)), for: .touchUpInside)
        subtractClockTimeBtn.setTitle("-", for: .normal)
//        subtractClockTimeBtn.backgroundColor = UIColor.red
        subtractClockTimeBtn.titleLabel?.textAlignment = .center
        
        self.addSubview(lastedTimeLbl)
        self.insertSubview(startPauseResumeClockBtn, aboveSubview: lastedTimeLbl)
        self.addSubview(addClockTimeBtn)
        self.addSubview(subtractClockTimeBtn)
        addClockTimeBtn.isEnabled = false
        subtractClockTimeBtn.isEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startPauseResumeClockBtnPressed(_ sender: UIButton) {
        if isTimeRunning == false {
            startCountdown()
        } else {
            pauseResume()
        }
    }
    
    // 加 1 秒, 若加完會超過上限值則重置
    func addClockTimeBtnPressed(_ sender: UIButton) {
        if lastedTime < countdownFrom {
            if lastedTime + 1 > countdownFrom {
                resetTheClock()
            } else {
                lastedTime.add(1)
                timeEndAt = NSDate.init(timeIntervalSinceNow: lastedTime)
                updateTimer()
            }
        }
    }
    
    // 減 1 秒, 若減完會低於下限值則重置
    func subtractClockTimeBtnPressed(_ sender: UIButton) {
        if lastedTime > 0 {
            if lastedTime - 1 < 0 {
                timeUp()
            } else {
                lastedTime.subtract(1)
                timeEndAt = NSDate.init(timeIntervalSinceNow: lastedTime)
                updateTimer()
            }
        }
    }
    
    // 開始倒數
    func startCountdown() {
        timeStartedFrom = NSDate()
        timeEndAt = timeStartedFrom.addingTimeInterval(countdownFrom)
        runTimer()
        isTimeRunning = true
        addClockTimeBtn.isEnabled = true
        subtractClockTimeBtn.isEnabled = true
    }
    
    // 每 0.1 秒呼叫 updateTimer
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
    }
    
    // 更新所剩餘時間, 並修改 Lbl 上的文字
    func updateTimer() {
        lastedTime = timeEndAt.timeIntervalSinceNow
        
        if lastedTime < 0 {
            timer.invalidate()
            timeUp()
        } else {
            lastedTimeLbl.text = timeString(time: lastedTime!)
        }
    }
    
    // 暫停
    func pauseResume() {
        if isResumeTapped {// Run resume
            timeEndAt = NSDate.init(timeIntervalSinceNow: lastedTime)
            runTimer()
            isResumeTapped = false
            addClockTimeBtn.isEnabled = true
            subtractClockTimeBtn.isEnabled = true
        } else {// Run pause
            timer.invalidate()
            isResumeTapped = true
        }
    }
    
    // 將 TimeInterval 轉為可讀的格式
    func timeString(time:TimeInterval) -> String {
        
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        let decasecond = Int(time * 10) % 10
        
        return String.init(format: "%02i:%02i.%i", minutes, seconds, decasecond)
    }
    
    // 時間到
    // 在其他 countdowner 覆寫
    func timeUp() {
        resetTheClock()
    }
    
    // 將計時器的變數還原
    // SC 的 startFrom24()
    func resetTheClock() {
        timer.invalidate()
        lastedTime = countdownFrom
        timeStartedFrom = nil
        timeEndAt = nil
        isTimeRunning = false
        isResumeTapped = false
        lastedTimeLbl.text = timeString(time: lastedTime)
        addClockTimeBtn.isEnabled = false
        subtractClockTimeBtn.isEnabled = false
    }

}
