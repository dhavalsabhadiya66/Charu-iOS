//
//  LoginVC.swift
//  Charu Industries
//
//  Created by admin on 26/08/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit



class LoginVC: UIViewController, UITextFieldDelegate, AppNavigationControllerDelegate, JDSelectionDelegate {

    
    @IBOutlet weak var tfUserName: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfCompany: UITextField!
    @IBOutlet weak var tfYear: UITextField!
    @IBOutlet weak var btnLogIn: UIButton!
    @IBOutlet weak var btnShowHidePass: UIButton!
    
    
    fileprivate var arrCompList = [typeAliasDictionary]()
    fileprivate var arrSeleCompanys = [typeAliasDictionary]()
    fileprivate var arrYearList = [typeAliasDictionary]()
    fileprivate var arrSeleYears = [typeAliasDictionary]()
    
    var compCode = ""
    var yearCode = ""
    
    
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tfUserName.setLeftImage(UIImage(named: "ic_username")!.tinted(with: .darkGray))
        self.tfPassword.setLeftImage(UIImage(named: "ic_lock")!.tinted(with: .darkGray))
        self.tfCompany.setLeftImage(UIImage(named: "ic_company")!.tinted(with: .darkGray))
        self.tfYear.setLeftImage(UIImage(named: "ic_year")!.tinted(with: .darkGray))
        btnShowHidePass.setImage(UIImage(named: "ic_show_pass"), for: .normal)
        btnShowHidePass.setImage(UIImage(named: "ic_hide_pass"), for: .selected)
        btnShowHidePass.isSelected = false
        self.tfCompany.setRightImage(UIImage(named: "ic_drop_down")!.tinted(with: .darkGray))
        self.tfYear.setRightImage(UIImage(named: "ic_drop_down")!.tinted(with: .darkGray))
        self.tfYear.text = "2020-21"
//        self.tfUserName.text = "CHARUIND"
//        self.tfPassword.text = "a1atoz11"
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpNavigationBar()
        getCompList()
    }
    
    
    //MARK:- NAVIGATION METHODS
    func setUpNavigationBar(){
        Obj_AppDelegate.navigationController.setCustomTitle("")
        Obj_AppDelegate.navigationController.navigationDelegate = self
    }
    
    
    //MARK:- CUSTOME METHODS
    func getCompList(){
        DesignModel.startActivityIndicator()
        let parameters = [REQ_KEY.CompCode: "",
                          REQ_KEY.CompGrpCode: "",
                          REQ_KEY.ShortName: "",
                          REQ_KEY.Status: ""]
        Obj_OperationApi.callWebService(ApiMethod.CompanyList, method: .post, parameters: parameters, onCompletion: { (responce) in
            if let arrComp = responce[RES_KEY.Data] as? [typeAliasDictionary]{
                self.arrCompList = arrComp
                if(arrComp.count > 0){
                    let arr = arrComp.first
                    self.tfCompany.text = arr!.isKeyNull(RES_KEY.Comp_Name) ? "":"\(arr![RES_KEY.Comp_Name]!)"
                    self.compCode = arr!.isKeyNull(RES_KEY.Comp_Code) ? "":"\(arr![RES_KEY.Comp_Code]!)"
                }
                
            }else {
                DesignModel.showMessage("\(responce[RES_KEY.Message] ?? MSG_ERR_SOMETING_WRONG as AnyObject)", for: self)
            }
            self.getYearList()
        }) { (errStr) in
            DesignModel.showMessage(errStr, for: self)
        }
    }
    func getYearList(){
        DesignModel.startActivityIndicator()
        let parameters = [REQ_KEY.YearCode: ""]
        Obj_OperationApi.callWebService(ApiMethod.YearList, method: .post, parameters: parameters, onCompletion: { (responce) in
            if let arrYear = responce[RES_KEY.Data] as? [typeAliasDictionary]{
                self.arrYearList = arrYear
                if(self.arrYearList.count > 0){
                    for data in self.arrYearList{
                        let yearName = "\(data[RES_KEY.Year_Name] ?? "" as AnyObject)"
                        if(yearName == "2020-21"){
                           let yearCode = "\(data[RES_KEY.Year_Code] ?? "" as AnyObject)"
                            self.yearCode = yearCode
                        }
                    }
                }
            }else {
                DesignModel.showMessage("\(responce[RES_KEY.Message] ?? MSG_ERR_SOMETING_WRONG as AnyObject)", for: self)
            }
        }) { (errStr) in
            DesignModel.showMessage(errStr, for: self)
        }
    }
    func showSelection(_ title: String, array: [typeAliasDictionary], arrSelected: [typeAliasDictionary], dictKey: typeAliasDictionary, inputType: INPUT_TYPE, notAvailableMessage: String, selectionType: SELECTION_TYPE) {
        if array.count == 0 {
            DesignModel.showMessage(notAvailableMessage, for: self)
            return
        }
        var isAbleSearch = false
        if array.count > 5 { isAbleSearch = true }
        let _JDSelection = JDSelection.init(title: title, selectionType: selectionType, listArray: array, selectedArray: arrSelected, keyDictionary: dictKey, inputType: inputType, isSelectionCompulsory: true, contentFrame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(self.view.frame.width * 0.75), height: CGFloat(self.view.frame.height * 0.5)), isPaginationExist: isAbleSearch, isRemoveOnDoneClick: true)
        _JDSelection.delegate = self
        Obj_AppDelegate.navigationController.view.addSubview(_JDSelection)
    }
    
    
    //MARK:- TEXTFIELD METHODS
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.tfCompany{
            let keys = [JD_UNIQUE_KEY: RES_KEY.Comp_Code,
                        JD_VALUE_KEY: RES_KEY.Comp_Name] as typeAliasDictionary
            self.showSelection("Select Company", array: self.arrCompList, arrSelected: self.arrSeleCompanys, dictKey: keys, inputType: .COMPANY, notAvailableMessage: "No Comapany Found!!", selectionType: .SINGLE)
           return false
        }else if textField == self.tfYear {
            let keys = [JD_UNIQUE_KEY: RES_KEY.Year_Code,
                        JD_VALUE_KEY: RES_KEY.Year_Name] as typeAliasDictionary
            self.showSelection("Select Year", array: self.arrYearList, arrSelected: self.arrSeleYears, dictKey: keys, inputType: .YEAR, notAvailableMessage: "No Year Found", selectionType: .SINGLE)
            return false
        }
        return true
    }
    
    
    //MARK:- SELECTION DELEGATE
    func selectedOption(arrSelected: [typeAliasDictionary], inputType: INPUT_TYPE) {
        let arr = arrSelected.first
        if inputType == .COMPANY{
            self.arrSeleCompanys = arrSelected
            if arrSelected.count > 0{
                self.tfCompany.text = arr!.isKeyNull(RES_KEY.Comp_Name) ? "-":"\(arr![RES_KEY.Comp_Name]!)"
            }else {
                self.tfCompany.text = ""
            }
        }else if inputType == .YEAR{
            self.arrSeleYears = arrSelected
            if arrSelected.count > 0{
                self.tfYear.text = arr!.isKeyNull(RES_KEY.Year_Name) ? "-":"\(arr![RES_KEY.Year_Name]!)"
            }else {
                self.tfYear.text = ""
            }
        }
    }
    
    
    //MARK:- BUTTON ACTION
    @IBAction func passShowHideAction(_ sender: UIButton){
        if sender.isSelected{
            sender.setImage(UIImage(named: "ic_show_pass")?.tinted(with: COLOR_PRIME_BLUE), for: .normal)
            tfPassword.isSecureTextEntry = true
            sender.isSelected = false
        }else {
            sender.setImage(UIImage(named: "ic_hide_pass")?.tinted(with: COLOR_PRIME_BLUE), for: .selected)
            tfPassword.isSecureTextEntry = false
            sender.isSelected = true
        }
    }
    @IBAction func loginBtnAction(_ sender: UIButton){
        self.view.endEditing(true)
        if self.tfUserName.text?.trim() == ""{
            DesignModel.showMessage("Please enter user name", for: self)
        }else if self.tfPassword.text?.trim() == ""{
            DesignModel.showMessage("Please enter password", for: self)
        }
//        else if self.arrSeleCompanys.count < 1{
//            DesignModel.showMessage("Please select company.", for: self)
//        }
//        else if self.arrSeleYears.count < 1{
//            DesignModel.showMessage("Please select year.", for: self)
//        }
        else {
            DesignModel.startActivityIndicator()
            if(self.arrSeleCompanys.count > 0){
                compCode = "\(self.arrSeleCompanys.first![RES_KEY.Comp_Code] ?? "" as AnyObject)"
            }
            let param = [REQ_KEY.UserName: self.tfUserName.text!.trim(),
                         REQ_KEY.Password: self.tfPassword.text!.trim(),
                         REQ_KEY.UDID: GetSetModel.getUDID(),
                         REQ_KEY.DeviceType: KEY_DeviceType,
                         REQ_KEY.CompCode: compCode]
            Obj_OperationApi.callWebService(ApiMethod.CheckLogin, method: .post, parameters: param, onCompletion: { (responce) in
                print(responce)
                if let arrData = responce[RES_KEY.Data] as? [typeAliasDictionary], var userInfo = arrData.first{
                    if(self.yearCode == ""){
                        let yearDict = self.arrSeleYears.first!
                        for (key, Val) in yearDict{
                            userInfo.updateValue(Val, forKey: key)
                        }
                        self.yearCode = "\(yearDict[RES_KEY.Year_Code] ?? "" as AnyObject)"
                    }else{
                        userInfo.updateValue(self.yearCode as AnyObject, forKey: RES_KEY.Year_Code)
                    }
                    userInfo.updateValue("01-04-2020" as AnyObject, forKey: RES_KEY.From_Date)
                    userInfo.updateValue("31-03-2021" as AnyObject, forKey: RES_KEY.To_Date)
                    GetSetModel.setYearCode(self.yearCode)
                    GetSetModel.setUserInfo(userInfo)
                    GetSetModel.setIsLoggedIn(true)
                    GetSetModel.setPassword(self.tfPassword.text!)
                    Obj_AppDelegate.showDashboard()
                }else {
                    DesignModel.showMessage(MSG_ERR_SOMETING_WRONG, for: self)
                }
            }) { (errStr) in
                DesignModel.showMessage(errStr, for: self)
            }
        }
    }
}
