# CNanNavigationBar

[![CI Status](https://img.shields.io/travis/cn/CNanNavigationBar.svg?style=flat)](https://travis-ci.org/cn/CNanNavigationBar)
[![Version](https://img.shields.io/cocoapods/v/CNanNavigationBar.svg?style=flat)](https://cocoapods.org/pods/CNanNavigationBar)
[![License](https://img.shields.io/cocoapods/l/CNanNavigationBar.svg?style=flat)](https://cocoapods.org/pods/CNanNavigationBar)
[![Platform](https://img.shields.io/cocoapods/p/CNanNavigationBar.svg?style=flat)](https://cocoapods.org/pods/CNanNavigationBar)


## 效果

![]()

![]()

![]()

![]()

![]()


## 主要属性
```ruby
/// 允许侧滑或点击返回上一个控制器 可重写
@objc open var shouldPopOnBackButtonPress: Bool { get }

/// 导航隐藏显示
public var cn_navBarHidden: Bool { get set }

/// 导航透明度
public var cn_navBarAlpha: CGFloat { get set }

/// 导航背景颜色
public var cn_barTintColor: UIColor? { get set }

/// 导航最底部线条显示
public var cn_shadowHidden: Bool { get set }

/// 导航背景图片
public var cn_navBarImage: UIImage? { get set }

/// 导航样式
public var cn_navBarStyle: UIBarStyle { get set }

/// 导航渲染颜色
public var cn_tintColor: UIColor? { get set }

/// 导航标题属性
public var cn_titleTextAttributes: [NSAttributedString.Key : Any]? { get set }

/// 状态栏样式
public var cn_statusBarStyle: UIStatusBarStyle { get set }

/// 是否允许侧滑返回
public var cn_backInteractive: Bool { get set }

/// 是否支持旋转
public var cn_shouldAutorotate: Bool { get set }

/// 界面支持旋转方向
public var cn_supportedInterfaceOrientations: UIInterfaceOrientationMask { get set }

/// 模态切换的默认方向
public var cn_preferredInterfaceOrientationForPresentation: UIInterfaceOrientation { get set }

public class var window: UIWindow { get }

public class var rootViewController: UIViewController { get }

/// 当前显示控制器
public class var currentViewController: UIViewController { get }

/// 查找当前Presented出来的控制器
public class func lastPresentedViewController(_ presented: UIViewController) -> UIViewController

/// 递归查询当前显示的控制器
public class func getCurrentVC(_ rootViewController: UIViewController) -> UIViewController
```

## 全局设置UINavigationBar属性
```ruby
UINavigationBar.appearance().tintColor = ivwSelectColor
UINavigationBar.appearance().titleTextAttributes = [.foregroundColor:UIColor.black, .font:UIFont.boldSystemFont(ofSize: 16)]
UINavigationBar.appearance().backIndicatorImage = CNImage(name: "login_back")
UINavigationBar.appearance().backIndicatorTransitionMaskImage = CNImage(name: "login_back")
```

## 使用只需要
```ruby
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UIApplication.runOnce
        window = UIWindow.init()
        window?.backgroundColor = UIColor.white
        window?.rootViewController = UINavigationController(rootViewController: ViewController.init())
        window?.makeKeyAndVisible()
        retuen true
    }
    
}

class twoController: UIViewController {

    override var shouldPopOnBackButtonPress: Bool {
        return true
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) { 
        let alpha = scrollView.contentOffset.y/(headerSize.height-CNNavigationBarHeight)
        cn_navBarAlpha = alpha
    }
    
    override func viewDidLoad() { 
        super.viewDidLoad()
        // cn_navBarHidden = true
        // cn_backInteractive = false // 禁用侧滑返回
        cn_navBarAlpha = 0.5
        cn_navBarImage = UIImage.init(named: "")
    }
}

```




## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

CNanNavigationBar is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'CNanNavigationBar'
```

## Author

cn, 742585697@qq.com

## License

CNanNavigationBar is available under the MIT license. See the LICENSE file for more info.
