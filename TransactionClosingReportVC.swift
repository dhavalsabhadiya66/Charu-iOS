//
//  TransactionClosingReportVC.swift
//  Charu Industries
//
//  Created by iMac on 02/12/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

class TransactionClosingReportCell: UITableViewCell {
    
    @IBOutlet weak var lblSerialNo: UILabel!
    @IBOutlet weak var lblAccountName: UILabel!
    @IBOutlet weak var lblShortName: UILabel!
    @IBOutlet weak var lblMobileNo: UILabel!
    @IBOutlet weak var lblDebOpning: UILabel!
    @IBOutlet weak var lblCrdOpning: UILabel!
    @IBOutlet weak var lblDebTranscation: UILabel!
    @IBOutlet weak var lblCrdTransaction: UILabel!
    @IBOutlet weak var lblDebClosing: UILabel!
    @IBOutlet weak var lblCrdClosing: UILabel!
    
}

class TransactionClosingReportVC: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, AppNavigationControllerDelegate, JDSelectionDelegate {

    @IBOutlet weak var tfFromDate: UITextField!
    @IBOutlet weak var tfToDate: UITextField!
    @IBOutlet weak var tfGroupName: UITextField!
    @IBOutlet weak var btnReport: UIButton!
    @IBOutlet weak var btnClear: UIButton!
    @IBOutlet weak var heightTable: NSLayoutConstraint!
    @IBOutlet weak var viewReportBG: UIView!
    @IBOutlet weak var tableReport: UITableView!
    
    
    @IBOutlet weak var lblDebOpning: UILabel!
    @IBOutlet weak var lblCrdOpning: UILabel!
    @IBOutlet weak var lblDebTranscation: UILabel!
    @IBOutlet weak var lblCrdTransaction: UILabel!
    @IBOutlet weak var lblDebClosing: UILabel!
    @IBOutlet weak var lblCrdClosing: UILabel!
    
    
    fileprivate let userInfo = GetSetModel.getUserInfo()
    fileprivate let dateFormatter = DateFormatter()
    fileprivate let datePicker = UIDatePicker()
    fileprivate var arrGroupName = [typeAliasDictionary]()
    fileprivate var arrSeleGroupName = [typeAliasDictionary]()
    fileprivate var arrReport = [typeAliasDictionary]()
    
    
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.calendar = Calendar.current
        datePicker.timeZone = Calendar.current.timeZone
        datePicker.datePickerMode = .date
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        dateFormatter.calendar = Calendar.current
        dateFormatter.timeZone = Calendar.current.timeZone
        self.tfFromDate.inputView = datePicker
        self.tfToDate.inputView = datePicker
        self.tfFromDate.setRightImage(UIImage(named: "ic_drop_down")!.tinted(with: .darkGray))
        self.tfToDate.setRightImage(UIImage(named: "ic_drop_down")!.tinted(with: .darkGray))
        self.tfGroupName.setRightImage(UIImage(named: "ic_drop_down")!.tinted(with: .darkGray))
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dateFormatter.dateFormat = "dd-MM-yyyy"
//        let fromDate = dateFormatter.date(from: "\(userInfo[RES_KEY.From_Date] ?? "" as AnyObject)") ?? Date()
//        let toDate = dateFormatter.date(from: "\(userInfo[RES_KEY.To_Date] ?? "" as AnyObject)") ?? Date()
//        dateFormatter.dateFormat = "dd-MMM-yyyy"
//        self.tfFromDate.text = dateFormatter.string(from: fromDate)
//        self.tfToDate.text = dateFormatter.string(from: toDate)
        self.tfFromDate.text = dateFormatter.string(from: Date())
        self.tfToDate.text = dateFormatter.string(from: Date())
        self.viewReportBG.isHidden = self.arrReport.count < 1
        setUpNavigationBar()
        getGroupList()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.heightTable.constant = self.viewReportBG.frame.height-196
    }
    
    
    //MARK:- NAVIGATION METHODS
    func setUpNavigationBar(){
        Obj_AppDelegate.navigationController.setCustomTitle("Transaction Closing Trail Balance")
        Obj_AppDelegate.navigationController.navigationDelegate = self
        Obj_AppDelegate.navigationController.setBack()
        Obj_AppDelegate.navigationController.setRightMenu(UIImage(named: "ic_nav_print")!.tinted(with: .white))
    }
    func appNavigationController_BackAction() {
        Obj_AppDelegate.navigationController.popViewController(animated: true)
    }
    func appNavigationController_RightMenuAction() {
        if self.arrReport.count<1{
            DesignModel.showMessage("Please genrate report to print!", for: self)
            return
        }
        var data = ""
        data += "<TABLE border=\"1\">"
        data += "<TR><td align='center' colspan=\"15\"><b>Transaction Closing Trail Balance</b></td>";
        data += "</TR>";
        data += "<TR bgcolor=\"#E4DDC2\">";
        data += "<TH align='center' style=\"white-space: nowrap;font-size:10px;\"><b>Sr No</b></TH>";
        data += "<TH align='center' style=\"white-space: nowrap;font-size:10px;\"><b>Account Name</b></TH>";
        data += "<TH align='center' style=\"white-space: nowrap;font-size:10px;\"><b>Short Name</b></TH>";
        data += "<TH align='center' style=\"white-space: nowrap;font-size:10px;\"><b>Mobile No</b></TH>";
        data += "<TH align='center' style=\"white-space: nowrap;font-size:10px;\"><b>Opening Debit</b></TH>";
        data += "<TH align='center' style=\"white-space: nowrap;font-size:10px; \"><b>Opening Credit</b></TH>";
        data += "<TH align='center' style=\"white-space: nowrap;font-size:10px; \"><b>Transaction Debit</b></TH>";
        data += "<TH align='center' style=\"white-space: nowrap;font-size:10px; \"><b>Transaction Credit</b></TH>";
        data += "<TH align='center' style=\"white-space: nowrap;font-size:10px; \"><b>Closing Debit</b></TH>";
        data += "<TH align='center' style=\"white-space: nowrap;font-size:10px; \"><b>Closing Credit</b></TH>";
        data += "</TR>";
        for dict in self.arrReport{
            let srNo = dict.isKeyNull(RES_KEY.SRNO) ? "-":"\(dict[RES_KEY.SRNO]!)."
            let accountName = dict.isKeyNull(RES_KEY.AC_NAME) ? "-":"\(dict[RES_KEY.AC_NAME]!)"
            let shortName = dict.isKeyNull(RES_KEY.SHORT_NAME) ? "-":"\(dict[RES_KEY.SHORT_NAME]!)"
            let mobileNo = dict.isKeyNull(RES_KEY.MOBILE_NO) ? "-":"\(dict[RES_KEY.MOBILE_NO]!)"
            let debOpening = dict.isKeyNull(RES_KEY.CLS_DR_AMT) ? "-":"\(dict[RES_KEY.CLS_DR_AMT]!)"
            let crdOpening = dict.isKeyNull(RES_KEY.CLS_CR_AMT) ? "-":"\(dict[RES_KEY.CLS_CR_AMT]!)"
            let debTransaction = dict.isKeyNull(RES_KEY.CLS_DR_TRANS_AMT) ? "-":"\(dict[RES_KEY.CLS_DR_TRANS_AMT]!)"
            let crdTransaction = dict.isKeyNull(RES_KEY.CLS_CR_TRANS_AMT) ? "-":"\(dict[RES_KEY.CLS_CR_TRANS_AMT]!)"
            let debClosing = dict.isKeyNull(RES_KEY.CLS_DR_DOM_AMT) ? "-":"\(dict[RES_KEY.CLS_DR_DOM_AMT]!)"
            let crdClosing = dict.isKeyNull(RES_KEY.CLS_CR_DOM_AMT) ? "-":"\(dict[RES_KEY.CLS_CR_DOM_AMT]!)"
            data += "<TR>";
            data += "<TD align='center' style =\"white-space: nowrap;font-size:7px;\">\(srNo)</TD>";
            data += "<TD align='center' style =\"white-space: nowrap;font-size:7px;\">\(accountName)</TD>";
            data += "<TD align='center' style =\"white-space: nowrap;font-size:7px;\">\(shortName)</TD>";
            data += "<TD align='center' style =\"white-space: nowrap;font-size:7px;\">\(mobileNo)</TD>";
            data += "<TD align='center' style =\"white-space: nowrap;font-size:7px;\">\(debOpening)</TD>";
            data += "<TD align='center' style =\"word-wrap: break-word;font-size:7px;\">\(crdOpening)</TD>";
            data += "<TD align='center' style =\"word-wrap: break-word;font-size:7px;\">\(debTransaction)</TD>";
            data += "<TD align='center' style =\"word-wrap: break-word;font-size:7px;\">\(crdTransaction)</TD>";
            data += "<TD align='center' style =\"word-wrap: break-word;font-size:7px;\">\(debClosing)</TD>";
            data += "<TD align='center' style =\"word-wrap: break-word;font-size:7px;\">\(crdClosing)</TD>";
            data += "</TR>";
        }
        data += "</TABLE>";
        
        
        let htmlString =  "<html>\n\n" + "<head>\n\n" + "</head>\n\n" +
            "<body style=\"font-family:'Open Sans';\">\n\n" + data + "\n" + "</body>\n" + "</html>";
        let render = UIPrintPageRenderer()
        let fmt = UIMarkupTextPrintFormatter(markupText: htmlString)
        render.addPrintFormatter(fmt, startingAtPageAt: 0)
        let page = CGRect(x: 0, y: 0, width: 595.2, height: 841.8)
        let printable = page.insetBy(dx: 10, dy: 10)
        render.setValue(page, forKey: "paperRect")
        render.setValue(printable, forKey: "printableRect")
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, CGRect.zero, nil)
        for i in 1...render.numberOfPages {
            UIGraphicsBeginPDFPage();
            let bounds = UIGraphicsGetPDFContextBounds()
            render.drawPage(at: i - 1, in: bounds)
        }
        UIGraphicsEndPDFContext();
        
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let directory = paths.first ?? ""
        let filePath = "\(directory)/transactionClosingTrailBalance.pdf"
        pdfData.write(toFile: filePath, atomically: true)
        let fileUrl = NSURL(fileURLWithPath: filePath)
        let activiyController = UIActivityViewController(activityItems: [fileUrl], applicationActivities: nil)
        Obj_AppDelegate.navigationController.present(activiyController, animated: true) {
            
        }
    }
    
    
    //MARK:- CUSTOM METHODS
    func getGroupList(){
        DesignModel.startActivityIndicator()
        Obj_OperationApi.callWebService(ApiMethod.TrialGroupList, method: .post, parameters: [:], onCompletion: { (responce) in
            self.arrGroupName = responce[RES_KEY.Data] as? [typeAliasDictionary] ?? [typeAliasDictionary]()
        }) { (errStr) in
            DesignModel.showMessage(errStr, for: self)
        }
    }
    func updateTotalView(){
        var totalDebitOpeningAmt = 0.00
        var totalCreditOpeningAmt = 0.00
        var totalDebitTransAmt = 0.00
        var totalCreditTransAmt = 0.00
        var totalDebitClosingAmt = 0.00
        var totalCreditClosingAmt = 0.00
        for dict in self.arrReport{
            let debitOpeningAmt = Double("\(dict[RES_KEY.DR_AMT] ?? "" as AnyObject)") ?? 0.0
            let creditOpeningAmt = Double("\(dict[RES_KEY.CR_AMT] ?? "" as AnyObject)") ?? 0.0
            let debitTransAmt = Double("\(dict[RES_KEY.DR_TRANS_AMT] ?? "" as AnyObject)") ?? 0.0
            let creditTransAmt = Double("\(dict[RES_KEY.CR_TRANS_AMT] ?? "" as AnyObject)") ?? 0.0
            let debitClosingAmt = Double("\(dict[RES_KEY.CLS_DR_AMT] ?? "" as AnyObject)") ?? 0.0
            let creditClosingAmt = Double("\(dict[RES_KEY.CLS_CR_AMT] ?? "" as AnyObject)") ?? 0.0
            totalDebitOpeningAmt += debitOpeningAmt
            totalCreditOpeningAmt += creditOpeningAmt
            totalDebitTransAmt += debitTransAmt
            totalCreditTransAmt += creditTransAmt
            totalDebitClosingAmt += debitClosingAmt
            totalCreditClosingAmt += creditClosingAmt
        }
        self.lblDebOpning.text = "\(withSeprate(val: totalDebitOpeningAmt))"
        self.lblCrdOpning.text = "\(withSeprate(val: totalCreditOpeningAmt))"
        self.lblDebTranscation.text = "\(withSeprate(val: totalDebitTransAmt))"
        self.lblCrdTransaction.text = "\(withSeprate(val: totalCreditTransAmt))"
        self.lblDebClosing.text = "\(withSeprate(val: totalDebitClosingAmt))"
        self.lblCrdClosing.text = "\(withSeprate(val: totalCreditClosingAmt))"
    }
    
    
    //MARK:- TEXTFIELD DELEGATE
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.tfGroupName{
            let keys = [JD_UNIQUE_KEY: RES_KEY.GROUP_DET_CODE,
                        JD_VALUE_KEY: RES_KEY.GROUP_DET_NAME] as typeAliasDictionary
            if self.arrGroupName.count == 0 {
                DesignModel.showMessage("Group name not found", for: self)
                return false
            }
            var isAbleSearch = false
            if self.arrGroupName.count > 5 { isAbleSearch = true }
            let _JDSelection = JDSelection.init(title: "Select Group Name", selectionType: .SINGLE, listArray: self.arrGroupName, selectedArray: self.arrSeleGroupName, keyDictionary: keys, inputType: INPUT_TYPE.ACCOUNT, isSelectionCompulsory: true, contentFrame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(self.view.frame.width * 0.75), height: CGFloat(self.view.frame.height * 0.5)), isPaginationExist: isAbleSearch, isRemoveOnDoneClick: true)
            _JDSelection.delegate = self
            Obj_AppDelegate.navigationController.view.addSubview(_JDSelection)
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
        if inputType == .ACCOUNT{
            self.arrSeleGroupName = arrSelected
            if let dict = arrSelected.first{
                self.tfGroupName.text = dict.isKeyNull(RES_KEY.GROUP_DET_NAME) ? "-":"\(dict[RES_KEY.GROUP_DET_NAME]!)"
            }else {
                self.tfGroupName.text = ""
            }
        }
    }
    
    
    //MARK:- BUTTON ACTIONS
    @IBAction func reportBtnAction(_ sender: UIButton){
        self.view.endEditing(true)
        DesignModel.startActivityIndicator()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let fromDate = dateFormatter.date(from: "\(self.tfFromDate.text!)") ?? Date()
        let toDate = dateFormatter.date(from: "\(self.tfToDate.text!)") ?? Date()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        var proGrpCode = 0
        if let proGrpDict = self.arrSeleGroupName.first{
            proGrpCode = Int("\(proGrpDict[RES_KEY.GROUP_DET_CODE] ?? "" as AnyObject)") ?? 0
        }
        let param = [REQ_KEY.CompCode: "\(userInfo[RES_KEY.CompCode] ?? "" as AnyObject)",
                     REQ_KEY.YearCode: GetSetModel.getYearCode(),
                     REQ_KEY.FromDate: dateFormatter.string(from: fromDate),
                     REQ_KEY.ToDate: dateFormatter.string(from: toDate),
                     REQ_KEY.ProdGrpCode: "\(proGrpCode == 0 ? "" : "\(proGrpCode)")"] as typeAliasStringDictionary
        Obj_OperationApi.callWebService(ApiMethod.GetTransClosingTrialReport, method: .post, parameters: param, onCompletion: { (responce) in
            print(responce)
            if let arrData = responce[RES_KEY.Data] as? [typeAliasDictionary]{
                self.arrReport = arrData
                self.updateTotalView()
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
    @IBAction func clearBtnActio(_ sender: UIButton){
        dateFormatter.dateFormat = "dd-MM-yyyy"
        self.tfFromDate.text = dateFormatter.string(from: Date())
        self.tfToDate.text = dateFormatter.string(from: Date())
        self.tfGroupName.text = ""
        self.arrSeleGroupName = [typeAliasDictionary]()
        self.arrReport = [typeAliasDictionary]()
        self.updateTotalView()
        self.tableReport.reloadData()
        self.viewReportBG.isHidden = true
    }
    
    
    //MARK:- TABLEVIEW METHODS
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrReport.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionClosingReportCell", for: indexPath) as? TransactionClosingReportCell{
            let dict = self.arrReport[indexPath.row]
            cell.lblSerialNo.text = dict.isKeyNull(RES_KEY.SRNO) ? "-":"\(dict[RES_KEY.SRNO]!)."
            cell.lblAccountName.text = dict.isKeyNull(RES_KEY.AC_NAME) ? "-":"\(dict[RES_KEY.AC_NAME]!)"
            cell.lblShortName.text = dict.isKeyNull(RES_KEY.SHORT_NAME) ? "-":"\(dict[RES_KEY.SHORT_NAME]!)"
            cell.lblMobileNo.text = dict.isKeyNull(RES_KEY.MOBILE_NO) ? "-":"\(dict[RES_KEY.MOBILE_NO]!)"
            
            
            let debOpening = Double("\(dict[RES_KEY.DR_AMT] ?? "" as AnyObject)") ?? 0.00
            cell.lblDebOpning.text = debOpening == 0.00 ? "-":withSeprate(val: debOpening)
            let crdOpening = Double("\(dict[RES_KEY.CR_AMT] ?? "" as AnyObject)") ?? 0.00
            cell.lblCrdOpning.text = crdOpening == 0.00 ? "-":withSeprate(val: crdOpening)
            let debTransaction = Double("\(dict[RES_KEY.DR_TRANS_AMT] ?? "" as AnyObject)") ?? 0.00
            cell.lblDebTranscation.text = debTransaction == 0.00 ? "-":withSeprate(val: debTransaction)
            let crdTransaction = Double("\(dict[RES_KEY.CR_TRANS_AMT] ?? "" as AnyObject)") ?? 0.00
            cell.lblCrdTransaction.text = crdTransaction == 0.00 ? "-":withSeprate(val: crdTransaction)
            let debClosing = Double("\(dict[RES_KEY.CLS_DR_AMT] ?? "" as AnyObject)") ?? 0.00
            cell.lblDebClosing.text = debClosing == 0.00 ? "-":withSeprate(val: debClosing)
            let crdClosing = Double("\(dict[RES_KEY.CLS_CR_AMT] ?? "" as AnyObject)") ?? 0.00
            cell.lblCrdClosing.text = crdClosing == 0.00 ? "-":withSeprate(val: crdClosing)
            
            if(dict.isKeyNull(RES_KEY.SRNO)){
                cell.lblAccountName.font = UIFont.boldSystemFont(ofSize: 13)
            }else{
                cell.lblAccountName.font = UIFont.systemFont(ofSize: 13)
            }
            
            return cell
        }
        return TransactionClosingReportCell()
    }

}
