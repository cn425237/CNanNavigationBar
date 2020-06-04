//
//  UINavigationControllerExtension.swift
//  navgationBar.swift
//
//  Created by cn on 2019/6/14.
//  Copyright © 2019 cn. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController: UINavigationControllerDelegate, UINavigationBarDelegate, UIGestureRecognizerDelegate {
    
    // TODO: ----- swizzling -----
    internal override class func swiftInitialize() {
        CNSwizzlingManager.swizzlingForClass(forClass: UINavigationController.classForCoder(), originalSelector: #selector(self.init(rootViewController:)), swizzledSelector: #selector(self.cn_init(rootViewController:)))
        CNSwizzlingManager.swizzlingForClass(forClass: UINavigationController.classForCoder(), originalSelector: #selector(pushViewController(_:animated:)), swizzledSelector: #selector(cn_pushViewController(_:animated:)))
        CNSwizzlingManager.swizzlingForClass(forClass: UINavigationController.classForCoder(), originalSelector: #selector(popViewController(animated:)), swizzledSelector: #selector(cn_popViewController(animated:)))
    }
    @objc private func cn_init(rootViewController: UIViewController) -> UINavigationController {
        let nav = self.cn_init(rootViewController: rootViewController)
        nav.delegate = self
        nav.interactivePopGestureRecognizer?.delegate = self
        nav.interactivePopGestureRecognizer?.addTarget(self, action: #selector(self.handlePopGesture(recognizer:)))
        return nav
    }
    @objc private func cn_pushViewController(_ viewController: UIViewController, animated: Bool) {
        self.cn_pushViewController(viewController, animated: animated)
        self.navigationBar.titleTextAttributes = self.topViewController?.cn_titleTextAttributes
    }
    @objc private func cn_popViewController(animated: Bool) -> UIViewController? {
        let controller = self.cn_popViewController(animated: animated)
        switch transitionCoordinator?.isInteractive {
        case true:
            transitionCoordinator?.animate(alongsideTransition: { (context: UIViewControllerTransitionCoordinatorContext) in
                self.navigationBar.titleTextAttributes = self.topViewController?.cn_titleTextAttributes
            }, completion: nil)
        case false:
            self.navigationBar.titleTextAttributes = self.topViewController?.cn_titleTextAttributes
        default:
            break
        }
        return controller
    }
    
    // TODO: ----- UIGestureRecognizerDelegate -----
    @objc private func handlePopGesture(recognizer: UIScreenEdgePanGestureRecognizer) {
        guard transitionCoordinator != nil else {
            return
        }
        let from: UIViewController = (transitionCoordinator?.viewController(forKey: UITransitionContextViewControllerKey.from))!
        let to: UIViewController = (transitionCoordinator?.viewController(forKey: UITransitionContextViewControllerKey.to))!
        switch recognizer.state {
        case .began, .changed:
            guard from.cn_tintColor != to.cn_tintColor else {
                return
            }
            navigationBar.tintColor = blendColor(from.cn_tintColor, to.cn_tintColor, Float(transitionCoordinator!.percentComplete))
        default:
            break
        }
    }
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if viewControllers.count>1 {
            if topViewController!.cn_backInteractive {
                return topViewController?.shouldPopOnBackButtonPress ?? true
            } else {
                return topViewController!.cn_backInteractive
            }
        }
        return false
    }
    
    // TODO: ----- UINavigationControllerDelegate -----
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        UIViewController.updateNavigationBar(transitionCoordinator, navigationController.navigationBar, viewController)
    }
    public func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
        if viewControllers.count==navigationBar.items?.count {
            let shouldPop = topViewController?.shouldPopOnBackButtonPress ?? true
            if shouldPop {if #available(iOS 13.0, *) {} else {popViewController(animated: true)}}
            return shouldPop
        } else {
            return true
        }
    }
    
    // TODO: ----- other -----
    public func pushViewController(viewController vc: UIViewController, animated: Bool, hidesBottomBarWhenPushed isHide: Bool = false) {
        vc.hidesBottomBarWhenPushed = isHide
        pushViewController(vc, animated: animated)
    }
    override open var childForStatusBarStyle: UIViewController? {
        return self.topViewController
    }
}

public func blendColor(_ fromColor: UIColor?, _ toColor: UIColor?, _ percent: Float) -> UIColor {
    var fromRed: CGFloat = 0.0
    var fromGreen: CGFloat = 0.0
    var fromBlue: CGFloat = 0.0
    var fromAlpha: CGFloat = 0.0
    fromColor?.getRed(&fromRed, green: &fromGreen, blue: &fromBlue, alpha: &fromAlpha)
    
    var toRed: CGFloat = 0.0
    var toGreen: CGFloat = 0.0
    var toBlue: CGFloat = 0.0
    var toAlpha: CGFloat = 0.0
    toColor?.getRed(&toRed, green: &toGreen, blue: &toBlue, alpha: &toAlpha)
    
    let number = CGFloat(fminf(1, percent*4))
    let newRed: CGFloat = fromRed+(toRed-fromRed)*number
    let newGreen: CGFloat = fromGreen+(toGreen-fromGreen)*number
    let newBlue: CGFloat = fromBlue+(toBlue-fromBlue)*number
    let newAlpha: CGFloat = fromAlpha+(toAlpha-fromAlpha)*number
    
    return UIColor.init(red: newRed, green: newGreen, blue: newBlue, alpha: newAlpha)
}
