//
//  AppNavigationControllerViewController.swift
//  Sparkle
//
//  Created by pcmac on 21/03/18.
//  Copyright © 2018 BrainWaves. All rights reserved.
//

import UIKit

@objc protocol AppNavigationControllerDelegate {
    @objc optional func appNavigationController_RightMenuAction()
    @objc optional func appNavigationController_BackAction()
//    @objc optional func appNavigationController_SideMenuAction()
    @objc optional func appNavigationController_MoreMenuAction()
    @objc optional func appNavigationController_ChatAction()
}

extension UINavigationController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

class AppNavigationController: UINavigationController {
    
    //MARK: PROPERTIES
    var navigationDelegate: AppNavigationControllerDelegate!
    fileprivate var obj_AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var lblTitle: UILabel!
    var imageTitle: UIImageView!
    var lblTitleLandscape: UILabel!
    var lblSubTitle: UILabel!
    var btnListGrid: UIButton! = nil
    var btnMore: UIButton!
    var btnRightMenu: UIButton!
    var viewSubTitleViewPotrait: UIView!

    //MARK: VARIABLE
    var frameTitleView = CGRect.zero
    var btnWidth = CGFloat()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.barTintColor = COLOUR_NAV
        self.navigationBar.isTranslucent = false
        self.navigationBar.tintColor = .black
//        UIApplication.shared.statusBarView?.backgroundColor = RGBCOLOR(162, g: 176, b: 200)

        let dict = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 22),
                    NSAttributedString.Key.foregroundColor :UIColor.white]
        self.navigationBar.titleTextAttributes = dict
        
        btnWidth = 30;
        frameTitleView = CGRect(x: btnWidth, y: 0, width: self.navigationBar.frame.width - (btnWidth * 3) - 10, height: self.navigationBar.frame.height)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var shouldAutorotate: Bool {
        return self.viewControllers.last!.shouldAutorotate
    }
    
    internal func setCustomTitle(_ title: String) {
        let viewController: UIViewController = self.viewControllers.last!
        self.lblTitle = UILabel(frame: frameTitleView)
        self.lblTitle.textColor = UIColor.white
        self.lblTitle.text = title
        self.lblTitle.font = UIFont.systemFont(ofSize: 23, weight: .semibold)
        self.lblTitle.textAlignment = .center
        self.lblTitle.numberOfLines = 0
        viewController.navigationItem.titleView = self.lblTitle
    }
    
    internal func setSubTitlePotrait(_ mainTitle: String, subTitle: String) {
        let fontSize: CGFloat = 25
        let viewController = self.viewControllers.last!
        //self.viewSubTitleViewPotrait.removeFromSuperview()
        
        //Title View
        self.viewSubTitleViewPotrait = UIView(frame: frameTitleView)
        
        //Main
        self.lblTitle = UILabel(frame: CGRect(x: 0, y: 0, width: frameTitleView.width - 8 , height: 20))
        self.lblTitle.textColor = UIColor.white
        self.lblTitle.text = mainTitle
        self.lblTitle.font = UIFont.systemFont(ofSize: fontSize)
        self.lblTitle.textAlignment = .center
        self.lblTitle.numberOfLines = 0
        self.viewSubTitleViewPotrait.addSubview(self.lblTitle)
        
        //Record Label
        self.lblSubTitle = UILabel(frame: CGRect(x: 0, y: self.lblTitle.frame.maxY, width: frameTitleView.width, height: 20))
        self.lblSubTitle.textColor = UIColor.white
        self.lblSubTitle.text = subTitle
        self.lblSubTitle.textAlignment = .center
        self.lblSubTitle.font = UIFont.systemFont(ofSize: fontSize)
        self.lblSubTitle.backgroundColor = UIColor.clear
        self.viewSubTitleViewPotrait.addSubview(self.lblSubTitle)
        viewController.navigationItem.titleView = self.viewSubTitleViewPotrait
    }
    
    internal func setBack() {
        let viewController = self.viewControllers.last!
        let btnBack = self.createImageButton("ic_nav_back")
        btnBack.addTarget(self, action: #selector(self.btnBackAction), for: .touchUpInside)
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnBack)
    }
    
    internal func setSideMenu() {
        let viewController = self.viewControllers.last!
        let btnSideMenu = self.createImageButton("ic_nav_menu")
        btnSideMenu.addTarget(self, action: #selector(self.btnSideMenuAction), for: .touchUpInside)
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnSideMenu)
    }
    internal func setCustomTitleWithImage(_ img: UIImage) {
        
        let viewBar = UIView(frame: frameTitleView)
        let viewController: UIViewController = self.viewControllers.last!
        let imagePic = UIImageView(image:img)
        imagePic.frame = CGRect(x: btnWidth, y: viewBar.frame.minY + 5, width: viewBar.frame.width - btnWidth, height: viewBar.frame.height)
        imagePic.contentMode = UIView.ContentMode.center
        imagePic.clipsToBounds = true
        DesignModel.setViewBorder(imagePic, borderColor: .clear, borderWidth: 0, isShadow: false, cornerRadius: 0, backColor: .clear)
        viewBar.addSubview(imagePic)
        viewController.navigationItem.titleView = viewBar
    }
    
    internal func setRightMenu(_ Image : UIImage) {
        let viewController: UIViewController = self.viewControllers.last!
        
        btnRightMenu = DesignModel.createImageButton(CGRect(x: 0, y: 0, width: 30, height: 30), image: Image, tag: 0)
        btnRightMenu.imageView?.tintColor = UIColor.white
        btnRightMenu.addTarget(self, action: #selector(btnRightMenuAction), for: UIControl.Event.touchUpInside)
        viewController.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: btnRightMenu)
    }
    
    internal func setSideMenuWithBack() {
        
        let viewController: UIViewController = self.viewControllers.last!
        let leftNavView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        let btnBack: UIButton = DesignModel.createImageButton(CGRect(x: 0, y: 0, width: 30, height: 30), image: #imageLiteral(resourceName: "icon_back"), tag: 0)
        let _ = btnBack.layer.borderWidth.advanced(by: 1)
        btnBack.addTarget(self, action: #selector(btnBackAction), for: UIControl.Event.touchUpInside)
        leftNavView.addSubview(btnBack)
        
        let btnSideMenu: UIButton = DesignModel.createImageButton(CGRect(x: btnBack.frame.maxX + 5, y: 0, width: 30, height: 30), image: #imageLiteral(resourceName: "icon_back"), tag: 0)
        let _ = btnSideMenu.layer.borderWidth.advanced(by: 1)
        btnSideMenu.addTarget(self, action: #selector(btnSideMenuAction), for: UIControl.Event.touchUpInside)
        leftNavView.addSubview(btnSideMenu)
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: leftNavView)
    }
    
    
    internal func setLeftCancel() {
        let viewController = self.viewControllers.last!
        let btnBack = self.createImageButton("icon_close")
        btnBack.addTarget(self, action: #selector(self.btnBackAction), for: .touchUpInside)
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnBack)
    }
    
    internal func createImageButton(_ imageName: String) -> UIButton {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: btnWidth, height: btnWidth)
        button.setImage(UIImage(named: imageName)!.tinted(with: .white), for: .normal)
        button.showsTouchWhenHighlighted = false
        return button
    }
    
    @objc internal func btnBackAction() {
        self.navigationDelegate.appNavigationController_BackAction!()
    }
    @objc internal func btnSideMenuAction() {
        let sideMenu = JD_SideMenu()
        Obj_AppDelegate.navigationController.view.addSubview(sideMenu)
    }
    @objc internal func btnChatAction() {
        self.navigationDelegate.appNavigationController_ChatAction!()
    }
    @objc internal func btnRightMenuAction() {
        self.navigationDelegate.appNavigationController_RightMenuAction!()
    }
}
