//
//  ContactUsVC.swift
//  Charu Industries
//
//  Created by iMac on 03/12/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

class ContactUsVC: UIViewController, AppNavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpNavigationBar()
    }
    
    //MARK:- NAVIGATION METHODS
    func setUpNavigationBar(){
        Obj_AppDelegate.navigationController.setCustomTitle("Contact Us")
        Obj_AppDelegate.navigationController.navigationDelegate = self
        Obj_AppDelegate.navigationController.setBack()
    }
    func appNavigationController_BackAction() {
        Obj_AppDelegate.navigationController.popViewController(animated: true)
    }
    
    @IBAction func openBtnAction(sender: UIButton){
        guard let url = URL(string: "https://www.google.com/maps/place/CHARU+INDUSTRIES/@21.2283224,72.8474066,14.75z/data=!4m5!3m4!1s0x0:0x397f8efc65816dc5!8m2!3d21.2286694!4d72.8441629") else {
          return //be safe
        }

        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }

}
