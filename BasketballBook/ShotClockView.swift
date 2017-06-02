//
//  ShotClockView.swift
//  BasketballBook
//
//  Created by 邱柏盛 on 2017/5/15.
//  Copyright © 2017年 BB. All rights reserved.
//

import UIKit

class ShotClockView: ClockView {
    
    
    let startFrom24Btn = UIButton.init(type: .system)
    let startFrom14Btn = UIButton.init(type: .system)
    
    // 當 ShotClock lastedTime > GameClock lastedTime 時顯示在畫面上
    var invalidShotClockLbl: UILabel!
    
    override init(frame: CGRect, countdownFromShouldBeLoad: TimeInterval) {
        super.init(frame: frame, countdownFromShouldBeLoad: countdownFromShouldBeLoad)
        startFrom24Btn.frame = CGRect.init(x: (self.frame.width/1.5)+57, y: (self.frame.height/3)+20, width: 40, height: 40)
        startFrom24Btn.backgroundColor = UIColor.red
        subtractClockTimeBtn.frame = CGRect.init(x: (self.frame.width/4)-10, y: (self.frame.height/3)+20, width: 40, height: 40)
        subtractClockTimeBtn.backgroundColor = UIColor.red
        lastedTimeLbl.frame = CGRect.init(x: (self.frame.width/4)-1,y: self.frame.height/3, width: self.frame.width/2, height: self.frame.height/1.5)
        lastedTimeLbl.font = UIFont.systemFont(ofSize: 60)
        lastedTimeLbl.adjustsFontSizeToFitWidth = true
//        lastedTimeLbl.adjustsFontForContentSizeCategory = true
//        lastedTimeLbl.backgroundColor = UIColor.red
        startPauseResumeClockBtn.frame = CGRect.init(x: self.frame.width/4, y: self.frame.height/3, width: self.frame.width/2, height: self.frame.height/1.5)
        addClockTimeBtn.frame = CGRect.init(x: self.frame.width/1.5, y: (self.frame.height/3)+20, width: 40, height: 40)
        addClockTimeBtn.backgroundColor = UIColor.red
        startFrom14Btn.frame = CGRect.init(x: self.frame.width/11, y: (self.frame.height/3)+20, width: 40, height: 40)
        startFrom14Btn.backgroundColor = UIColor.red
        
        
        
        startFrom24Btn.addTarget(self, action: #selector(resetTheClock), for: .touchUpInside)
        startFrom24Btn.setTitle("24", for: .normal)
        startFrom24Btn.titleLabel?.textAlignment = .center
        
        startFrom14Btn.addTarget(self, action: #selector(startFrom14BtnPressed), for: .touchUpInside)
        startFrom14Btn.setTitle("14", for: .normal)
        startFrom14Btn.titleLabel?.textAlignment = .center
        
        invalidShotClockLbl = UILabel.init(frame: lastedTimeLbl.frame)
        invalidShotClockLbl.text = "24"
        invalidShotClockLbl.textAlignment = .center
        
        
        
        self.addSubview(startFrom24Btn)
        self.addSubview(startFrom14Btn)
        startFrom24Btn.isEnabled = false
        startFrom14Btn.isEnabled = false
        
        
        // 將 invalidShotClockLbl 暫時隱藏, 等需要的時候從 GC 呼叫
        self.insertSubview(invalidShotClockLbl, aboveSubview: startPauseResumeClockBtn)
        invalidShotClockLbl.isHidden = true
        

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func startCountdown() {
        super.startCountdown()
        startFrom24Btn.isEnabled = true
        startFrom14Btn.isEnabled = true
    }
    
    override func pauseResume() {
        if isResumeTapped {// Run resume
            timeEndAt = NSDate.init(timeIntervalSinceNow: lastedTime)
            runTimer()
            isResumeTapped = false
            addClockTimeBtn.isEnabled = true
            subtractClockTimeBtn.isEnabled = true
            startFrom24Btn.isEnabled = true
            startFrom14Btn.isEnabled = true
        } else {// Run pause
            timer.invalidate()
            isResumeTapped = true
        }
    }
    
    
    func startFrom14BtnPressed() {
        lastedTime = 14.1// updateTimer() 跑完大概還要多 0.1 秒
        timeEndAt = NSDate.init(timeIntervalSinceNow: lastedTime)
        updateTimer()
    }
    
    override func timeString(time: TimeInterval) -> String {
        let seconds = Int(time) % 60
        let decasecond = Int(time * 10) % 10
        
        return String.init(format: "%02i.%i", seconds, decasecond)
    }
    
    override func resetTheClock() {
        super.resetTheClock()
        startFrom24Btn.isEnabled = false
        startFrom14Btn.isEnabled = false
    }
    
    override func timeUp() {
        super.timeUp()
        invalidShotClockLbl.isHidden = true
    }
    
    // 顯示假的 shotClock
    func showInvalidShotClockLbl() {
        invalidShotClockLbl.isHidden = false
    }

}
