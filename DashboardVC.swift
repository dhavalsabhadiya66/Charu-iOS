//
//  DashboardVC.swift
//  Charu Industries
//
//  Created by admin on 26/08/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

class DashboardVC: UIViewController {

    @IBOutlet weak var lblWelcome: UILabel!
    @IBOutlet weak var btnLogout: UIButton!
    let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    let mainStory = UIStoryboard(name: "Main", bundle: nil)
    
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        perform(#selector(self.fadeAnimation), with: nil, afterDelay: 1)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.setUpNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    
    //MARK:- NAVIGATION METHODS
    func setUpNavigationBar(){
        btnLogout.setImage(UIImage(named: "ic_logout")?.tinted(with: .white), for: .normal)
    }
    
    @objc func fadeAnimation(){
       UIView.animate(withDuration: 1.0, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.lblWelcome.alpha = 0.0
        }, completion: {
            (finished: Bool) -> Void in
            // Fade in
            UIView.animate(withDuration: 1.0, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                self.lblWelcome.alpha = 1.0
            }, completion: nil)
        })
        perform(#selector(self.fadeAnimation), with: nil, afterDelay: 2)
    }
    
    //MARK:- ACTION
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
    
    @IBAction func ledgerBtnAction(sender: UIButton){
        let ladgerVC = mainStory.instantiateViewController(withIdentifier: "LadgerReportVC") as! LadgerReportVC
        obj_AppDelegate.navigationController.pushViewController(ladgerVC, animated: true)
    }
    
    @IBAction func bookBtnAction(sender: UIButton){
        let bookReport = mainStory.instantiateViewController(withIdentifier: "BookReportVC") as! BookReportVC
        obj_AppDelegate.navigationController.pushViewController(bookReport, animated: true)
    }
    
    @IBAction func stockBtnAction(sender: UIButton){
        let stockReport = mainStory.instantiateViewController(withIdentifier: "StockReportVC") as! StockReportVC
        obj_AppDelegate.navigationController.pushViewController(stockReport, animated: true)
    }
    
    @IBAction func stockHistoryBtnAction(sender: UIButton){
        let stockHistoryReport = mainStory.instantiateViewController(withIdentifier: "StockHistoryVC") as! StockHistoryVC
        obj_AppDelegate.navigationController.pushViewController(stockHistoryReport, animated: true)
    }
    
    @IBAction func salesBtnAction(sender: UIButton){
        let salesVC = mainStory.instantiateViewController(withIdentifier: "SalesReportVC") as! SalesReportVC
        obj_AppDelegate.navigationController.pushViewController(salesVC, animated: true)
    }
    
    @IBAction func purchaseBtnAction(sender: UIButton){
        let purchaseVC = mainStory.instantiateViewController(withIdentifier: "PurchaseReportVC") as! PurchaseReportVC
        obj_AppDelegate.navigationController.pushViewController(purchaseVC, animated: true)
    }
    
    @IBAction func targetBtnAction(sender: UIButton){
        let targetVC = mainStory.instantiateViewController(withIdentifier: "TargetReportVC") as! TargetReportVC
        obj_AppDelegate.navigationController.pushViewController(targetVC, animated: true)
    }
    
    @IBAction func registerBtnAction(sender: UIButton){
        let registerReportVC = mainStory.instantiateViewController(withIdentifier: "RegisterReportVC") as! RegisterReportVC
        obj_AppDelegate.navigationController.pushViewController(registerReportVC, animated: true)
    }
    
    @IBAction func transBalanceBtnAction(sender: UIButton){
        let transactionClosingVC = mainStory.instantiateViewController(withIdentifier: "TransactionClosingReportVC") as! TransactionClosingReportVC
        obj_AppDelegate.navigationController.pushViewController(transactionClosingVC, animated: true)
    }
    
    @IBAction func contactUsBtnAction(sender: UIButton){
        let contactUsVC = mainStory.instantiateViewController(withIdentifier: "ContactUsVC") as! ContactUsVC
        obj_AppDelegate.navigationController.pushViewController(contactUsVC, animated: true)
    }
    
    @IBAction func profileBtnAction(sender: UIButton){
        let profileVC = mainStory.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        obj_AppDelegate.navigationController.pushViewController(profileVC, animated: true)
    }
}
