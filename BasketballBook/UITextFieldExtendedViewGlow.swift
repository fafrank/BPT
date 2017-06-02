//
//  UITextFieldExtendedViewGlow.swift
//  TextFieldExtensions
//
//  Created by Russell Morgan on 19/01/2017.
//  Copyright © 2017 Carter Miller. All rights reserved.
//


import UIKit
import QuartzCore


extension UITextFieldExtendedView
{
    func showBorder()
    {
        if shouldDisplayGlow == false
        {
            return
        }
        if shouldDisplayPopup == true
        {
            return
        }

        
        if self.backgroundColor == nil
        {
            self.backgroundColor = UIColor.white
        }
        if self.layer.shadowColor == nil
        {
            self.layer.shadowColor = UIColor.white.cgColor
        }
        
        self.clipsToBounds = true
        
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 4.0
        self.layer.shadowColor = self.shadowColor.cgColor
        self.layer.shadowPath =  UIBezierPath(roundedRect: self.layer.bounds, byRoundingCorners: UIRectCorner.allCorners, cornerRadii: CGSize(width: 4, height: 4)).cgPath
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = self.shadowWidth
        
        animateBorderColorFrom(fromColor: self.backgroundColor!, toColor: UIColor(cgColor: self.layer.shadowColor!), fromOpacity: 0.0, toOpacity: 1.0)
    }
    
    func hideBorder()
    {
        if shouldDisplayGlow == false
        {
            return
        }
        if shouldDisplayPopup == true
        {
            return
        }
        if self.backgroundColor == nil
        {
            self.backgroundColor = UIColor.white
        }
        if self.layer.shadowColor == nil
        {
            self.layer.shadowColor = UIColor.white.cgColor
        }

        animateBorderColorFrom(fromColor: UIColor(cgColor: self.layer.shadowColor!), toColor: self.backgroundColor!, fromOpacity: 1.0, toOpacity: 0.0)
    }
    
    func animateBorderColorFrom(fromColor : UIColor, toColor : UIColor, fromOpacity : CGFloat, toOpacity : CGFloat)
    {
        let borderColorAnimation = CABasicAnimation(keyPath: "borderColor")
        
        borderColorAnimation.fromValue = fromColor
        borderColorAnimation.toValue = toColor
        
        let shadowOpacityAnimation = CABasicAnimation(keyPath: "shadowOpacity")
        shadowOpacityAnimation.fromValue = fromOpacity
        shadowOpacityAnimation.toValue = toOpacity
        
        let group = CAAnimationGroup()
        group.duration = animationDuration
        group.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        group.isRemovedOnCompletion = false
        group.fillMode = kCAFillModeForwards
        group.animations = [borderColorAnimation, shadowOpacityAnimation]
        
        self.layer.add(group, forKey: nil)
    }

}
