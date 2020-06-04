//
//  ViewController.swift
//  CNanNavigationBar
//
//  Created by cn on 06/04/2020.
//  Copyright (c) 2020 cn. All rights reserved.
//

import UIKit
import CNanNavigationBar

class ViewController: UIViewController {
    
    /// MARK: ----- event -----
    @objc func sliderEvent(sender: UISlider) {
        navigationBarAlpha.text = String.init(format: "navigationBarAlpha: %.1f", sender.value)
        cn_navBarAlpha = CGFloat(sender.value)
    }
    @objc func swichEvent(sender: UISwitch) {
        switch sender.tag {
        case 0:
            cn_navBarHidden = sender.isOn
            swichs[1].isOn = sender.isOn
        case 1:
            cn_shadowHidden = sender.isOn
        case 2:
            if sender.isOn {
                cn_navBarStyle = UIBarStyle.black
                tintFuzzyColorSegmented.isEnabled = false
                tintPureColorSegmented.isEnabled = false
            } else {
                cn_navBarStyle = UIBarStyle.default
                tintFuzzyColorSegmented.isEnabled = true
                tintPureColorSegmented.isEnabled = true
            }
            break
        case 3:
            cn_navBarImage = sender.isOn ? UIImage.init(named: "navImage") : UIImage.init()
            break
        default:
            break
        }
    }
    @objc func segmentedEvent(sender: UISegmentedControl) {
        if sender.tag==1 {
            switch sender.selectedSegmentIndex {
            case 0:
                cn_barTintColor = UINavigationBar.defaultColor
            case 1:
                cn_barTintColor = UIColor.red.withAlphaComponent(0.85)
            case 2:
                cn_barTintColor = UIColor.green.withAlphaComponent(0.85)
            case 3:
                cn_barTintColor = UIColor.blue.withAlphaComponent(0.85)
            case 4:
                cn_barTintColor = UIColor.magenta.withAlphaComponent(0.85)
            case 5:
                cn_barTintColor = UIColor.cyan.withAlphaComponent(0.85)
            default:
                break
            }
            tintPureColorSegmented.selectedSegmentIndex = -1
            return
        }
        if sender.tag==2 {
            switch sender.selectedSegmentIndex {
            case 0:
                cn_barTintColor = UIColor.white
            case 1:
                cn_barTintColor = UIColor.red
            case 2:
                cn_barTintColor = UIColor.green
            case 3:
                cn_barTintColor = UIColor.blue
            case 4:
                cn_barTintColor = UIColor.magenta
            case 5:
                cn_barTintColor = UIColor.cyan
            default:
                break
            }
            tintFuzzyColorSegmented.selectedSegmentIndex = -1
            return
        }
        if sender.tag==3 {
            switch sender.selectedSegmentIndex {
            case 0:
                cn_tintColor = nil
            case 1:
                cn_tintColor = UIColor.red
            case 2:
                cn_tintColor = UIColor.green
            case 3:
                cn_tintColor = UIColor.blue
            case 4:
                cn_tintColor = UIColor.magenta
            case 5:
                cn_tintColor = UIColor.cyan
            default:
                break
            }
            return
        }
        if sender.tag==4 {
            var att: [NSAttributedString.Key:Any]?
            switch sender.selectedSegmentIndex {
            case 1:
                att = [.foregroundColor:UIColor.red]
            case 2:
                att = [.foregroundColor:UIColor.green]
            case 3:
                att = [.foregroundColor:UIColor.blue]
            case 4:
                att = [.foregroundColor:UIColor.magenta]
            case 5:
                att = [.foregroundColor:UIColor.cyan]
            default:
                break
            }
            cn_titleTextAttributes = att
            return
        }
    }
    @objc func nextEvent(sender: UIButton) {
        switch sender.tag {
        case 1:
            let vc = ViewController.init()
            vc.index = index+1
            self.navigationController?.pushViewController(vc, animated: true)
        case 2:
            self.navigationController?.pushViewController(twoController.init(), animated: true)
        default:break
        }
    }
    
    /// MARK: ----- crateUI -----
    var index: NSInteger = 1
    func crateUI() {
        view.addSubview(scrollView)
        var lastView = UIView.init()
        for index in 0...4 {
            let height = 40
            let colorView = UIView.init(frame: CGRect.init(x: 15.0, y: 0.0, width: view.width-30.0, height: CGFloat(height)))
            colorView.layer.cornerRadius = 4.0
            colorView.top = 10+CGFloat.init(integerLiteral: index*height)+CGFloat.init(integerLiteral: index*10)
            switch index {
            case 0:
                colorView.backgroundColor = UIColor.init(red: 255/255, green: 99/255, blue: 71/255, alpha: 1)
            case 1:
                colorView.backgroundColor = UIColor.init(red: 188/255, green: 143/255, blue: 143/255, alpha: 1)
            case 2:
                colorView.backgroundColor = UIColor.init(red: 218/255, green: 112/255, blue: 214/255, alpha: 1)
            case 3:
                colorView.backgroundColor = UIColor.init(red: 3/255, green: 168/255, blue: 158/255, alpha: 1)
            case 4:
                colorView.backgroundColor = UIColor.init(red: 8/255, green: 46/255, blue: 84/255, alpha: 1)
                lastView = colorView
            default:break
            }
            scrollView.addSubview(colorView)
        }
        let texts = ["navigationBarHidden", "shadowImageHidden", "navigationBarStyle", "navigationBarImage"]
        for index in 0..<texts.count {
            let lab = UILabel.init()
            lab.font = UIFont.systemFont(ofSize: 17)
            lab.text = texts[index]
            lab.size = CGSize.init(width: lab.sizeThatFits(CGSize.zero).width, height: 40)
            lab.left = 15
            lab.top = 20+lastView.bottom+CGFloat.init(integerLiteral: index*40)
            scrollView.addSubview(lab)
            
            let swich = UISwitch.init()
            swich.tag = index
            swich.addTarget(self, action: #selector(swichEvent(sender:)), for: UIControl.Event.touchUpInside)
            swich.left = view.width-swich.width-lab.left
            swich.centerY = lab.centerY
            swichs.append(swich)
            scrollView.addSubview(swich)
        }
        navigationBarAlpha.top = swichs.last!.bottom+20
        scrollView.addSubview(navigationBarAlpha)
        scrollView.addSubview(slider)
        scrollView.addSubview(navigationBarTintFuzzyColor)
        scrollView.addSubview(tintFuzzyColorSegmented)
        scrollView.addSubview(navigationBarTintPureColor)
        scrollView.addSubview(tintPureColorSegmented)
        scrollView.addSubview(navigationBarTintColor)
        scrollView.addSubview(tintColorSegmented)
        scrollView.addSubview(navigationBarTitleTextAttributes)
        scrollView.addSubview(titleTextAttributesSegmented)
        scrollView.addSubview(nextBtn)
        scrollView.addSubview(gradualBtn)
    }
    var swichs: [UISwitch] = []
    lazy var gradualBtn: UIButton = {
        let gradualBtn = UIButton.init(type: UIButton.ButtonType.custom)
        gradualBtn.tag = 2
        gradualBtn.addTarget(self, action: #selector(nextEvent(sender:)), for: UIControl.Event.touchUpInside)
        gradualBtn.layer.cornerRadius = nextBtn.layer.cornerRadius
        gradualBtn.backgroundColor = UIColor.init(red: 118/255, green: 128/255, blue: 105/255, alpha: 1)
        gradualBtn.setTitle("nextGradualBarViewController", for: UIControl.State.normal)
        gradualBtn.size = CGSize.init(width: gradualBtn.sizeThatFits(CGSize.zero).width+20, height: gradualBtn.sizeThatFits(CGSize.zero).height)
        gradualBtn.centerX = scrollView.centerX
        gradualBtn.top = nextBtn.bottom+20
        return gradualBtn
    }()
    lazy var nextBtn: UIButton = {
        let nextBtn = UIButton.init(type: UIButton.ButtonType.custom)
        nextBtn.tag = 1
        nextBtn.addTarget(self, action: #selector(nextEvent(sender:)), for: UIControl.Event.touchUpInside)
        nextBtn.layer.cornerRadius = 4
        nextBtn.backgroundColor = UIColor.init(red: 88/255, green: 87/255, blue: 86/255, alpha: 1)
        nextBtn.setTitle("nextViewController", for: UIControl.State.normal)
        nextBtn.size = CGSize.init(width: nextBtn.sizeThatFits(CGSize.zero).width+20, height: nextBtn.sizeThatFits(CGSize.zero).height)
        nextBtn.centerX = scrollView.centerX
        nextBtn.top = titleTextAttributesSegmented.bottom+20
        return nextBtn
    }()
    lazy var tintPureColorSegmented: UISegmentedControl = {
        let segmented = UISegmentedControl.init(items: ["default","red","green","blue","magenta","cyan"])
        segmented.tag = 2
        segmented.frame = CGRect.init(x: 15, y: navigationBarTintPureColor.bottom+15, width: view.width-30, height: 40)
        segmented.addTarget(self, action: #selector(segmentedEvent(sender:)), for: UIControl.Event.valueChanged)
        return segmented
    }()
    lazy var navigationBarTintPureColor: UILabel = {
        let tintFuzzyColor = UILabel.init()
        tintFuzzyColor.text = "navigationBarTintPureColor"
        tintFuzzyColor.font = navigationBarAlpha.font
        tintFuzzyColor.sizeToFit()
        tintFuzzyColor.left = 15
        tintFuzzyColor.top = tintFuzzyColorSegmented.bottom+20
        return tintFuzzyColor
    }()
    lazy var tintFuzzyColorSegmented: UISegmentedControl = {
        let segmented = UISegmentedControl.init(items: ["default","red","green","blue","magenta","cyan"])
        segmented.tag = 1
        segmented.selectedSegmentIndex = 0
        segmented.frame = CGRect.init(x: 15, y: navigationBarTintFuzzyColor.bottom+15, width: view.width-30, height: 40)
        segmented.addTarget(self, action: #selector(segmentedEvent(sender:)), for: UIControl.Event.valueChanged)
        return segmented
    }()
    lazy var navigationBarTintFuzzyColor: UILabel = {
        let tintFuzzyColor = UILabel.init()
        tintFuzzyColor.text = "navigationBarTintFuzzyColor"
        tintFuzzyColor.font = navigationBarAlpha.font
        tintFuzzyColor.sizeToFit()
        tintFuzzyColor.left = 15
        tintFuzzyColor.top = slider.bottom+20
        return tintFuzzyColor
    }()
    lazy var tintColorSegmented: UISegmentedControl = {
        let segmented = UISegmentedControl.init(items: ["default","red","green","blue","magenta","cyan"])
        segmented.tag = 3
        segmented.selectedSegmentIndex = 0
        segmented.frame = CGRect.init(x: 15, y: navigationBarTintColor.bottom+15, width: view.width-30, height: 40)
        segmented.addTarget(self, action: #selector(segmentedEvent(sender:)), for: UIControl.Event.valueChanged)
        return segmented
    }()
    lazy var navigationBarTintColor: UILabel = {
        let tintFuzzyColor = UILabel.init()
        tintFuzzyColor.text = "navigationBarTintColor"
        tintFuzzyColor.font = navigationBarAlpha.font
        tintFuzzyColor.sizeToFit()
        tintFuzzyColor.left = 15
        tintFuzzyColor.top = tintPureColorSegmented.bottom+20
        return tintFuzzyColor
    }()
    lazy var titleTextAttributesSegmented: UISegmentedControl = {
        let segmented = UISegmentedControl.init(items: ["default","red","green","blue","magenta","cyan"])
        segmented.tag = 4
        segmented.selectedSegmentIndex = 0
        segmented.frame = CGRect.init(x: 15, y: navigationBarTitleTextAttributes.bottom+15, width: view.width-30, height: 40)
        segmented.addTarget(self, action: #selector(segmentedEvent(sender:)), for: UIControl.Event.valueChanged)
        return segmented
    }()
    lazy var navigationBarTitleTextAttributes: UILabel = {
        let tintFuzzyColor = UILabel.init()
        tintFuzzyColor.text = "navigationBarTitleTextAttributes"
        tintFuzzyColor.font = navigationBarAlpha.font
        tintFuzzyColor.sizeToFit()
        tintFuzzyColor.left = 15
        tintFuzzyColor.top = tintColorSegmented.bottom+20
        return tintFuzzyColor
    }()
    lazy var slider: UISlider = {
        let slider = UISlider.init(frame: CGRect.init(x: 15, y: navigationBarAlpha.bottom+20, width: view.width-30, height: 20))
        slider.addTarget(self, action: #selector(sliderEvent(sender:)), for: UIControl.Event.valueChanged)
        slider.minimumValue = 0.0
        slider.maximumValue = 1.0
        slider.value = slider.maximumValue
        navigationBarAlpha.text = String.init(format: "navigationBarAlpha: %.1f", slider.value)
        return slider
    }()
    lazy var navigationBarAlpha: UILabel = {
        let navigationBarAlpha = UILabel.init()
        navigationBarAlpha.text = "navigationBarAlpha"
        navigationBarAlpha.font = UIFont.systemFont(ofSize: 17)
        navigationBarAlpha.size = CGSize.init(width: navigationBarAlpha.sizeThatFits(CGSize.zero).width+50, height: navigationBarAlpha.sizeThatFits(CGSize.zero).height)
        navigationBarAlpha.left = 15
        return navigationBarAlpha
    }()
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView.init(frame: self.view.bounds)
        let colors = [UIColor.init(red: 245/255.0, green: 245/255, blue: 245/255, alpha: 1),
                      UIColor.init(red: 202/255, green: 235/255, blue: 216/255, alpha: 1),
                      UIColor.init(red: 251/255, green: 255/255, blue: 242/255, alpha: 1)]
        scrollView.backgroundColor = colors[NSInteger(arc4random()%3)]
        scrollView.contentSize = CGSize.init(width: scrollView.width, height: 1200)
        return scrollView
    }()
    
    /// MARK: ----- other -----
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return cn_statusBarStyle
    }
    /// MARK: ----- the life cycle -----
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "viewController\(index)"
        self.crateUI()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "右", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        scrollView.height = view.height
    }
    deinit {
        print("\(self)-->deinit")
    }
}

