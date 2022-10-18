//
//  JD_SideMenu.swift
//  Sparkle
//
//  Created by pcmac on 22/03/18.
//  Copyright © 2018 BrainWaves. All rights reserved.
//

import UIKit
import SDWebImage


class JD_SideMenu: UIView, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    
    //MARK: CONSTANT
    internal let TAG_SUPPER: Int = 10000
    let SELECTION_SUPER_VIEW_TAG            = 10001
    let SELECTION_SUB_VIEW_TAG              = 110001
    
    let COLOUR_BG                           = RGBCOLOR(255, g: 255, b: 255)
    let COLOUR_BLACK_TRANSPARENT            = RGBCOLOR(0, g: 0, b: 0, alpha: 0.4)
    
    let TAG_TITLE                           = 1001
    let TAG_IMAGE                           = 1000
    let TAG_SUB_TITLE                       = 1003
    let TAG_SUB_IMAGE                       = 1004
    
    let TAG_ICON                             = 100
    let TEXT_SUB: CGFloat                    = 14
    let TEXT_MAIN: CGFloat                   = 14
    let IS_EXAPANDABLE: String               = "IS_EXAPANDABLE"
    let IS_EXPANDED: String                  = "IS_EXPANDED"
    
    //MARK: PROPERTIES
    @IBOutlet var ViewBG: UIView!
    @IBOutlet var tableViewList: UITableView!
    @IBOutlet var imageViewUser: UIImageView!
    @IBOutlet var lblUsername: UILabel!
    @IBOutlet weak var viewUserDetailInner: UIView!
    
    //Accouny Selection
    @IBOutlet var viewAccountBook: UIView!
    @IBOutlet var viewAccountBookInnerCollection: [UIView]!
    
    //MARK: VARIABLES
    let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    let userInfo = GetSetModel.getUserInfo()
    let mainStory = UIStoryboard(name: "Main", bundle: nil)
    var width:CGFloat = 0
    fileprivate var _JD_Popover = JD_PopOver()
    var arrList = [String]()
    var arrSections = NSIndexSet()
    var constrintLeading:NSLayoutConstraint!
    var selectedSection:Int = -1
    var selectedRow:Int = -1
    var isSubChild:Bool = false
    
    
    var SubCount:Int = 0
    var counter:Int = 0

    required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
    }
    
    private func loadXIB(){
        let view = Bundle.main.loadNibNamed(String(describing: type (of: self)), owner: self, options: nil)?[0] as! UIView
        view.translatesAutoresizingMaskIntoConstraints = false
        self.tableViewList.tableFooterView = UIView(frame: CGRect.zero)
        self.addSubview(view)
        self.layoutIfNeeded()
    }
    
    override init(frame :CGRect){
        super.init(frame: frame)
        self.loadXIB()
        let frame:CGRect = UIScreen.main.bounds
        self.frame = frame
        self.backgroundColor = RGBCOLOR(0, g: 0, b: 0, alpha: 0.4)
        self.loadData()
        let gestureTap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideMenuAction))
        self.isUserInteractionEnabled = true
        self.isMultipleTouchEnabled = true
        self.tag = SELECTION_SUPER_VIEW_TAG
        gestureTap.delegate = self
        self.addGestureRecognizer(gestureTap)
        width = frame.width * 0.8
        let dict:typeAliasDictionary = DesignModel.setConstraint_Leading_Top_ConWidth_ConHeight(subView: ViewBG, superView: self, leading: -width, top: 0, width: width, height: self.frame.height)
        
        constrintLeading = dict[CONSTRAINT_LEADING] as? NSLayoutConstraint
        self.alpha = 1
        DesignModel.setBottomBorderView(viewUserDetailInner, borderColor: .lightGray, borderWidth: 1.5)
        self.imageViewUser.image = UIImage(named: "img_charu")
        lblUsername.text = userInfo.isKeyNull(RES_KEY.UserName) ? "":"\(userInfo[RES_KEY.UserName]!)"
//        let imgLink = userInfo.isKeyNull(RES_MemberProfile) ? "":"\(userInfo[RES_MemberProfile]!)"
//        self.imageViewUser.sd_setImage(with: URL(string: imgLink), placeholderImage: UIImage(named: "img_user"), options: .highPriority, context: nil)
        self.imageViewUser.cornerRadius = self.imageViewUser.frame.height/2
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIView.AnimationOptions.beginFromCurrentState, animations: {() -> Void in
            self.alpha = 1
        }, completion: {(finished: Bool) -> Void in
            self.constrintLeading.constant = 0
            UIView.animate(withDuration: 0.3, delay: 0.0, options: UIView.AnimationOptions.beginFromCurrentState, animations: {() -> Void in
                self.layoutIfNeeded()
            }, completion: nil)
        })
    }
    internal func loadData() {
        
        arrList = ["Home", "Ladger", "Book Report", "Stock Report", "Stock History Report", "Sales Report", "Purchase Report", "Target Report", "Register Report", "Trans. Closing Trail Balance"]
        tableViewList.register(UINib.init(nibName: "SideMenuCell", bundle: nil), forCellReuseIdentifier: "SideMenuCell")
        tableViewList.tableFooterView = UIView(frame: CGRect.zero)
        tableViewList.rowHeight = 45
        tableViewList.bounces = false
        tableViewList.reloadData()
        tableViewList.allowsSelection = true
        
    }
    
    @objc internal func hideMenuAction() {
        constrintLeading.constant = -width
        UIView.animate(withDuration: 0.3, delay: 0.0, options:UIView.AnimationOptions.beginFromCurrentState, animations: {() -> Void in
            self.layoutIfNeeded()
        }, completion: {(finished: Bool) -> Void in
            UIView.animate(withDuration: 0.3, delay: 0.0, options:UIView.AnimationOptions.beginFromCurrentState, animations: {() -> Void in
                self.alpha = 0
            }, completion: {(finished: Bool) -> Void in
                self.removeFromSuperview()
                self.layer.removeAllAnimations()
            })
        })
    }
    
    //MARK: UI GESTURE RRECOGNIZER
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let view: UIView = touch.view!
        let viewTag: Int = Int(view.tag)
        print("Touch View Tag : \(viewTag)")
        if viewTag != SELECTION_SUPER_VIEW_TAG{
            return false
        }
        return true
    }
    
    //MARK: TABLE VIEW DATA SOURCE
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SideMenuCell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCell") as! SideMenuCell
        let str : String = self.arrList[indexPath.row]
        cell.lblTittle.text = str
//        if str == "Home" { cell.imgMainImage.image = UIImage(named: "ic_home") }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    //MARK: TABLE VIEW DELEGATE
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let str : String = self.arrList[indexPath.row]
        if str == "Home" { obj_AppDelegate.showDashboard() }
        else if str == "Ladger" { self.showLadgerReport() }
        else if str == "Book Report" { self.showBookReport() }
        else if str == "Stock Report" { self.showStockReport() }
        else if str == "Stock History Report" { self.showStockHistoryReport() }
        else if str == "Sales Report" { self.showSalesReport() }
        else if str == "Purchase Report" { self.showPurchaseReport() }
        else if str == "Target Report" { self.showTargetReport() }
        else if str == "Register Report" { self.showRegisterReport() }
        else if str == "Trans. Closing Trail Balance" { self.showTRansactionClosingTrailBalance() }
        self.hideMenuAction()
    }
    
    
    //MARK:- BUTTON ACTION
    @IBAction func logOutBtnAction(_ sender: UIButton) {
        let alert = JD_ActionAlertView()
        let dashBoard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
        let curruntVC = obj_AppDelegate.navigationController.viewControllers.last ?? dashBoard
        alert.showYesNoAlertView("Are you sure you want to logout??", for: curruntVC, isYesDestructive: true, YesAction: {
            self.hideMenuAction()
            GetSetModel.setUserInfo(typeAliasDictionary())
            GetSetModel.setIsLoggedIn(false)
            self.obj_AppDelegate.showLogInVC()
        }, NoAction: nil)
    }
    @IBAction func profileBtnAction(_ sender: UIButton){
        self.hideMenuAction()
//        let profileVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserProfileVC") as! UserProfileVC
//        self.obj_AppDelegate.navigationController.pushViewController(profileVC, animated: true)
    }
    
    
    //MARK:- CUSTOME METHODS
    func showLadgerReport(){
        let ladgerVC = mainStory.instantiateViewController(withIdentifier: "LadgerReportVC") as! LadgerReportVC
        obj_AppDelegate.navigationController.pushViewController(ladgerVC, animated: true)
    }
    func showBookReport(){
        let bookReport = mainStory.instantiateViewController(withIdentifier: "BookReportVC") as! BookReportVC
        obj_AppDelegate.navigationController.pushViewController(bookReport, animated: true)
    }
    func showStockReport(){
        let stockReport = mainStory.instantiateViewController(withIdentifier: "StockReportVC") as! StockReportVC
        obj_AppDelegate.navigationController.pushViewController(stockReport, animated: true)
    }
    func showStockHistoryReport(){
        let stockHistoryReport = mainStory.instantiateViewController(withIdentifier: "StockHistoryVC") as! StockHistoryVC
        obj_AppDelegate.navigationController.pushViewController(stockHistoryReport, animated: true)
    }
    func showSalesReport(){
        let salesVC = mainStory.instantiateViewController(withIdentifier: "SalesReportVC") as! SalesReportVC
        obj_AppDelegate.navigationController.pushViewController(salesVC, animated: true)
    }
    func showPurchaseReport(){
        let purchaseVC = mainStory.instantiateViewController(withIdentifier: "PurchaseReportVC") as! PurchaseReportVC
        obj_AppDelegate.navigationController.pushViewController(purchaseVC, animated: true)
    }
    func showTargetReport(){
        let targetVC = mainStory.instantiateViewController(withIdentifier: "TargetReportVC") as! TargetReportVC
        obj_AppDelegate.navigationController.pushViewController(targetVC, animated: true)
    }
    func showRegisterReport(){
        let registerReportVC = mainStory.instantiateViewController(withIdentifier: "RegisterReportVC") as! RegisterReportVC
        obj_AppDelegate.navigationController.pushViewController(registerReportVC, animated: true)
    }
    func showTRansactionClosingTrailBalance(){
//        let transactionClosingVC = mainStory.instantiateViewController(withIdentifier: "TransactionClosingReportVC") as! TransactionClosingReportVC
//        obj_AppDelegate.navigationController.pushViewController(transactionClosingVC, animated: true)
        
        let transactionClosingVC = mainStory.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        obj_AppDelegate.navigationController.pushViewController(transactionClosingVC, animated: true)
    }
}
