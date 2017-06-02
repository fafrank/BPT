//
//  UITextFieldExtendedViewPopup.swift
//  TextFieldExtensions
//
//  Created by Russell Morgan on 19/01/2017.
//  Copyright © 2017 Carter Miller. All rights reserved.
//


import UIKit
import QuartzCore


extension UITextFieldExtendedView : UIPickerViewDelegate, UIPickerViewDataSource
{
        
    // setup
    func setupPopup(dataSet : [String])
    {
        self.dataSet = dataSet
        setupPopup()
    }
    func setupPopup(dataSet : [String], delegate : UITextFieldExtendedDelegate)
    {
        self.dataSet        = dataSet
        self.delegatePopup  = delegate
        setupPopup()
    }
    func setupPopup(dataSet : [String], controlTag: Int)
    {
        self.dataSet        = dataSet
        self.tag            = controlTag
        setupPopup()
    }
    func setupPopup(dataSet : [String], controlTag: Int, delegate : UITextFieldExtendedDelegate)
    {
        self.dataSet        = dataSet
        self.tag            = controlTag
        self.delegatePopup  = delegate
        setupPopup()
    }
    func setupPopup()
    {
        if numberOfLines < 1
        {
            numberOfLines = 1
        }
        
        if numberOfLines > 12
        {
            numberOfLines = 12
        }
        self.valueInit      = self.text!
    }
    
    
    // Popup
    func removePopup()
    {
        if !shouldDisplayPopup
        {
            return
        }
        
        if viewPopup != nil
        {
            viewPopup.removeFromSuperview()
        }
    }
    
    func displayPopup()
    {
        if !shouldDisplayPopup
        {
            return
        }
        
        if dataSetSelected != nil
        {
            return
        }
        
        // hide the keyboard
        // this is NOT an ideal situation, as the UIView now thinks this control
        // has finished editing, but it;s the only way I can find to hide the keyboard :-(
        _ = self.resignFirstResponder()
        
        
        
        // find the position on the main screen
        let globalPoint = self.superview?.convert(self.frame.origin, to: nil)
        
        let width   = self.frame.size.width
        let height  = self.frame.size.height * CGFloat(numberOfLines)
        
        var originX = globalPoint!.x//self.frame.origin.x
        var originY = globalPoint!.y + self.frame.height / 2 - height / 2  //self.frame.origin.y + self.frame.height / 2 - height / 2
   
        
        if originX < 0
        {
            originX = 10
        }
        if originX + width > UIScreen.main.bounds.width
        {
            originX = UIScreen.main.bounds.width - width
        }
        
        if originY < 0
        {
            originY = 10
        }
        if originY + height > UIScreen.main.bounds.height
        {
            originY = UIScreen.main.bounds.height - height
        }
        
        let frameRect = CGRect(x: originX, y: originY, width: width, height: height)
        
        //viewPopup = UIView(frame: frameRect)
        viewPopup = UIViewPopup(frame: frameRect)
        viewPopup.backgroundColor = UIColor.clear
        
        let viewDisplay = UIView(frame: viewPopup.bounds)
        viewDisplay.backgroundColor = UIColor(white: 1, alpha: 1)
        
        viewDisplay.layer.cornerRadius = 10.0
        viewDisplay.layer.borderColor = shadowColor.cgColor
        viewDisplay.layer.borderWidth = 0.5
        viewDisplay.clipsToBounds = true
        
        pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.selectRow(findIndexInitial(), inComponent: 0, animated: true)
        
        viewDisplay.addSubview(pickerView)

        
        if shouldDisplayGlow
        {
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
            blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = viewPopup.bounds
            viewPopup.addSubview(blurEffectView)
            
            let shadowFrame = CGRect(x: 0, y: 0, width: width, height: height)
            let shadowView = UIView(frame: shadowFrame)
            shadowView.layer.shadowColor = shadowColor.cgColor
            shadowView.layer.shadowOffset = CGSize.zero
            shadowView.layer.shadowOpacity = 1.0
            shadowView.layer.shadowRadius = shadowWidth

            viewPopup.addSubview(shadowView)
            shadowView.addSubview(viewDisplay)
            
            showShadow(shadowView)
        }
        else
        {
            viewPopup.addSubview(viewDisplay)
        }
        
     //   self.superview?.addSubview(viewPopup)
        
        // RM 29/04/17
        // add a little cross to close down the control
        let btnClose = UIButton(type: UIButtonType.custom)
        btnClose.setTitleColor(.gray, for: .normal)
        btnClose.setTitle("x", for: UIControlState.normal)
        //btnClose.setImage(UIImage(named: "cancel.png"), for: .normal) //provide image if required
        btnClose.frame = CGRect(x: width - 32, y: 0, width: 32, height: 32)
        
        btnClose.addTarget(self, action:#selector(cmdClose), for:.touchUpInside)
        viewPopup.addSubview(btnClose)
        

        
        UIApplication.shared.keyWindow?.addSubview(viewPopup)

    }
    
    func cmdClose()
    {
        self.removePopup()
    }

    func findIndexInitial() -> Int
    {
        for (index, val) in dataSet.enumerated()
        {
            if val == valueInit
            {
                return index
            }
        }
        return 0
        
    }
    
    // ANIMATION FOR POPUP
    func showShadow(_ view: UIView)
    {
        let animation = CABasicAnimation(keyPath: "shadowRadius")
        animation.duration  = self.animationDuration
        animation.fromValue = 0
        animation.toValue   = shadowWidth
        view.layer.add(animation, forKey: "shadowRadius")
    }
    
    // PickerView methods
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
    {
        let pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.black
        
        pickerLabel.text = dataSet[row]
        
        pickerLabel.font = self.font // self.control.font
        pickerLabel.textAlignment = NSTextAlignment.center
        return pickerLabel
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        self.text = dataSet[row]
        
        if delegatePopup != nil
        {
            delegatePopup!.popupPickerViewChanged!(valueReturn: dataSet[row], control: self, valueChanged: (dataSet[row] != valueInit))
        }
        
        valueInit = dataSet[row]
        self.removePopup()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return dataSet.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return dataSet[row]
    }
    
}
