//
//  UINavigationBarExtension.swift
//  navgationBar
//
//  Created by cn on 2019/5/9.
//  Copyright © 2019 cn. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationBar {
    
    public static var shadowColor: UIColor {
        return UIColor.lightGray.withAlphaComponent(0.6)
    }
    public static var blackColor: UIColor {
        return UIColor.black.withAlphaComponent(0.85)
    }
    public static var defaultColor: UIColor {
        return UIColor.white.withAlphaComponent(0.85)
    }

    // TODO: ----- swizzling -----
    internal class func swiftInitialize() {
        CNSwizzlingManager.swizzlingForClass(forClass: UINavigationBar.classForCoder(), originalSelector: #selector(layoutSubviews), swizzledSelector: #selector(cn_layoutSubviews))
    }
    @objc private func cn_layoutSubviews() {
        cn_layoutSubviews()
        setBackgroundImage(UIImage.init(), for: UIBarMetrics.default)
        shadowImage = UIImage.init()
        if subviews.count != 0 {
            let barBounds: CGRect = subviews.first!.bounds
            cn_visualEffecView.frame = barBounds
            cn_shadowView.frame = CGRect(x: 0, y: barBounds.size.height-0.5, width: barBounds.size.width, height: 0.5)            
        }
    }
    
    // TODO: ----- property -----
    internal var cn_isHidden: Bool {
        get {return objc_getAssociatedObject(self, &navigationBarKey.isHiddenKey) as? Bool ?? false}
        set {
            objc_setAssociatedObject(self, &navigationBarKey.isHiddenKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
            cn_visualEffecView.isHidden = newValue
            cn_shadowView.isHidden = newValue
        }
    }
    internal var hitTestBack: ((_ point: CGPoint) -> UIView?)? {
        get {return objc_getAssociatedObject(self, &navigationBarKey.hitTestBack) as? (CGPoint) -> UIView?}
        set {objc_setAssociatedObject(self, &navigationBarKey.hitTestBack, newValue, .OBJC_ASSOCIATION_COPY)}
    }
    
    // TODO: ----- UI -----
    internal var cn_visualEffecView: UIVisualEffectView {
        get {
            var any = objc_getAssociatedObject(self, &navigationBarKey.visualEffecViewKey) as? UIVisualEffectView
            if any == nil {
                any = UIVisualEffectView.init(effect: UIBlurEffect(style: UIBlurEffect.Style.extraLight))
                any!.subviews.last?.backgroundColor = UINavigationBar.defaultColor
                // resizeAspect resizeAspectFill resize
                any!.subviews.last?.layer.contentsGravity = CALayerContentsGravity.init(rawValue: "resizeAspectFill")
                any!.subviews.last?.layer.masksToBounds = true
                objc_setAssociatedObject(self, &navigationBarKey.visualEffecViewKey, any, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            subviews.first?.insertSubview(any!, at: 0)
            return any!
        }
        set {
            objc_setAssociatedObject(self, &navigationBarKey.visualEffecViewKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    internal var cn_shadowView: UIView {
        get {
            var any = objc_getAssociatedObject(self, &navigationBarKey.shadowViewKey) as? UIView
            if any == nil {
                any = UIView.init()
                any!.backgroundColor = UINavigationBar.shadowColor
                objc_setAssociatedObject(self, &navigationBarKey.shadowViewKey, any, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            subviews.first?.insertSubview(any!, aboveSubview: cn_visualEffecView)
            return any!
        }
        set {
            objc_setAssociatedObject(self, &navigationBarKey.shadowViewKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // TODO: ----- other -----
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        var backView: UIView?
        if let hitTest = hitTestBack { backView = hitTest(convert(point, to: UIApplication.shared.keyWindow)) }
        if let view = backView { return view }
        guard let view = super.hitTest(point, with: event) else { return nil }
        
        if cn_visualEffecView.alpha==0.0 || cn_isHidden { // 导航透明壳穿透处理
            if #available(iOS 11.0, *) { // _UINavigationBarContentView
                return view.isKind(of: NSClassFromString("_UINavigationBarContentView")!) ? nil : view
            } else { // UINavigationBar
                return view.isKind(of: UINavigationBar.self) ? nil : view
            }
        }
        return view
    }
    private struct navigationBarKey {
        static var visualEffecViewKey = "cn_visualEffecView"
        static var shadowViewKey = "cn_shadowView"
        static var isHiddenKey = "cn_isHidden"
        static var hitTestBack = "cn_hitTestBack"
    }
}



extension UIApplication {
    public static let runOnce: Void = {
        UINavigationBar.swiftInitialize()
        UINavigationController.swiftInitialize()
        UIViewController.swiftInitialize()
    }()
}



internal class CNSwizzlingManager {
    static func swizzlingForClass(forClass: AnyClass, originalSelector: Selector, swizzledSelector: Selector) {
        let originalMethod = class_getInstanceMethod(forClass, originalSelector)
        let swizzledMethod = class_getInstanceMethod(forClass, swizzledSelector)
        guard originalMethod != nil || swizzledMethod != nil else { return }
        if class_addMethod(forClass, originalSelector, method_getImplementation(swizzledMethod!), method_getTypeEncoding(swizzledMethod!)) {
            class_replaceMethod(forClass, swizzledSelector, method_getImplementation(originalMethod!), method_getTypeEncoding(originalMethod!))
        } else {
            method_exchangeImplementations(originalMethod!, swizzledMethod!)
        }
    }
}
