//
//  UITextFieldExtendedView.swift
//
//  Created by Russell D Morgan on 13.01.17.
//  Copyright © 2017 Carter Miller. All rights reserved.
//


import UIKit
import QuartzCore


@objc protocol UITextFieldExtendedDelegate
{
    @objc optional func popupPickerViewChanged(valueReturn : String, control : UITextFieldExtendedView, valueChanged : Bool)
    @objc optional func multiPopupUpdated(valueReturn : [String], control : UITextFieldExtendedView, valueChanged : Bool)
}

@IBDesignable class UITextFieldExtendedView: UITextField
{
    // define text field type
    @IBInspectable var shouldDisplayPopup : Bool   = false
    @IBInspectable var shouldDisplayLabel : Bool   = false
    @IBInspectable var shouldDisplayGlow : Bool    = false
    

    var delegatePopup : UITextFieldExtendedDelegate?

    // general
    
    @IBInspectable var animationDuration : Double   = 0.2
    @IBInspectable var shadowColor : UIColor = UIColor.black
    //(red: 82.0 / 255.0, green: 168.0 / 255.0, blue: 236.0 / 255.0, alpha: 0.8)

    // floating label declarations
    
    let shadowWidth : CGFloat   = 15.0
    var title = UILabel()
    
    
    var titleFont:UIFont = UIFont.systemFont(ofSize: 12.0) {
        didSet {
            title.font = titleFont
            title.sizeToFit()
        }
    }
    
    @IBInspectable var hintYPadding:CGFloat = 0.0
    
    @IBInspectable var titleYPadding:CGFloat = 0.0 {
        didSet {
            var r = title.frame
            r.origin.y = titleYPadding
            title.frame = r
        }
    }
    
    @IBInspectable var titleTextColour:UIColor = UIColor.gray {
        didSet {
            if !isFirstResponder {
                title.textColor = titleTextColour
            }
        }
    }
    
    @IBInspectable var titleActiveTextColour:UIColor! {
        didSet {
            if isFirstResponder {
                title.textColor = titleActiveTextColour
            }
        }
    }
    
    
    

    // glowing border declarations
    
    
    // popup declarations
    var dataSet : [String]          = []
    var valueInit : String          = ""
    
    var pickerView : UIPickerView = UIPickerView()
    var blurEffectView: UIVisualEffectView!
    var viewPopup = UIView()
    
    @IBInspectable var numberOfLines            : Int       = 5
    
    // multiPopup
    var dataSetSelected : [String]?  // if this is nil, display a pickerView.  If defined (even if empty) display multiPopup
    var dataSetSelectedFlag : [Bool] = []
    var tableView: UITableView      = UITableView()
    var viewMultiPopup              = UIView()
    
    // MARK:- Init
    required init(coder aDecoder:NSCoder) {
        super.init(coder:aDecoder)!
        setup()
    }
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        setup()
    }

    
    // in use
    override open func becomeFirstResponder() -> Bool
    {
        let result : Bool = super.becomeFirstResponder()
        
        if result
        {
            // remove any popups that have already been displayed by other controls
            // and present the popup for self

            // remove them first
            UIApplication.shared.keyWindow?.addSubview(viewPopup)

            for subView in UIApplication.shared.keyWindow!.subviews
            {
                if let viewPopup = subView as? UIViewPopup
                {
                    viewPopup.removeFromSuperview()
                }
            }

            // and then add new popups
            for subView in self.superview!.subviews
            {
                if let control = subView as? UITextFieldExtendedView
                {
                    if control.tag == self.tag
                    {
                        if dataSetSelected == nil
                        {
                            control.displayPopup()
                        }
                        else
                        {
                            control.displayMultiPopup()
                        }
                    }
                }
            }

        }
        
        // if we should show glowing border, handle that
        if shouldDisplayGlow
        {
            // but not if there is a popup
            if shouldDisplayPopup == false
            {
                self.showBorder()
            }
        }
        
        return result
    }
    
    
    override func resignFirstResponder() -> Bool
    {
        let result : Bool = super.resignFirstResponder()
        
        if result
        {
            if shouldDisplayGlow
            {
                self.hideBorder()
            }
        }
        return result
    }


}

extension UIView
{
    func endEditingWithPopups(_ force: Bool)
    {
        // end editing for everything else on the view
        self.endEditing(true)
        
        // now take care of any TextFieldPopupView
        
        for subView in UIApplication.shared.keyWindow!.subviews //self.subviews
        {
            if let viewPopup = subView as? UIViewPopup
            {
                viewPopup.removeFromSuperview()
            }
        }
        

    }
    
}



