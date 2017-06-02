//
//  UITextFieldExtendedViewFloat.swift
//  TextFieldExtensions
//
//  Created by Russell Morgan on 19/01/2017.
//  Copyright © 2017 Carter Miller. All rights reserved.
//


import UIKit
import QuartzCore


extension UITextFieldExtendedView
{
    // MARK:- Properties
    override var accessibilityLabel:String! {
        get {
            if text!.isEmpty {
                return title.text
            } else {
                return text
            }
        }
        set {
            self.accessibilityLabel = newValue
        }
    }
    
    override var placeholder:String? {
        didSet {
            title.text = placeholder
            title.sizeToFit()
        }
    }
    
    override var attributedPlaceholder:NSAttributedString? {
        didSet {
            title.text = attributedPlaceholder?.string
            title.sizeToFit()
        }
    }

    
    // MARK:- Overrides
    override func layoutSubviews()
    {
        super.layoutSubviews()
        setTitlePositionForTextAlignment()
        let isResp = isFirstResponder
        if isResp && !text!.isEmpty {
            title.textColor = titleActiveTextColour
        } else {
            title.textColor = titleTextColour
        }
        // Should we show or hide the title label?
        if text!.isEmpty {
            // Hide
            hideTitle(animated: isResp)
        } else {
            // Show
            showTitle(animated: isResp)
        }
    }
    
    override func textRect(forBounds bounds:CGRect) -> CGRect
    {
        var r = super.textRect(forBounds: bounds)
        if shouldDisplayLabel
        {
            if !text!.isEmpty {
                var top = ceil(title.font.lineHeight + hintYPadding)
                top = min(top, maxTopInset())
                r = UIEdgeInsetsInsetRect(r, UIEdgeInsetsMake(top, 0.0, 0.0, 0.0))
            }
        }
        return r.integral
    }
    
    override func editingRect(forBounds bounds:CGRect) -> CGRect
    {
        var r = super.editingRect(forBounds: bounds)
        if shouldDisplayLabel
        {
            if !text!.isEmpty {
                var top = ceil(title.font.lineHeight + hintYPadding)
                top = min(top, maxTopInset())
                r = UIEdgeInsetsInsetRect(r, UIEdgeInsetsMake(top, 0.0, 0.0, 0.0))
            }
        }
        return r.integral
    }
    
    override func clearButtonRect(forBounds bounds:CGRect) -> CGRect
    {
        var r = super.clearButtonRect(forBounds: bounds)
        if shouldDisplayLabel
        {
            if !text!.isEmpty {
                var top = ceil(title.font.lineHeight + hintYPadding)
                top = min(top, maxTopInset())
                r = CGRect(x:r.origin.x, y:r.origin.y + (top * 0.5), width:r.size.width, height:r.size.height)
            }
        }
        return r.integral
    }
    
    
    
    func setup() {
        borderStyle = UITextBorderStyle.roundedRect//none
        
        titleActiveTextColour = tintColor
        // Set up title label
        title.alpha = 0.0
        title.font = titleFont
        title.textColor = titleTextColour
        if let str = placeholder {
            if !str.isEmpty {
                title.text = str
                title.sizeToFit()
            }
        }
        self.addSubview(title)
    }

    private func maxTopInset()->CGFloat {
        return max(0, floor(bounds.size.height - font!.lineHeight - 4.0))
    }
    
    private func setTitlePositionForTextAlignment()
    {
        if shouldDisplayLabel
        {
            let r = textRect(forBounds: bounds)
            var x = r.origin.x
            if textAlignment == NSTextAlignment.center {
                x = r.origin.x + (r.size.width * 0.5) - title.frame.size.width
            } else if textAlignment == NSTextAlignment.right {
                x = r.origin.x + r.size.width - title.frame.size.width
            }
            title.frame = CGRect(x:x, y:title.frame.origin.y, width:title.frame.size.width, height:title.frame.size.height)
        }
        else
        {
            title.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        }
    }
    
    private func showTitle(animated:Bool)
    {
        if shouldDisplayLabel == false
        {
            return
        }

        let dur = animated ? animationDuration : 0
        UIView.animate(withDuration: dur, delay:0, options: UIViewAnimationOptions.curveEaseOut, animations:{
            // Animation
            self.title.alpha = 1.0
            var r = self.title.frame
            r.origin.y = self.titleYPadding
            self.title.frame = r
        }, completion:nil)
    }
    
    private func hideTitle(animated:Bool)
    {
        if shouldDisplayLabel == false
        {
            return
        }

        let dur = animated ? animationDuration : 0
        UIView.animate(withDuration: dur, delay:0, options: UIViewAnimationOptions.curveEaseIn, animations:{
            // Animation
            self.title.alpha = 0.0
            var r = self.title.frame
            r.origin.y = self.title.font.lineHeight + self.hintYPadding
            self.title.frame = r
        }, completion:nil)
    }
    
    
    
    
}
