//
//  UIViewEXtension.swift
//  CNanNavigationBar_Example
//
//  Created by cn on 2019/9/23.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

extension UIView {
    public var left: CGFloat {
        get {
            return frame.origin.x
        }
        set(left) {
            var f = frame
            f.origin.x = left
            frame = f
        }
    }
    
    public var top: CGFloat {
        get {
            return frame.origin.y
        }
        set(top) {
            var f = frame
            f.origin.y = top
            frame = f
        }
    }
    
    public var right: CGFloat {
        get {
            return frame.origin.x+frame.size.width
        }
        set(right) {
            var f = frame
            f.origin.x = right-f.size.width
            frame = f
        }
    }
    
    public var bottom: CGFloat {
        get {
            return frame.origin.y+frame.size.height
        }
        set(bottom) {
            var f = frame
            f.origin.x = bottom-f.size.height
            frame = f
        }
    }
    
    public var width: CGFloat {
        get {
            return frame.size.width
        }
        set(width) {
            var f = frame
            f.size.width = width
            frame = f
        }
    }
    
    public var height: CGFloat {
        get {
            return frame.size.height
        }
        set(height) {
            var f = frame
            f.size.height = height
            frame = f
        }
    }
    
    public var centerX: CGFloat {
        get {
            return center.x
        }
        set(centerX) {
            var c = center
            c.x = centerX
            center = c
        }
    }
    
    public var centerY: CGFloat {
        get {
            return center.y
        }
        set(centerY) {
            var c = center
            c.y = centerY
            center = c
        }
    }
    
    public var origin: CGPoint {
        get {
            return frame.origin
        }
        set(origin) {
            var f = frame
            f.origin = origin
            frame = f
        }
    }
    
    public var size: CGSize {
        get {
            return frame.size
        }
        set(size) {
            var f = frame
            f.size = size
            frame = f
        }
    }
}
