//
//  RulesViewController.swift
//  BasketballBook
//
//  Created by 邱柏盛 on 2017/4/28.
//  Copyright © 2017年 BB. All rights reserved.
//

import UIKit
import Foundation
import SwiftyButton

class RulesViewController: UIViewController, UITextFieldExtendedDelegate, UIScrollViewDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var animationView: UIView!
    @IBOutlet weak var inScrollView: UIView!
    @IBOutlet weak var containerScrollView: UIScrollView!
    // 設定規則用的 textfield, switch
    @IBOutlet weak var quartersShouldBeSet: UITextFieldExtendedView!// 2-4
    @IBOutlet weak var secondsPerQShouldBeSet: UITextFieldExtendedView!// 30
    @IBOutlet weak var secondsPerOTShouldBeSet: UITextFieldExtendedView!// 10
    @IBOutlet weak var secondsBtwQsShouldBeSet: UITextFieldExtendedView!// 10
    @IBOutlet weak var halfTimeShouldBeSet: UITextFieldExtendedView!// 20
    @IBOutlet weak var limitForFoulsOutShouldBeSet: UITextFieldExtendedView!// 10
    @IBOutlet weak var teamFoulForBonusShouldBeSet: UITextFieldExtendedView!// 10
    @IBOutlet weak var timeoutsOfFirstHalfShouldBeSet: UITextFieldExtendedView!// 10
    @IBOutlet weak var timeoutsOfSecondHalfShouldBeSet: UITextFieldExtendedView!// 10
    @IBOutlet weak var timeoutsOfOTShouldBeSet: UITextFieldExtendedView!// 10
    @IBOutlet weak var isShotClockExistShouldBeSet: RAMPaperSwitch!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var buttonTwo: FlatButton!
    @IBOutlet weak var buttonOne: FlatButton!
    @IBOutlet weak var stopTypeOfGameClockShouldBeSet: UITextFieldExtendedView!// stop
    
    // PickerView 用
    let twoOr4Array = [2, 4]
    let oneTo30Array = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30]
    let oneTo20Array = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]
    let oneTo10Array = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    let stopTypeOfGameClockArray = ["決勝節最後兩分鐘停錶", "任何時候都停錶", "任何時候都不停錶"]
    
    let quartersPickerView = UIPickerView()
    let secondsPerQPickerView = UIPickerView()
    let secondsPerOTPickerView = UIPickerView()
    let secondsBtwQsPickerView = UIPickerView()
    let halfTimePickerView = UIPickerView()
    let limitForFoulsOutPickerView = UIPickerView()
    let teamFoulForBonusPickerView = UIPickerView()
    let timeoutsOfFirstHalfPickerView = UIPickerView()
    let timeoutsOfSecondHalfPickerView = UIPickerView()
    let timeoutsOfOTPickerView = UIPickerView()
    let stopTypeOfGameClockPickerView = UIPickerView()
    
    // 鍵盤抬升畫面用
    let bottomPadding: CGFloat = 8.0
    let animationDuration = 0.3
    let scrollBackRange: CGFloat = 40
    
    var setCurrentOffsetY: Bool = false
    var currentOffsetY: CGFloat!
    var expectedOffsetY: CGFloat = 0
    var activeTextField: UITextField?


    
    override func viewDidLoad() {
        super.viewDidLoad()

        buttonOne.color = .blue
        buttonOne.highlightedColor = .white
        buttonOne.cornerRadius  = 5
        
        buttonTwo.color = .blue
        buttonTwo.highlightedColor = .white
        buttonTwo.cornerRadius  = 5
        
        //點擊光暈UI
        quartersShouldBeSet.shouldDisplayGlow = true
        secondsPerQShouldBeSet.shouldDisplayGlow = true
        secondsPerOTShouldBeSet.shouldDisplayGlow = true
        secondsBtwQsShouldBeSet.shouldDisplayGlow = true
        halfTimeShouldBeSet.shouldDisplayGlow = true
        limitForFoulsOutShouldBeSet.shouldDisplayGlow = true
        teamFoulForBonusShouldBeSet.shouldDisplayGlow = true
        timeoutsOfFirstHalfShouldBeSet.shouldDisplayGlow = true
        timeoutsOfSecondHalfShouldBeSet.shouldDisplayGlow = true
        timeoutsOfOTShouldBeSet.shouldDisplayGlow = true
        stopTypeOfGameClockShouldBeSet.shouldDisplayGlow = true
        
        quartersShouldBeSet.tag = 1
        secondsPerQShouldBeSet.tag = 2
        secondsPerOTShouldBeSet.tag = 3
        secondsBtwQsShouldBeSet.tag = 4
        halfTimeShouldBeSet.tag = 5
        limitForFoulsOutShouldBeSet.tag = 6
        teamFoulForBonusShouldBeSet.tag = 7
        timeoutsOfFirstHalfShouldBeSet.tag = 8
        timeoutsOfSecondHalfShouldBeSet.tag = 9
        timeoutsOfOTShouldBeSet.tag = 10
        stopTypeOfGameClockShouldBeSet.tag = 11
        
        
        // PickerView
        quartersPickerView.delegate = self
        quartersPickerView.tag = 1
        quartersPickerView.showsSelectionIndicator = true
        quartersShouldBeSet.inputView = quartersPickerView
        
        secondsPerQPickerView.delegate = self
        secondsPerQPickerView.tag = 2
        secondsPerQPickerView.showsSelectionIndicator = true
        secondsPerQShouldBeSet.inputView = secondsPerQPickerView
        
        secondsPerOTPickerView.delegate = self
        secondsPerOTPickerView.tag = 3
        secondsPerOTPickerView.showsSelectionIndicator = true
        secondsPerOTShouldBeSet.inputView = secondsPerOTPickerView
        
        secondsBtwQsPickerView.delegate = self
        secondsBtwQsPickerView.tag = 4
        secondsBtwQsPickerView.showsSelectionIndicator = true
        secondsBtwQsShouldBeSet.inputView = secondsBtwQsPickerView

        halfTimePickerView.delegate = self
        halfTimePickerView.tag = 5
        halfTimePickerView.showsSelectionIndicator = true
        halfTimeShouldBeSet.inputView = halfTimePickerView
        
        limitForFoulsOutPickerView.delegate = self
        limitForFoulsOutPickerView.tag = 6
        limitForFoulsOutPickerView.showsSelectionIndicator = true
        limitForFoulsOutShouldBeSet.inputView = limitForFoulsOutPickerView
        
        teamFoulForBonusPickerView.delegate = self
        teamFoulForBonusPickerView.tag = 7
        teamFoulForBonusPickerView.showsSelectionIndicator = true
        teamFoulForBonusShouldBeSet.inputView = teamFoulForBonusPickerView
        
        timeoutsOfFirstHalfPickerView.delegate = self
        timeoutsOfFirstHalfPickerView.tag = 8
        timeoutsOfFirstHalfPickerView.showsSelectionIndicator = true
        timeoutsOfFirstHalfShouldBeSet.inputView = timeoutsOfFirstHalfPickerView
        
        timeoutsOfSecondHalfPickerView.delegate = self
        timeoutsOfSecondHalfPickerView.tag = 9
        timeoutsOfSecondHalfPickerView.showsSelectionIndicator = true
        timeoutsOfSecondHalfShouldBeSet.inputView = timeoutsOfSecondHalfPickerView

        timeoutsOfOTPickerView.delegate = self
        timeoutsOfOTPickerView.tag = 10
        timeoutsOfOTPickerView.showsSelectionIndicator = true
        timeoutsOfOTShouldBeSet.inputView = timeoutsOfOTPickerView
        
        stopTypeOfGameClockPickerView.delegate = self
        stopTypeOfGameClockPickerView.tag = 11
        stopTypeOfGameClockPickerView.showsSelectionIndicator = true
        stopTypeOfGameClockShouldBeSet.inputView = stopTypeOfGameClockPickerView
        
        
        hideKeyboard()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
        
        self.isShotClockExistShouldBeSet.animationDidStartClosure = {(onAnimation: Bool) in
            UIView.transition(with: self.label, duration: self.isShotClockExistShouldBeSet.duration, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {
                self.label.textColor = onAnimation ? UIColor.black : UIColor.black
            },
                              completion:nil)
        }
        //抓動畫範圍大小
        self.isShotClockExistShouldBeSet.layoutSubviews()
    }
    
    // 跳轉倒下一頁
    @IBAction func confirmRules(_ sender: UIButton) {
        let contentOfstopTypeOfGameClockShouldBeSet: StopTypeOfGameClock
        
        if stopTypeOfGameClockShouldBeSet.text == stopTypeOfGameClockArray[0] {
            contentOfstopTypeOfGameClockShouldBeSet = .last2MinsInClutchQuarter
        } else if stopTypeOfGameClockShouldBeSet.text == stopTypeOfGameClockArray[1] {
            contentOfstopTypeOfGameClockShouldBeSet = .anytime
        } else {
            contentOfstopTypeOfGameClockShouldBeSet = .doNotStop
        }
        
        // 利用 sigleton 送出設定好的規則
        let rulesShouldBeSet = Rules.init(quartersShouldBeLoad: Int(self.quartersShouldBeSet.text!)!, secondsPerQShouldBeLoad: TimeInterval(Double(self.secondsPerQShouldBeSet.text!)! * 60), secondsPerOTShouldBeLoad: TimeInterval(Double(self.secondsPerOTShouldBeSet.text!)! * 60), secondsBtwQsShouldBeLoad: TimeInterval(Double(self.secondsBtwQsShouldBeSet.text!)! * 60), halfTimeShouldBeLoad: TimeInterval(Double(self.halfTimeShouldBeSet.text!)! * 60), limitForFoulsOutShouldBeLoad: Int(self.limitForFoulsOutShouldBeSet.text!)!, teamFoulsForBonusShouldBeLoad: Int(self.teamFoulForBonusShouldBeSet.text!)!, timeoutsOfFirstHalfShouldBeLoad: Int(self.timeoutsOfFirstHalfShouldBeSet.text!)!, timeoutsOfSecondHalfShouldBeLoad: Int(self.timeoutsOfSecondHalfShouldBeSet.text!)!, timeoutsOfOTShouldBeLoad: Int(self.timeoutsOfOTShouldBeSet.text!)!, isShotClockExistShouldBeLoad: isShotClockExistShouldBeSet.isOn, stopTypeOfGameClockShouldBeLoad: contentOfstopTypeOfGameClockShouldBeSet)
        
        let boxScoreSingleton = BoxScoreSingleton.standard
        boxScoreSingleton.rules = rulesShouldBeSet
        
        self.performSegue(withIdentifier: "goToScoringTable", sender: nil)
    }
    
    @IBAction func confirmWithFIBARules(_ sender: UIButton) {
        let boxScoreSingleton = BoxScoreSingleton.standard
        boxScoreSingleton.rules = Rules.init()
        
        self.performSegue(withIdentifier: "goToScoringTable", sender: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func keyboardWasShown(notification: Notification) {
        
        guard let keyboardHeight = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.height else {
            return
        }
        let display = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - keyboardHeight)
        
        if(!setCurrentOffsetY) {
            currentOffsetY = containerScrollView.contentOffset.y
        }
        setCurrentOffsetY = true
        containerScrollView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        containerScrollView.scrollIndicatorInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        
        let origin: CGPoint
        let bottom: CGPoint
        
        origin = (activeTextField?.superview?.convert((activeTextField?.frame.origin)!, to: nil))!
        bottom = CGPoint.init(x: origin.x, y: (origin.y + (activeTextField?.frame.size.height)! + bottomPadding))
        
        
        if(!display.contains(bottom)) {
            self.view.frame.origin.y -= keyboardHeight / 2
        }
        
    }
    
    func keyboardWillHide(notification: Notification) {
        print("SavedOffsetY: %.01f", currentOffsetY)
        print("CurrentOffsetY: %.01f", self.containerScrollView.contentOffset.y)
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y += keyboardSize.height/2
            }
        }

    }
    
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        self.view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        
        // PickerView 從預設的 row 開始選起
        switch textField.tag {
        case 1:
            quartersPickerView.selectRow(1, inComponent: 0, animated: true)
        case 2:
           secondsPerQPickerView.selectRow(9, inComponent: 0, animated: true)
        case 3:
            secondsPerOTPickerView.selectRow(4, inComponent: 0, animated: true)
        case 4:
            secondsBtwQsPickerView.selectRow(1, inComponent: 0, animated: true)
        case 5:
            halfTimePickerView.selectRow(14, inComponent: 0, animated: true)
        case 6:
            limitForFoulsOutPickerView.selectRow(4, inComponent: 0, animated: true)
        case 7:
            teamFoulForBonusPickerView.selectRow(4, inComponent: 0, animated: true)
        case 8:
            timeoutsOfFirstHalfPickerView.selectRow(1, inComponent: 0, animated: true)
        case 9:
            timeoutsOfSecondHalfPickerView.selectRow(2, inComponent: 0, animated: true)
        case 10:
            timeoutsOfOTPickerView.selectRow(0, inComponent: 0, animated: true)
        case 11:
            stopTypeOfGameClockPickerView.selectRow(0, inComponent: 0, animated: true)
        default:
            return
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = nil
    }
    
    // MARK: UIPickerViewDelegate & UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch pickerView.tag {
        case 1:
            return twoOr4Array.count
        case 2:
            return oneTo30Array.count
        case 3:
            return oneTo10Array.count
        case 4:
            return oneTo10Array.count
        case 5:
            return oneTo20Array.count
        case 6:
            return oneTo10Array.count
        case 7:
            return oneTo10Array.count
        case 8:
            return oneTo10Array.count
        case 9:
            return oneTo10Array.count
        case 10:
            return oneTo10Array.count
        case 11:
            return stopTypeOfGameClockArray.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch pickerView.tag {
        case 1:
            return String(twoOr4Array[row])
        case 2:
            return String(oneTo30Array[row])
        case 3:
            return String(oneTo10Array[row])
        case 4:
            return String(oneTo10Array[row])
        case 5:
            return String(oneTo20Array[row])
        case 6:
            return String(oneTo10Array[row])
        case 7:
            return String(oneTo10Array[row])
        case 8:
            return String(oneTo10Array[row])
        case 9:
            return String(oneTo10Array[row])
        case 10:
            return String(oneTo10Array[row])
        case 11:
            return stopTypeOfGameClockArray[row]
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch pickerView.tag {
        case 1:
            quartersShouldBeSet.text = String(twoOr4Array[row])
            self.view.endEditing(true)
        case 2:
            secondsPerQShouldBeSet.text = String(oneTo30Array[row])
            self.view.endEditing(true)
        case 3:
            secondsPerOTShouldBeSet.text = String(oneTo10Array[row])
            self.view.endEditing(true)
        case 4:
            secondsBtwQsShouldBeSet.text = String(oneTo10Array[row])
            self.view.endEditing(true)
        case 5:
            halfTimeShouldBeSet.text = String(oneTo20Array[row])
            self.view.endEditing(true)
        case 6:
            limitForFoulsOutShouldBeSet.text = String(oneTo10Array[row])
            self.view.endEditing(true)
        case 7:
            teamFoulForBonusShouldBeSet.text = String(oneTo10Array[row])
            self.view.endEditing(true)
        case 8:
            timeoutsOfFirstHalfShouldBeSet.text = String(oneTo10Array[row])
            self.view.endEditing(true)
        case 9:
            timeoutsOfSecondHalfShouldBeSet.text = String(oneTo10Array[row])
            self.view.endEditing(true)
        case 10:
            timeoutsOfOTShouldBeSet.text = String(oneTo10Array[row])
            self.view.endEditing(true)
        case 11:
            stopTypeOfGameClockShouldBeSet.text = stopTypeOfGameClockArray[row]
            self.view.endEditing(true)
        default:
            return
        }
    }
    
}


