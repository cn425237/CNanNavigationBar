//
//  UIViewControllerExtension.swift
//  navgationBar.swift
//
//  Created by cn on 2019/6/13.
//  Copyright © 2019 cn. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    
    // TODO: ----- property -----
    /// 允许侧滑或点击返回上一个控制器 可重写
    @objc open var shouldPopOnBackButtonPress: Bool {return true}
    /// 导航隐藏显示
    public var cn_navBarHidden: Bool {
        get {return objc_getAssociatedObject(self, &viewControllerKey.navBarHiddenKey) as? Bool ?? false}
        set {
            objc_setAssociatedObject(self, &viewControllerKey.navBarHiddenKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            cn_shadowHidden = newValue
            navigationController?.navigationBar.cn_isHidden = newValue
        }
    }
    /// 导航透明度
    public var cn_navBarAlpha: CGFloat {
        get {return objc_getAssociatedObject(self, &viewControllerKey.navBarAlphaKey) as? CGFloat ?? 1.0}
        set {
            objc_setAssociatedObject(self, &viewControllerKey.navBarAlphaKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            let alpha = newValue <= 0.0 ? max(0.0, newValue) : min(1.0, newValue)
            navigationController?.navigationBar.cn_visualEffecView.alpha = alpha
            navigationController?.navigationBar.cn_shadowView.alpha = alpha
        }
    }
    /// 导航背景颜色
    public var cn_barTintColor: UIColor? {
        get {return objc_getAssociatedObject(self, &viewControllerKey.barTintFuzzyColorKey) as? UIColor ?? UINavigationBar.defaultColor}
        set {
            if cn_navBarStyle==UIBarStyle.black {return}
            objc_setAssociatedObject(self, &viewControllerKey.barTintFuzzyColorKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            navigationController?.navigationBar.cn_visualEffecView.subviews.last?.backgroundColor = newValue ?? UINavigationBar.defaultColor
        }
    }
    /// 导航最底部线条显示
    public var cn_shadowHidden: Bool {
        get {return objc_getAssociatedObject(self, &viewControllerKey.shadowImageHiddenKey) as? Bool ?? false}
        set {
            objc_setAssociatedObject(self, &viewControllerKey.shadowImageHiddenKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
            navigationController?.navigationBar.cn_shadowView.isHidden = newValue
        }
    }
    /// 导航背景图片
    public var cn_navBarImage: UIImage? {
        get {return objc_getAssociatedObject(self, &viewControllerKey.navBarImageKey) as? UIImage}
        set {
            objc_setAssociatedObject(self, &viewControllerKey.navBarImageKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            navigationController?.navigationBar.cn_visualEffecView.subviews.last?.layer.contents = newValue?.cgImage
        }
    }
    /// 导航样式
    public var cn_navBarStyle: UIBarStyle {
        get {return objc_getAssociatedObject(self, &viewControllerKey.navBarStyleKey) as? UIBarStyle ?? UIBarStyle.default}
        set {
            objc_setAssociatedObject(self, &viewControllerKey.navBarStyleKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            navigationController?.navigationBar.cn_visualEffecView.subviews.last?.backgroundColor = navigationBarStyleColor
        }
    }
    /// 导航渲染颜色
    public var cn_tintColor: UIColor? {
        get {
            guard let color = objc_getAssociatedObject(self, &viewControllerKey.tintColorKey) as? UIColor else { return UINavigationBar.appearance().tintColor }
            return color
        }
        set {
            objc_setAssociatedObject(self, &viewControllerKey.tintColorKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            navigationController?.navigationBar.tintColor = newValue
        }
    }
    /// 导航标题属性
    public var cn_titleTextAttributes: [NSAttributedString.Key : Any]? {
        get {
            guard let att = objc_getAssociatedObject(self, &viewControllerKey.titleTextAttributesKey) as? [NSAttributedString.Key : Any] else { return UINavigationBar.appearance().titleTextAttributes }
            return att
        }
        set {
            objc_setAssociatedObject(self, &viewControllerKey.titleTextAttributesKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            navigationController?.navigationBar.titleTextAttributes = newValue
        }
    }
    private var navigationBarStyleColor: UIColor? {
        switch cn_navBarStyle {
        case UIBarStyle.default:
            return cn_barTintColor
        case UIBarStyle.black:
            return UINavigationBar.blackColor
        default:
            return cn_barTintColor
        }
    }
    
    // TODO: ----- device -----
    /// 状态栏样式
    public var cn_statusBarStyle: UIStatusBarStyle {
        get {return objc_getAssociatedObject(self, &viewControllerKey.statusBarStyleKey) as? UIStatusBarStyle ?? UIStatusBarStyle.default}
        set {
            objc_setAssociatedObject(self, &viewControllerKey.statusBarStyleKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            UIView.animate(withDuration: 0.25) {
                self.setNeedsStatusBarAppearanceUpdate()
            }
        }
    }
    /// 是否允许侧滑返回
    public var cn_backInteractive: Bool {
        get {return objc_getAssociatedObject(self, &viewControllerKey.backInteractiveKey) as? Bool ?? true}
        set {objc_setAssociatedObject(self, &viewControllerKey.backInteractiveKey, newValue, .OBJC_ASSOCIATION_ASSIGN)}
    }
    /// 是否支持旋转
    public var cn_shouldAutorotate: Bool {
        get {return objc_getAssociatedObject(self, &viewControllerKey.shouldAutorotateKey) as? Bool ?? false}
        set {objc_setAssociatedObject(self, &viewControllerKey.shouldAutorotateKey, newValue, .OBJC_ASSOCIATION_ASSIGN)}
    }
    /// 界面支持旋转方向
    public var cn_supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get { return objc_getAssociatedObject(self, &viewControllerKey.supportedInterfaceOrientationsKey) as? UIInterfaceOrientationMask ?? UIInterfaceOrientationMask.portrait }
        set {objc_setAssociatedObject(self, &viewControllerKey.supportedInterfaceOrientationsKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)}
    }
    /// 模态切换的默认方向
    public var cn_preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        get {return objc_getAssociatedObject(self, &viewControllerKey.preferredInterfaceOrientationForPresentationKey) as? UIInterfaceOrientation ?? UIInterfaceOrientation.portrait}
        set {objc_setAssociatedObject(self, &viewControllerKey.preferredInterfaceOrientationForPresentationKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)}
    }
    
    public class var window: UIWindow {return UIApplication.shared.keyWindow!}
    public class var rootViewController: UIViewController {return window.rootViewController!}
    /// 当前显示控制器
    public class var currentViewController: UIViewController {return getCurrentVC(rootViewController)}
    /// 查找当前Presented出来的控制器
    public class func lastPresentedViewController(_ presented: UIViewController) -> UIViewController {
        guard let lastViewController = presented.presentedViewController else {return presented}
        return lastPresentedViewController(lastViewController)
    }
    /// 递归查询当前显示的控制器
    public class func getCurrentVC(_ rootViewController: UIViewController) -> UIViewController {
        var currentViewController = rootViewController
        let rootVc = lastPresentedViewController(rootViewController)
        if rootVc.isKind(of: UITabBarController.self) { // 根视图为UITabBarController
            let tabBarVc: UITabBarController = rootVc as! UITabBarController
            currentViewController = getCurrentVC(tabBarVc.selectedViewController!)
        } else if rootVc.isKind(of: UINavigationController.self) {// 根视图为UINavigationController
            let navVc: UINavigationController = rootVc as! UINavigationController
            currentViewController = getCurrentVC(navVc.visibleViewController!)
        } else { // 根视图为非导航类
            currentViewController = rootVc
        }
        return currentViewController
    }
    
    // TODO: ----- update -----
    private class func updatePushController(withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator, viewController: UIViewController, navigationBar: UINavigationBar) {
        let from = coordinator.viewController(forKey: UITransitionContextViewControllerKey.from)
        let to = viewController
        if coordinator.isInteractive { /// 有交互返回
            coordinator.notifyWhenInteractionEnds { (context: UIViewControllerTransitionCoordinatorContext) in
                navigationBar.tintColor = context.isCancelled ? from?.cn_tintColor : to.cn_tintColor
            }
        } else {
            navigationBar.tintColor = to.cn_tintColor
        }
        coordinator.animate(alongsideTransition: { (context: UIViewControllerTransitionCoordinatorContext) in
            UIView.performWithoutAnimation {
                from?.vc_visualEffecView.frame = navigationBar.cn_visualEffecView.frame
                to.vc_visualEffecView.frame = navigationBar.cn_visualEffecView.frame
                from?.vc_shadowView.frame = navigationBar.cn_shadowView.frame
                to.vc_shadowView.frame = navigationBar.cn_shadowView.frame
            }
        }) { (context: UIViewControllerTransitionCoordinatorContext) in
            from?.vc_visualEffecView.removeFromSuperview()
            to.vc_visualEffecView.removeFromSuperview()
            from?.vc_shadowView.removeFromSuperview()
            to.vc_shadowView.removeFromSuperview()
            
            UIView.setAnimationsEnabled(false)
            switch context.isCancelled {
                case true:
                    navigationBar.cn_isHidden = from?.cn_navBarHidden ?? false
                    if !(from?.cn_navBarHidden ?? false) {
                        navigationBar.cn_visualEffecView.subviews.last?.backgroundColor = from?.navigationBarStyleColor
                        navigationBar.cn_visualEffecView.subviews.last?.layer.contents = from?.cn_navBarImage?.cgImage
                        navigationBar.cn_visualEffecView.alpha = from?.cn_navBarAlpha ?? 1.0
                        navigationBar.cn_shadowView.alpha = from?.cn_navBarAlpha ?? 1.0
                    }
                case false:
                    navigationBar.cn_isHidden = to.cn_navBarHidden
                    if !to.cn_navBarHidden {
                        navigationBar.cn_visualEffecView.subviews.last?.backgroundColor = to.navigationBarStyleColor
                        navigationBar.cn_visualEffecView.subviews.last?.layer.contents = to.cn_navBarImage?.cgImage
                        navigationBar.cn_visualEffecView.alpha = to.cn_navBarAlpha
                        navigationBar.cn_shadowView.alpha = to.cn_navBarAlpha
                }
            }
            UIView.setAnimationsEnabled(true)
        }
    }
    internal class func updateNavigationBar(_ transitionCoordinator: UIViewControllerTransitionCoordinator?, _ navigationBar: UINavigationBar, _ show: UIViewController) {
        navigationBar.cn_isHidden = true
        if let coordinator = transitionCoordinator, coordinator.viewController(forKey: .from)?.presentedViewController == nil { /// push
            updatePushController(withTransitionCoordinator: coordinator, viewController: show, navigationBar: navigationBar)
        } else { /// present, select
            let to = show
            navigationBar.cn_isHidden = to.cn_navBarHidden
            if !to.cn_navBarHidden {
                navigationBar.cn_visualEffecView.subviews.last?.backgroundColor = to.navigationBarStyleColor
                navigationBar.cn_visualEffecView.subviews.last?.layer.contents = to.cn_navBarImage?.cgImage
                navigationBar.cn_visualEffecView.alpha = to.cn_navBarAlpha
                navigationBar.cn_shadowView.alpha = to.cn_navBarAlpha
                navigationBar.tintColor = to.cn_tintColor
                navigationBar.titleTextAttributes = to.cn_titleTextAttributes
            }
        }
    }
    
    
    // TODO: --- swizzling -----
    @objc internal class func swiftInitialize() {
        CNSwizzlingManager.swizzlingForClass(forClass: UIViewController.classForCoder(), originalSelector: #selector(viewDidLoad), swizzledSelector: #selector(cn_viewDidLoad))
        CNSwizzlingManager.swizzlingForClass(forClass: UIViewController.classForCoder(), originalSelector: #selector(viewWillAppear(_:)), swizzledSelector: #selector(cn_viewWillAppear(_:)))
        CNSwizzlingManager.swizzlingForClass(forClass: UIViewController.classForCoder(), originalSelector: #selector(present(_:animated:completion:)), swizzledSelector: #selector(cn_present(_:animated:completion:)))
    }
    @objc private func cn_viewDidLoad() {
        self.cn_viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
    }
    @objc private func cn_viewWillAppear(_ animated: Bool) {
        self.cn_viewWillAppear(animated)
    }
    @objc private func cn_present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        if #available(iOS 13.0, *) {
            if viewControllerToPresent.modalPresentationStyle == .automatic {
                viewControllerToPresent.modalPresentationStyle = .fullScreen
            }
        }
        self.cn_present(viewControllerToPresent, animated: flag, completion: completion)
    }
    
    // TODO: ----- UI -----
    private var vc_visualEffecView: UIVisualEffectView {
        get {
            var any = objc_getAssociatedObject(self, &viewControllerKey.visualEffecViewKey) as? UIVisualEffectView
            if any == nil {
                any = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffect.Style.extraLight))
                any!.subviews.last?.layer.contentsGravity = CALayerContentsGravity.init(rawValue: "resizeAspectFill")
                any!.subviews.last?.layer.masksToBounds = true
                objc_setAssociatedObject(self, &viewControllerKey.visualEffecViewKey, any, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            view.addSubview(any!)
            any!.isHidden = cn_navBarHidden
            if !any!.isHidden {
                any!.alpha = cn_navBarAlpha
                any!.subviews.last?.backgroundColor = navigationBarStyleColor
                any!.subviews.last?.layer.contents = cn_navBarImage?.cgImage
            }
            return any!
        }
    }
    private var vc_shadowView: UIView {
        get {
            var any = objc_getAssociatedObject(self, &viewControllerKey.shadowViewKey) as? UIView
            if any == nil {
                any = UIView.init()
                objc_setAssociatedObject(self, &viewControllerKey.shadowViewKey, any, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            view.addSubview(any!)
            any!.isHidden = cn_shadowHidden
            if !any!.isHidden {
                any!.backgroundColor = UINavigationBar.shadowColor
                any!.alpha = cn_navBarAlpha
            }
            return any!
        }
    }
    
    // TODO: ----- other -----
    private struct viewControllerKey {
        static var navBarHiddenKey = "cn_navBarHidden"
        static var navBarAlphaKey = "cn_navBarAlpha"
        static var barTintFuzzyColorKey = "cn_barTintFuzzyColor"
        static var shadowImageHiddenKey = "cn_shadowImageHidden"
        static var navBarImageKey = "cn_navBarImage"
        static var navBarStyleKey = "cn_navBarStyle"
        static var tintColorKey = "cn_tintColor"
        static var titleTextAttributesKey = "cn_titleTextAttributes"
        
        static var statusBarStyleKey = "cn_statusBarStyle"
        static var backInteractiveKey = "cn_backInteractive"
        static var shouldAutorotateKey = "cn_shouldAutorotate"
        static var supportedInterfaceOrientationsKey = "cn_supportedInterfaceOrientations"
        static var preferredInterfaceOrientationForPresentationKey = "cn_preferredInterfaceOrientationForPresentation"
        
        static var visualEffecViewKey = "vc_visualEffecView"
        static var shadowViewKey = "vc_shadowView"
    }
}


