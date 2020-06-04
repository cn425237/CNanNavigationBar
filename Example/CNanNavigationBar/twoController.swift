//
//  twoController.swift
//  CNanNavigationBar_Example
//
//  Created by cn on 2020/6/4.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

class twoCell: UITableViewCell {
    @objc func btnClick(sender: UIButton) {
        print(sender)
    }
    lazy var btn: UIButton = {
        let btn = UIButton.init(type: UIButton.ButtonType.custom)
        btn.setTitle("可测试导航穿透", for: UIControl.State.normal)
        btn.setTitleColor(UIColor.black, for: UIControl.State.normal)
        btn.addTarget(self, action: #selector(btnClick(sender:)), for: .touchUpInside)
        btn.sizeToFit()
        return btn
    }()
    override func layoutSubviews() {
        btn.centerY = contentView.centerY
        btn.centerX = contentView.centerX
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = UITableViewCell.SelectionStyle.none
        backgroundColor = UIColor.lightGray
        contentView.addSubview(btn)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class twoController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    override var shouldPopOnBackButtonPress: Bool {
        return true
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //        navigationController?.navigationBar.cn_scrollViewWillBeginDragging(scrollView: scrollView)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //        navigationController?.navigationBar.cn_scrollViewDidScroll(scrollView: scrollView)
        let offestY = scrollView.contentOffset.y/300;
        cn_navBarAlpha = offestY;
        if offestY>0.5 {
            cn_titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white, NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 24)]
            cn_tintColor = UIColor.white
            cn_statusBarStyle = .lightContent;
        } else {
            cn_titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black, NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 18)]
            cn_tintColor = UIColor.black
            cn_statusBarStyle = .default;
        }
//        navigationItem.rightBarButtonItem?.setTitleTextAttributes(cn_titleTextAttributes, for: UIControl.State.normal)
    }
    
    /// MARK: ----- UITableViewDelegate,UITableViewDataSource -----
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: twoCell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(twoCell.self), for: indexPath) as! twoCell
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: view.bounds, style: UITableView.Style.plain)
        tableView.register(twoCell.self, forCellReuseIdentifier: NSStringFromClass(twoCell.self))
        tableView.backgroundColor = UIColor.lightGray
        tableView.separatorStyle = .none
        tableView.separatorColor = UIColor.red
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "一"
        cn_navBarAlpha = 0.0
        cn_shadowHidden = true
        cn_navBarStyle = .black
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "测试", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        self.view.addSubview(tableView)
        automaticallyAdjustsScrollViewInset(scrollView: tableView)
//        automaticallyAdjustsScrollViewInset(scrollView: tableView)
        print(NSLocalizedString("Bundle name", comment: ""))
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return cn_statusBarStyle
    }
    
    deinit {
        print("\(self)-->deinit")
    }
}
