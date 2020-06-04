//
//  CNScreenAdapter.swift
//  IVW
//
//  Created by cn on 2019/7/25.
//

import UIKit



public let CNScreenWidth = CNScreenAdapter.screenWidth
public let CNScreenHeight = CNScreenAdapter.screenHeight

/// 根据传入的数值获取当前设备下的数值
///
/// - Parameter a: 传入数值
/// - Returns: 返回当前设备下计算的数值
public func AdFloatW(px a: CGFloat) -> CGFloat {return a*CNScreenAdapter.pxScreenWRate}
public func AdFloatW(pt a: CGFloat) -> CGFloat {return a*CNScreenAdapter.ptScreenWRate}

public func AdFloatH(px a: CGFloat) -> CGFloat {return a*CNScreenAdapter.pxScreenHRate}
public func AdFloatH(pt a: CGFloat) -> CGFloat {return a*CNScreenAdapter.ptScreenHRate}

public struct CNScreenAdapter {
    
    
    // TODO: ----- height -----
    /// 下安全区高度
    public static let downSafeHeight: CGFloat = isBangScreen ? 34.0 : 0.0
    /// 导航默认高度
    public static let navBarNormalHeight: CGFloat = 44.0
    /// TabBar默认高度
    public static let tabBarNormalHeight: CGFloat = 49.0
    /// 电池栏高度
    public static let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
    /// 真实导航高度
    public static let navigationBarHeight = navBarNormalHeight+statusBarHeight
    /// 真实TabBar高度
    public static let tabBarHeight = downSafeHeight+tabBarNormalHeight
    /// 屏幕宽
    public static let screenWidth = UIScreen.main.bounds.size.width
    /// 屏幕高
    public static let screenHeight = UIScreen.main.bounds.size.height
    
    
    // TODO: ----- Device -----
    /// 设计图机型
    public static var drawingDeviceType: DeviceType = .iphoneX
    /// 当前设备类型
    public static var presentDeviceType: DeviceType {
        let deviceSize = UIScreen.main.currentMode!.size;
        return DeviceType.init(rawValue: deviceSize)
    }
    /// 是否刘海屏 true: 是, false: 不是
    public static var isBangScreen: Bool {
        switch presentDeviceType {
        case .iphoneX, .iphoneXR, .iphoneXSMax:
            return true
        default:
            return false
        }
    }
    public enum DeviceType {
        case iphone5
        case iphone6
        case iphone6p
        case iphoneX
        case iphoneXR
        case iphoneXSMax
        case none /// 没有此设备
        init(rawValue: CGSize) {
            switch rawValue {
            case CGSize(width: 640, height: 1134):
                self = .iphone5
            case CGSize(width: 750, height: 1334):
                self = .iphone6
            case CGSize(width: 1242, height: 2208):
                self = .iphone6p
            case CGSize(width: 1125, height: 2436):
                self = .iphoneX
            case CGSize(width: 828, height: 1792), CGSize(width: 750, height: 1624):
                self = .iphoneXR
            case CGSize(width: 1242, height: 2688):
                self = .iphoneXSMax
            default:
                self = .none
            }
        }
    }
}

extension CNScreenAdapter {
    /// px屏幕比例W
    fileprivate static var pxScreenWRate: CGFloat {
        return rateW(withWidth: currentDevidePx.width, height: currentDevidePx.height, isPx: true)
    }
    /// pt屏幕比例W
    fileprivate static var ptScreenWRate: CGFloat {
        return rateW(withWidth: currentDevidePt.width, height: currentDevidePt.height, isPx: false)
    }
    /// px屏幕比例H
    fileprivate static var pxScreenHRate: CGFloat {
        return rateH(withWidth: currentDevidePx.width, height: currentDevidePx.height, isPx: true)
    }
    /// pt屏幕比例H
    fileprivate static var ptScreenHRate: CGFloat {
        return rateH(withWidth: currentDevidePt.width, height: currentDevidePt.height, isPx: false)
    }
    
    /// 根据屏幕方向获取比例
    ///
    /// - Parameters:
    ///   - width: 需要修改的宽度
    ///   - height: 需要修改的高度
    /// - Returns: 比例
    fileprivate static func rateW(withWidth width: CGFloat, height: CGFloat, isPx: Bool) -> CGFloat {
        var rate: CGFloat = isPx ? 0.5 : 1.0
        let screen_width = min(CNScreenWidth, CNScreenHeight)
        let screen_height = max(CNScreenWidth, CNScreenHeight)
        
        let rate_width: CGFloat = screen_width/width
        let rate_height: CGFloat = screen_height/height
        if screen_width*(isPx ? 2 : 1) > width { // 放大
            rate = max(rate_width, rate_height)
        }
        if screen_width*(isPx ? 2 : 1) < width { // 缩小
            rate = min(rate_width, rate_height)
        }
        return rate
    }
    fileprivate static func rateH(withWidth width: CGFloat, height: CGFloat, isPx: Bool) -> CGFloat {
        var rate: CGFloat = isPx ? 0.5 : 1.0
        let screen_width = min(CNScreenWidth, CNScreenHeight)
        let screen_height = max(CNScreenWidth, CNScreenHeight)
        
        let rate_width: CGFloat = screen_width/width
        let rate_height: CGFloat = screen_height/height
        if screen_height*(isPx ? 2 : 1) > height { // 放大
            rate = max(rate_width, rate_height)
        }
        if screen_height*(isPx ? 2 : 1) < height { // 缩小
            rate = min(rate_width, rate_height)
        }
        return rate
    }
    fileprivate static var currentDevidePx: CGSize {
        var height: CGFloat = 0.0
        var width: CGFloat = 0.0
        switch drawingDeviceType {
        case .iphone5:
            height = 568.0 * 2
            width = 320.0 * 2
        case .iphone6:
            height = 667.0 * 2
            width = 375.0 * 2
        case .iphone6p:
            height = 736.0 * 2
            width = 414.0 * 2
        case .iphoneX:
            height = 812.0 * 2
            width = 375.0 * 2
        case .iphoneXR:
            height = 896.0 * 2
            width = 414.0 * 2
        case .iphoneXSMax:
            height = 1344.0 * 2
            width = 621.0 * 2
        case .none:
            break
        }
        return CGSize(width: width, height: height)
    }
    fileprivate static var currentDevidePt: CGSize {
        var height: CGFloat = 0.0
        var width: CGFloat = 0.0
        switch drawingDeviceType {
        case .iphone5:
            height = 568.0
            width = 320.0
        case .iphone6:
            height = 667.0
            width = 375.0
        case .iphone6p:
            height = 736.0
            width = 414.0
        case .iphoneX:
            height = 812.0
            width = 375.0
        case .iphoneXR:
            height = 896.0
            width = 414.0
        case .iphoneXSMax:
            height = 1344.0
            width = 621.0
        case .none:
            break
        }
        return CGSize(width: width, height: height)
    }
}



// MARK: - ----- tool -----
// TODO: ----- 设备相关 -----
import AdSupport
public extension UIDevice {
    static var IDFVString: String {
        return UIDevice.current.identifierForVendor!.uuidString
    }
    static var IDFAString: String {
        return ASIdentifierManager.shared().advertisingIdentifier.uuidString
    }
}

// TODO: ----- 字体相关 -----
public func CNFont(fSize: CGFloat) -> UIFont {return UIFont.systemFont(ofSize: fSize)}
@available(iOS 8.2, *)
public func CNFont(fSize: CGFloat, weight: UIFont.Weight) -> UIFont {return UIFont.systemFont(ofSize: fSize, weight: weight)}

// TODO: ----- 图片相关 -----
public func CNImage(name: String) -> UIImage {
    if name.count == 0 {return UIImage.init()}
    let image = UIImage.init(named: name)
    guard image != nil else {
        return UIImage.init()
    }
    return image!
}

// TODO: ----- 颜色相关 -----
public func CNRgbHex(_ hex: String, alpha: CGFloat = 1.0) -> UIColor {
    var cString = NSString.init(string: hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
    if cString.length < 6 { return .clear }
    if cString.hasPrefix("0X") {
        cString = NSString.init(string: cString.substring(from: 2))
    }
    if cString.hasPrefix("#") {
        cString = NSString.init(string: cString.substring(from: 1))
    }
    if cString.length != 6 { return .clear }
    
    var range = NSRange.init(location: 0, length: 2)
    let rString = cString.substring(with: range)
    range.location = 2
    let gString = cString.substring(with: range)
    range.location = 4
    let bString = cString.substring(with: range)
    
    var r: UInt32 = 0, g: UInt32 = 0, b: UInt32 = 0
    Scanner.init(string: rString).scanHexInt32(&r)
    Scanner.init(string: gString).scanHexInt32(&g)
    Scanner.init(string: bString).scanHexInt32(&b)
    
    return CNRgb(R: CGFloat(r), G: CGFloat(g), B: CGFloat(b), A: alpha)
}
public func CNRgb(R: CGFloat, G: CGFloat, B: CGFloat, A: CGFloat) -> UIColor {
    return UIColor.init(red: R/255.0, green: G/255.0, blue: B/255.0, alpha: A)
}
var CNRandomColor: UIColor {
    return CNRgb(R: CGFloat(arc4random_uniform(256)), G: CGFloat(arc4random_uniform(256)), B: CGFloat(arc4random_uniform(256)), A: CGFloat(arc4random_uniform(256)))
}

// TODO: ----- 滚动视图适配 -----
public extension UIViewController {
    func automaticallyAdjustsScrollViewInset(scrollView: UIScrollView) {
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
    }
}

// TODO: ----- view所在的控制器 -----
public extension UIView {
    func belongWhichController() -> UIViewController? {
        var next = self
        while true {
            guard let nextResponder = next.next else {return nil}
            if nextResponder.isKind(of: UIViewController.self) {
                return nextResponder as? UIViewController
            }
            next = next.superview!
        }
    }
}

