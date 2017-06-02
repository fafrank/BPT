//
//  TeamStats.swift
//  BasketballBook
//
//  Created by 邱柏盛 on 2017/5/1.
//  Copyright © 2017年 BB. All rights reserved.
//

import UIKit

// Singleton
class BoxScoreSingleton: NSObject {
    
    static let standard = BoxScoreSingleton()
    
    var rules: Rules! = nil
    
    // 處理節數的部分
    // 當前節數
    dynamic var quarterNow: Int = 0
    // 當前節數的字串
    var quarterString = [String]()
    
    func quarterNowString() -> String{
        return quarterString[quarterNow]
    }
    
// ---------------------------------------------------------------------
    // ***** 在 ScoringTableVC 中的 viewDidLoad 中 load 球隊時要一起宣告
    var guestId: String = ""
    var homeId: String = ""
// ---------------------------------------------------------------------
    
    dynamic var guestScore: Int = 0
    dynamic var guestFouls = [String:Int]()
    
    dynamic var homeScore: Int = 0
    dynamic var homeFouls = [String:Int]()
    
    dynamic var isRestClockHidden: Bool = true
    
    
    
    
    private override init() {
        super.init()
    }
}
