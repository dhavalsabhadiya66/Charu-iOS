//
//  BookReportVC.swift
//  Charu Industries
//
//  Created by admin on 31/08/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit


class BookReportCell: UITableViewCell {
    
    @IBOutlet weak var lblSerialNo: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblVoucherNo: UILabel!
    @IBOutlet weak var lblAccount: UILabel!
    @IBOutlet weak var lblDebit: UILabel!
    @IBOutlet weak var lblCredit: UILabel!
    @IBOutlet weak var lblBalanceAmt: UILabel!
    @IBOutlet weak var lblType: UILabel!
    
}


class BookReportVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, JDSelectionDelegate, AppNavigationControllerDelegate {
    
    
    @IBOutlet weak var tfFromDate: UITextField!
    @IBOutlet weak var tfToDate: UITextField!
    @IBOutlet weak var tfAccGroupList: UITextField!
    @IBOutlet weak var tfAccGrpDetList: UITextField!
    @IBOutlet weak var btnReport: UIButton!
    @IBOutlet weak var btnClear: UIButton!
    @IBOutlet weak var viewReportBG: UIView!
    @IBOutlet weak var tableReport: UITableView!
    
    fileprivate let userInfo = GetSetModel.getUserInfo()
    fileprivate let dateFormatter = DateFormatter()
    fileprivate let datePicker = UIDatePicker()
    fileprivate var arrAccGroup = [typeAliasDictionary]()
    fileprivate var arrSeleAccGroup = [typeAliasDictionary]()
    fileprivate var arrAccGrpDetail = [typeAliasDictionary]()
    fileprivate var arrSeleAccGrpDetail = [typeAliasDictionary]()
    fileprivate var arrReport = [typeAliasDictionary]()
    
    
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.calendar = Calendar.current
        datePicker.datePickerMode = .date
        dateFormatter.dateFormat = "DD-MMM-yyyy"
        dateFormatter.calendar = Calendar.current
        dateFormatter.timeZone = Calendar.current.timeZone
        self.tfFromDate.inputView = datePicker
        self.tfToDate.inputView = datePicker
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let fromDate = dateFormatter.date(from: "\(userInfo[RES_KEY.From_Date] ?? "" as AnyObject)") ?? Date()
        let toDate = dateFormatter.date(from: "\(userInfo[RES_KEY.To_Date] ?? "" as AnyObject)") ?? Date()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        self.tfFromDate.text = dateFormatter.string(from: fromDate)
        self.tfToDate.text = dateFormatter.string(from: toDate)
        self.viewReportBG.isHidden = true
        setUpNavigationBar()
        getAccountGrpList()
    }
    
    
    //MARK:- NAVIGATION METHODS
    func setUpNavigationBar(){
        Obj_AppDelegate.navigationController.setCustomTitle("Book Report")
        Obj_AppDelegate.navigationController.navigationDelegate = self
        Obj_AppDelegate.navigationController.setBack()
    }
    func appNavigationController_BackAction() {
        Obj_AppDelegate.navigationController.popViewController(animated: true)
    }
    
    
    //MARK:- CUSTOME METHODS
    func getAccountGrpList(){
        DesignModel.startActivityIndicator()
        Obj_OperationApi.callWebService(ApiMethod.AccountGrpList, method: .post, parameters: typeAliasStringDictionary(), onCompletion: { (responce) in
            self.arrAccGroup = responce[RES_KEY.Data] as? [typeAliasDictionary] ?? [typeAliasDictionary]()
        }) { (errStr) in
            DesignModel.showMessage(errStr, for: self)
        }
    }
    func getAccountGrpDetailList(){
        if let grpDict = self.arrSeleAccGroup.first{
            self.view.endEditing(true)
            DesignModel.startActivityIndicator()
            self.arrAccGrpDetail = [typeAliasDictionary]()
            self.arrSeleAccGrpDetail = [typeAliasDictionary]()
            let param = [REQ_KEY.GroupDetCode: "\(grpDict[RES_KEY.Group_Det_Code] ?? "" as AnyObject)"]
            Obj_OperationApi.callWebService(ApiMethod.AccountGrpDetList, method: .post, parameters: param, onCompletion: { (responce) in
                self.arrAccGrpDetail = responce[RES_KEY.Data] as? [typeAliasDictionary] ?? [typeAliasDictionary]()
            }) { (errStr) in
                DesignModel.showMessage(errStr, for: self)
            }
        }else {
            self.arrAccGrpDetail = [typeAliasDictionary]()
            self.arrSeleAccGrpDetail = [typeAliasDictionary]()
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
        if textField == self.tfAccGroupList{
            let keys = [JD_UNIQUE_KEY: RES_KEY.Group_Det_Code,
                        JD_VALUE_KEY: RES_KEY.Group_Det_Name] as typeAliasDictionary
            self.showSelection("Account Group", array: self.arrAccGroup, arrSelected: self.arrSeleAccGroup, dictKey: keys, inputType: .GROUP, notAvailableMessage: "No account group found!!", selectionType: .SINGLE)
            return false
        }else if textField == self.tfAccGrpDetList{
            if self.arrSeleAccGroup.count<1{
                DesignModel.showMessage("Please select account group first.", for: self)
                return false
            }
            let keys = [JD_UNIQUE_KEY: RES_KEY.Ac_Code,
                        JD_VALUE_KEY: RES_KEY.Ac_Name] as typeAliasDictionary
            self.showSelection("Select Account", array: self.arrAccGrpDetail, arrSelected: self.arrSeleAccGrpDetail, dictKey: keys, inputType: .ACCOUNT, notAvailableMessage: "No account found.", selectionType: .SINGLE)
            return false
        }
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.tfFromDate || textField == self.tfToDate{
            if textField.text?.trim() != ""{
                self.datePicker.setDate(self.dateFormatter.date(from: textField.text!) ?? Date(), animated: true)
            }
        }
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField == self.tfFromDate || textField == self.tfToDate{
            textField.text = self.dateFormatter.string(from: self.datePicker.date)
        }
        return true
    }
    
    
    //MARK:- SELECTION DELEGATE
    func selectedOption(arrSelected: [typeAliasDictionary], inputType: INPUT_TYPE) {
        let dict = arrSelected.first
        if inputType == .GROUP{
            self.arrSeleAccGroup = arrSelected
            if arrSelected.count < 1{
                self.tfAccGroupList.text = dict!.isKeyNull(RES_KEY.Group_Det_Name) ? "-":"\(dict![RES_KEY.Group_Det_Name]!)"
            }else{
                self.tfAccGroupList.text = ""
            }
            self.getAccountGrpDetailList()
        }else if inputType == .ACCOUNT{
            
        }
    }
    
    
    //MARK:- Button Actions
    @IBAction func reportBtnAction(_ sender: UIButton){
        self.view.endEditing(true)
        if self.arrSeleAccGroup.count < 1 {
            DesignModel.showMessage("Please select account group", for: self)
            return
        }else if self.arrSeleAccGrpDetail.count < 1{
            DesignModel.showMessage("Please select account", for: self)
            return
        }
        DesignModel.startActivityIndicator()
        let grpDict = self.arrSeleAccGroup.first!
        let acDict = self.arrSeleAccGrpDetail.first!
        let param = [REQ_KEY.CompCode: "\(userInfo[RES_KEY.CompCode] ?? "" as AnyObject)",
                     REQ_KEY.YearCode: GetSetModel.getYearCode(),
                     REQ_KEY.FromDate: self.tfFromDate.text ?? "",
                     REQ_KEY.ToDate: self.tfToDate.text ?? "",
                     REQ_KEY.BasicCode: "",
                     REQ_KEY.GroupCode: "",
                     REQ_KEY.GroupDetCode: "\(grpDict[RES_KEY.Group_Det_Code] ?? "" as AnyObject)",
                     REQ_KEY.AcCode: "\(acDict[RES_KEY.Ac_Code] ?? "" as AnyObject)",
                     REQ_KEY.Currency: ""] as typeAliasStringDictionary
        Obj_OperationApi.callWebService(ApiMethod.GetLedgetReport, method: .post, parameters: param, onCompletion: { (responce) in
            if let arrData = responce[RES_KEY.Data] as? [typeAliasDictionary]{
                self.arrReport = arrData
                self.tableReport.reloadData()
                if self.arrReport.count>0{
                    self.viewReportBG.isHidden = false
                }else {
                    self.viewReportBG.isHidden = true
                    DesignModel.showMessage("No record found!!", for: self)
                }
            }else {
                self.arrReport = [typeAliasDictionary]()
                self.viewReportBG.isHidden = true
                DesignModel.showMessage(MSG_ERR_SOMETING_WRONG, for: self)
            }
        }) { (errStr) in
            self.arrReport = [typeAliasDictionary]()
            self.viewReportBG.isHidden = true
            DesignModel.showMessage(errStr, for: self)
        }
    }
    @IBAction func clearBtnAction(_ sebder: UIButton){
        self.tfFromDate.text = "\(self.userInfo[RES_KEY.From_Date] ?? "" as AnyObject)"
        self.tfToDate.text = "\(self.userInfo[RES_KEY.To_Date] ?? "" as AnyObject)"
        self.tfAccGroupList.text = ""
        self.tfAccGrpDetList.text = ""
        self.arrSeleAccGroup = [typeAliasDictionary]()
        self.arrAccGrpDetail = [typeAliasDictionary]()
        self.arrSeleAccGrpDetail = [typeAliasDictionary]()
        self.arrReport = [typeAliasDictionary]()
        self.tableReport.reloadData()
        self.viewReportBG.isHidden = true
    }
    
    
    //MARK:- TableView Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrReport.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "BookReportCell", for: indexPath) as? BookReportCell{
            let dict = self.arrReport[indexPath.row]
            cell.lblSerialNo.text = "\(indexPath.row+1)"
            cell.lblDate.text = dict.isKeyNull(RES_KEY.Trans_Date) ? "-":"\(dict[RES_KEY.Trans_Date]!)"
            cell.lblVoucherNo.text = dict.isKeyNull(RES_KEY.Voucher_No) ? "-":"\(dict[RES_KEY.Voucher_No]!)"
            cell.lblAccount.text = dict.isKeyNull(RES_KEY.Ac_Name) ? "-":"\(dict[RES_KEY.Ac_Name]!)"
            let debitAmt = Double("\(dict[RES_KEY.Debit_Amt] ?? "" as AnyObject)") ?? 0.0
            cell.lblDebit.text = String(round((debitAmt*1000)/1000))
            let creditAmt = Double("\(dict[RES_KEY.Credit_Amt] ?? "" as AnyObject)") ?? 0.0
            cell.lblCredit.text = String(round((1000*creditAmt)/1000))
            let balAmt = Double("\(dict[RES_KEY.Balance_Amt] ?? "" as AnyObject)") ?? 0.0
            cell.lblBalanceAmt.text = String(round((1000*balAmt)/1000))
            cell.lblType.text = dict.isKeyNull(RES_KEY.TYPE) ? "-":"\(dict[RES_KEY.TYPE]!)"
            return cell
        }
        return BookReportCell()
    }
}
