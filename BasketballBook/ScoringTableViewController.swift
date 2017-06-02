//
//  ViewController.swift
//  BasketballBook
//
//  Created by 邱柏盛 on 2017/4/27.
//  Copyright © 2017年 BB. All rights reserved.
//

import UIKit
import SwiftyButton

class ScoringTableViewController: UIViewController {
    
    var rules: Rules!
    var gameClock: GameClockView!    
    
    let boxScoreSingleton = BoxScoreSingleton.standard
    
    
    @IBOutlet weak var tacticalBoard: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rules = boxScoreSingleton.rules
        
        // 設定 GC 的位置 顏色 -> 初始化 -> 加到畫面
        gameClock = GameClockView.init(frame: CGRect.init(x: 0, y: 20, width: view.frame.size.width, height: view.frame.size.height/2), countdownFromShouldBeLoad: rules.secondsPerQ)
        gameClock.backgroundColor = UIColor(red: 0/255, green: 169/255, blue: 255/255, alpha: 1)
//        gameClock.layout2()
        self.view.addSubview(gameClock)
        
        
        // 依據規則設定 Label 內的文字
        gameClock.periodLbl.text = "Ready to Start"
        //text換行
        gameClock.periodLbl.lineBreakMode = NSLineBreakMode.byWordWrapping
        gameClock.periodLbl.numberOfLines = 0
        gameClock.homeScoreLbl.text = "0"
        gameClock.homeAccumulatedFoulsThisQtrLbl.text = "0"
        gameClock.guestScoreLbl.text = "0"
        gameClock.guestAccumulatedFoulsThisQtrLbl.text = "0"
        
        //botton UI
        gameClock.timeoutRequestFromHomeBtn.color = .white
        gameClock.timeoutRequestFromHomeBtn.highlightedColor = .clear
        gameClock.timeoutRequestFromHomeBtn.cornerRadius  = 5
        
        gameClock.timeoutRequestFromGuestBtn.color = .white
        gameClock.timeoutRequestFromGuestBtn.highlightedColor = .clear
        gameClock.timeoutRequestFromGuestBtn.cornerRadius  = 5
        
        
        // 註冊 Observer 
        // 觀察 quarterNow 的變化
        boxScoreSingleton.addObserver(self, forKeyPath: "quarterNow", options: .new, context: nil)        
        boxScoreSingleton.addObserver(self, forKeyPath: "guestScore", options: .new, context: nil)
        boxScoreSingleton.addObserver(self, forKeyPath: "guestFouls", options: .new, context: nil)
        boxScoreSingleton.addObserver(self, forKeyPath: "homeScore", options: .new, context: nil)
        boxScoreSingleton.addObserver(self, forKeyPath: "homeFouls", options: .new, context: nil)
        boxScoreSingleton.addObserver(self, forKeyPath: "isRestClockHidden", options: .new, context: nil)
        
        
        
    }
    
    // Observer
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        switch keyPath! {
        case "quarterNow":
            gameClock.periodLbl.text = boxScoreSingleton.quarterNowString()
            // 進入下半場時改變可用暫停數
            if boxScoreSingleton.quarterNow == rules.quarters + 1 {
                gameClock.timeoutRequestFromGuestBtn.setTitle(String(rules.timeoutsOfSecondHalf), for: .normal)
                gameClock.timeoutRequestFromHomeBtn.setTitle(String(rules.timeoutsOfSecondHalf), for: .normal)
            }
            // 進入延長賽時改變可用暫停數
            if boxScoreSingleton.quarterNowString() == "OT1" || boxScoreSingleton.quarterNowString() == "OT2" || boxScoreSingleton.quarterNowString() == "OT3" {
                gameClock.timeoutRequestFromHomeBtn.setTitle(String(rules.timeoutsOfOT), for: .normal)
                gameClock.timeoutRequestFromGuestBtn.setTitle(String(rules.timeoutsOfOT), for: .normal)
            }
        case "guestScore":
            gameClock.guestScoreLbl.text = String(boxScoreSingleton.guestScore)
        case "guestFouls":
            gameClock.guestAccumulatedFoulsThisQtrLbl.text = String(describing: boxScoreSingleton.guestFouls[gameClock.periodLbl.text!])
        case "homeScore":
            gameClock.homeScoreLbl.text = String(boxScoreSingleton.homeScore)
        case "homeFouls":
            gameClock.homeAccumulatedFoulsThisQtrLbl.text = String(describing: boxScoreSingleton.homeFouls[gameClock.periodLbl.text!])
        case "isRestClockHidden":
            if boxScoreSingleton.isRestClockHidden {
                gameClock.timeoutRequestFromHomeBtn.isEnabled = true
                gameClock.timeoutRequestFromGuestBtn.isEnabled = true
            } else {
                gameClock.timeoutRequestFromHomeBtn.isEnabled = false
                gameClock.timeoutRequestFromGuestBtn.isEnabled = false
            }
            
            
        default:
            break
        }
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

