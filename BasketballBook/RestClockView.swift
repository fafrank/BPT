//
//  RestClock.swift
//  BasketballBook
//
//  Created by 邱柏盛 on 2017/5/15.
//  Copyright © 2017年 BB. All rights reserved.
//

import UIKit

class RestClockView: ClockView {
    let boxScoreSingleton = BoxScoreSingleton.standard
    
    override init(frame: CGRect, countdownFromShouldBeLoad: TimeInterval) {
        super.init(frame: frame, countdownFromShouldBeLoad: countdownFromShouldBeLoad)
        lastedTimeLbl.frame = CGRect.init(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        boxScoreSingleton.isRestClockHidden = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func timeUp() {
        // 時間到時隱藏整個 restClock
        self.isHidden = true
        boxScoreSingleton.isRestClockHidden = true
    }
}
