//
//  RandomFunction.swift
//  Bunny Run 4
//
//  Created by Garrett Bland on 1/17/16.
//  Copyright © 2016 Flat Circle Interactive. All rights reserved.
//

import Foundation
import CoreGraphics
import SpriteKit


//this file serves as instructions for generating random numbers. 

public extension CGFloat{
    
    public static func random() -> CGFloat {
        
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
        
        
        
    }
    
    public static func random(min min : CGFloat, max: CGFloat) -> CGFloat {
        
        return CGFloat.random() * (max - min) + min
        
        
        
    }
    
    
}

extension UIView {
    //screenshot extension. 
    
    
    func pb_takeSnapshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.mainScreen().scale)
        
        drawViewHierarchyInRect(self.bounds, afterScreenUpdates: true)
        
        // old style: layer.renderInContext(UIGraphicsGetCurrentContext())
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}