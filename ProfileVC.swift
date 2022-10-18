//
//  ProfileVC.swift
//  Charu Industries
//
//  Created by iMac on 03/12/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController, AppNavigationControllerDelegate {
    
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblMobile: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblPassword: UILabel!
    
    let userInfo = GetSetModel.getUserInfo()
    let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpNavigationBar()
        
        lblUserName.text = userInfo.isKeyNull(RES_KEY.UserName) ? "":"\(userInfo[RES_KEY.UserName]!)"
        lblEmail.text = userInfo.isKeyNull(RES_KEY.Email) ? "":"\(userInfo[RES_KEY.Email]!)"
        lblMobile.text = userInfo.isKeyNull(RES_KEY.Mobile) ? "":"+91 \(userInfo[RES_KEY.Mobile]!)"
        lblAddress.text = userInfo.isKeyNull(RES_KEY.Address) ? "":"\(userInfo[RES_KEY.Address]!)"
        lblPassword.text = GetSetModel.getPassword()
        
    }
    
    //MARK:- NAVIGATION METHODS
    func setUpNavigationBar(){
        Obj_AppDelegate.navigationController.setCustomTitle("User Profile")
        Obj_AppDelegate.navigationController.navigationDelegate = self
        Obj_AppDelegate.navigationController.setBack()
    }
    func appNavigationController_BackAction() {
        Obj_AppDelegate.navigationController.popViewController(animated: true)
    }
    
    @IBAction func logoutBtnAction(sender: UIButton){
        let alert = JD_ActionAlertView()
        let dashBoard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
        let curruntVC = obj_AppDelegate.navigationController.viewControllers.last ?? dashBoard
        alert.showYesNoAlertView("Are you sure you want to logout??", for: curruntVC, isYesDestructive: true, YesAction: {
            GetSetModel.setUserInfo(typeAliasDictionary())
            GetSetModel.setIsLoggedIn(false)
            self.obj_AppDelegate.showLogInVC()
        }, NoAction: nil)
    }

}
