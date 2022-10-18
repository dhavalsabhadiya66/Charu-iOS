//
//  RegisterReportVC.swift
//  Charu Industries
//
//  Created by iMac on 01/12/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

class RegisterReportVC: UIViewController, UITextFieldDelegate, JDSelectionDelegate, AppNavigationControllerDelegate {

    @IBOutlet weak var tfFromDate: UITextField!
    @IBOutlet weak var tfToDate: UITextField!
    @IBOutlet weak var tfType: UITextField!
    @IBOutlet weak var tfPartyName: UITextField!
    @IBOutlet weak var tfBookName: UITextField!
    @IBOutlet weak var btnReport: UIButton!
    @IBOutlet weak var btnClear: UIButton!
    
    fileprivate let userInfo = GetSetModel.getUserInfo()
    fileprivate let dateFormatter = DateFormatter()
    fileprivate let datePicker = UIDatePicker()
    fileprivate var arrBookName = [typeAliasDictionary]()
    fileprivate var arrSeleBookName = [typeAliasDictionary]()
    fileprivate var arrPartyName = [typeAliasDictionary]()
    fileprivate var arrSelePartyName = [typeAliasDictionary]()
    fileprivate var arrType = [typeAliasDictionary]()
    fileprivate var arrSeleType = [typeAliasDictionary]()
    fileprivate var arrReport = [typeAliasDictionary]()
    
    let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    let mainStory = UIStoryboard(name: "Main", bundle: nil)
    var isType = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.calendar = Calendar.current
        datePicker.datePickerMode = .date
        datePicker.timeZone = Calendar.current.timeZone
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        dateFormatter.calendar = Calendar.current
        dateFormatter.timeZone = Calendar.current.timeZone
        self.tfFromDate.inputView = datePicker
        self.tfToDate.inputView = datePicker
        self.tfFromDate.setRightImage(UIImage(named: "ic_drop_down")!.tinted(with: .darkGray))
        self.tfToDate.setRightImage(UIImage(named: "ic_drop_down")!.tinted(with: .darkGray))
        self.tfType.setRightImage(UIImage(named: "ic_drop_down")!.tinted(with: .darkGray))
        self.tfPartyName.setRightImage(UIImage(named: "ic_drop_down")!.tinted(with: .darkGray))
        self.tfBookName.setRightImage(UIImage(named: "ic_drop_down")!.tinted(with: .darkGray))
        
        self.arrType.append([RES_KEY.TYPE_CODE: "2" as AnyObject,RES_KEY.TYPE_NAME : "SALES REGISTER" as AnyObject,RES_KEY.TYPE_CAP : "S" as AnyObject])
        self.arrType.append([RES_KEY.TYPE_CODE: "1" as AnyObject,RES_KEY.TYPE_NAME : "PURCHASE REGISTER" as AnyObject,RES_KEY.TYPE_CAP : "P" as AnyObject])
        self.arrType.append([RES_KEY.TYPE_CODE: "10" as AnyObject,RES_KEY.TYPE_NAME : "PURCHASE RETURN REGISTER" as AnyObject,RES_KEY.TYPE_CAP : "PR" as AnyObject])
        self.arrType.append([RES_KEY.TYPE_CODE: "5" as AnyObject,RES_KEY.TYPE_NAME : "SALES RETURN REGISTER" as AnyObject,RES_KEY.TYPE_CAP : "SR" as AnyObject])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        dateFormatter.dateFormat = "dd-MM-yyyy"
//        let fromDate = dateFormatter.date(from: "\(userInfo[RES_KEY.From_Date] ?? "" as AnyObject)") ?? Date()
//        let toDate = dateFormatter.date(from: "\(userInfo[RES_KEY.To_Date] ?? "" as AnyObject)") ?? Date()
//        dateFormatter.dateFormat = "dd-MMM-yyyy"
//        self.tfFromDate.text = dateFormatter.string(from: fromDate)
//        self.tfToDate.text = dateFormatter.string(from: toDate)
        self.tfFromDate.text = "\(userInfo[RES_KEY.From_Date] ?? "" as AnyObject)"
        self.tfToDate.text = dateFormatter.string(from: Date())
        setUpNavigationBar()
//        getTypeList()
//        getBookList()
        getPartyList()
    }
    
    //MARK:- NAVIGATION METHODS
    func setUpNavigationBar(){
        Obj_AppDelegate.navigationController.setCustomTitle("Register Report")
        Obj_AppDelegate.navigationController.navigationDelegate = self
        Obj_AppDelegate.navigationController.setBack()
//        Obj_AppDelegate.navigationController.setRightMenu(UIImage(named: "ic_nav_print")!.tinted(with: .white))
    }
    func appNavigationController_BackAction() {
        Obj_AppDelegate.navigationController.popViewController(animated: true)
    }
    
    //MARK:- CUSTOME METHODS
    
    func getTypeList(){
        let userInfo = GetSetModel.getUserInfo()
        //        DesignModel.startActivityIndicator()
        let param = [REQ_KEY.PartyCode: "",
                     REQ_KEY.CompCode: "\(userInfo[RES_KEY.CompCode] ?? "" as AnyObject)"]
        Obj_OperationApi.callWebService(ApiMethod.PartyMasList, method: .post, parameters: param, onCompletion: { (responce) in
            print(responce)
            self.arrType = responce[RES_KEY.Data] as? [typeAliasDictionary] ?? [typeAliasDictionary]()
        }) { (errStr) in
            DesignModel.showMessage(errStr, for: self)
        }
    }
    
    func getBookList(){
        let userInfo = GetSetModel.getUserInfo()
        //        DesignModel.startActivityIndicator()
        var proGrpCode = ""
        if let proGrpDict = self.arrSeleType.first{
            proGrpCode = String("\(proGrpDict[RES_KEY.TYPE_CAP] ?? "" as AnyObject)")
        }
        let param = [REQ_KEY.Register_Type: proGrpCode,
                     REQ_KEY.CompCode: "\(userInfo[RES_KEY.CompCode] ?? "" as AnyObject)"]
        Obj_OperationApi.callWebService(ApiMethod.RegisterTypeList, method: .post, parameters: param, onCompletion: { (responce) in
            print(responce)
            self.arrBookName = responce[RES_KEY.Data] as? [typeAliasDictionary] ?? [typeAliasDictionary]()
        }) { (errStr) in
            if(!self.isType){
                DesignModel.showMessage(errStr, for: self)
            }else{
                self.isType = false
            }
        }
    }
    
    func getPartyList(){
        let userInfo = GetSetModel.getUserInfo()
        DesignModel.startActivityIndicator()
        let param = [REQ_KEY.PartyCode: "",
        REQ_KEY.CompCode: "\(userInfo[RES_KEY.CompCode] ?? "" as AnyObject)"]
        Obj_OperationApi.callWebService(ApiMethod.PartyMasList, method: .post, parameters: param, onCompletion: { (responce) in
            print(responce)
            DesignModel.stopActivityIndicator()
            self.arrPartyName = responce[RES_KEY.Data] as? [typeAliasDictionary] ?? [typeAliasDictionary]()
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
    
    
    //MARK:- TEXTFIELD DELEGATE
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.tfBookName{
            let keys = [JD_UNIQUE_KEY: RES_KEY.Emp_Code,
                        JD_VALUE_KEY: RES_KEY.EmpName] as typeAliasDictionary
            self.showSelection("Select Book Name", array: self.arrBookName, arrSelected: self.arrSeleBookName, dictKey: keys, inputType: .BOOK, notAvailableMessage: "No book name found.", selectionType: .SINGLE)
            return false
        }else if textField == self.tfPartyName{
            let keys = [JD_UNIQUE_KEY: RES_KEY.Party_Code,
                        JD_VALUE_KEY: RES_KEY.Party_Name] as typeAliasDictionary
            self.showSelection("Select Party Name", array: self.arrPartyName, arrSelected: self.arrSelePartyName, dictKey: keys, inputType: .PARTY, notAvailableMessage: "No party name found.", selectionType: .SINGLE)
            return false
        }
        else if textField == self.tfType{
            let keys = [JD_UNIQUE_KEY: RES_KEY.TYPE_CODE,
                        JD_VALUE_KEY: RES_KEY.TYPE_NAME] as typeAliasDictionary
            self.showSelection("Select Type", array: self.arrType, arrSelected: self.arrSeleType, dictKey: keys, inputType: .TYPE, notAvailableMessage: "No type found.", selectionType: .SINGLE)
            return false
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.tfFromDate || textField == self.tfToDate{
            if textField.text?.trim() != ""{
                dateFormatter.dateFormat = "dd-MM-yyyy"
                self.datePicker.setDate(self.dateFormatter.date(from: textField.text!) ?? Date(), animated: true)
            }
        }
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField == self.tfFromDate || textField == self.tfToDate{
            dateFormatter.dateFormat = "dd-MM-yyyy"
            textField.text = self.dateFormatter.string(from: self.datePicker.date)
        }
        return true
    }
    
    //MARK:- SELECTION DELEGATE
    func selectedOption(arrSelected: [typeAliasDictionary], inputType: INPUT_TYPE) {
        let dict = arrSelected.first
        if inputType == .BOOK{
            self.arrSeleBookName = arrSelected
            if arrSelected.count > 0{
                self.tfBookName.text = dict!.isKeyNull(RES_KEY.EmpName) ? "-":"\(dict![RES_KEY.EmpName]!)"
            }else {
                self.tfBookName.text = ""
            }
        }else if inputType == .PARTY{
            self.arrSelePartyName = arrSelected
            if arrSelected.count > 0{
                self.tfPartyName.text = dict!.isKeyNull(RES_KEY.Party_Name) ? "-":"\(dict![RES_KEY.Party_Name]!)"
            }else {
                self.tfPartyName.text = ""
            }
        }else if inputType == .TYPE{
            self.arrSeleType = arrSelected
            if arrSelected.count > 0{
                self.tfType.text = dict!.isKeyNull(RES_KEY.TYPE_NAME) ? "-":"\(dict![RES_KEY.TYPE_NAME]!)"
            }else {
                self.tfType.text = ""
            }
            isType = true
            getBookList()
        }
    }
    
    //MARK:- Button Actions
    @IBAction func reportBtnAction(_ sender: UIButton){
        let registerDetailReportVC = mainStory.instantiateViewController(withIdentifier: "RegisterDetailReportVC") as! RegisterDetailReportVC
        registerDetailReportVC.arrSeleType = self.arrSeleType
        registerDetailReportVC.arrSeleBookName = self.arrSeleBookName
        registerDetailReportVC.arrSelePartyName = self.arrSelePartyName
        registerDetailReportVC.fromDate = self.tfFromDate.text!
        registerDetailReportVC.toDate = self.tfToDate.text!
        obj_AppDelegate.navigationController.pushViewController(registerDetailReportVC, animated: true)
    }
        
    @IBAction func clearBtnAction(_ sebder: UIButton){
        dateFormatter.dateFormat = "dd-MM-yyyy"
        self.tfFromDate.text = "\(self.userInfo[RES_KEY.From_Date] ?? "" as AnyObject)"
        self.tfToDate.text = dateFormatter.string(from: Date())
        self.tfType.text = ""
        self.tfBookName.text = ""
        self.tfPartyName.text = ""
        self.arrPartyName = [typeAliasDictionary]()
        self.arrBookName = [typeAliasDictionary]()
        self.arrType = [typeAliasDictionary]()
        self.arrSelePartyName = [typeAliasDictionary]()
        self.arrSeleBookName = [typeAliasDictionary]()
        self.arrSeleType = [typeAliasDictionary]()
        self.arrReport = [typeAliasDictionary]()
    }

}
