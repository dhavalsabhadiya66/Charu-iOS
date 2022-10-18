//
//  PurchaseReportVC.swift
//  Charu Industries
//
//  Created by admin on 09/09/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit


class PurchaseReportCell: UITableViewCell {
    
    @IBOutlet weak var lblSrNo: UILabel!
    @IBOutlet weak var lblInvoiceDate: UILabel!
    @IBOutlet weak var lblInvoiceNo: UILabel!
    @IBOutlet weak var lblBookName: UILabel!
    @IBOutlet weak var lblPartyName: UILabel!
    @IBOutlet weak var lblGrpName: UILabel!
    @IBOutlet weak var lblProdName: UILabel!
    @IBOutlet weak var lblPcs: UILabel!
    @IBOutlet weak var lblQnt: UILabel!
    @IBOutlet weak var lblUnit: UILabel!
    @IBOutlet weak var lblRate: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    
}


class PurchaseReportVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, AppNavigationControllerDelegate, JDSelectionDelegate {
    
    
    @IBOutlet weak var tfFromDate: UITextField!
    @IBOutlet weak var tfToDate: UITextField!
    @IBOutlet weak var tfParty: UITextField!
    @IBOutlet weak var tfProductGrp: UITextField!
    @IBOutlet weak var tfProducts: UITextField!
    @IBOutlet weak var lblTotalPcs: UILabel!
    @IBOutlet weak var lblTotalQty: UILabel!
    @IBOutlet weak var lblTotalAmount: UILabel!
    @IBOutlet weak var tableReport: UITableView!
    @IBOutlet weak var heightTableView: NSLayoutConstraint!
    @IBOutlet weak var viewReportBG: UIView!
    
    
    fileprivate let userInfo = GetSetModel.getUserInfo()
    fileprivate let dateFormatter = DateFormatter()
    fileprivate let datePicker = UIDatePicker()
    fileprivate var arrPartys = [typeAliasDictionary]()
    fileprivate var arrSeleParty = [typeAliasDictionary]()
    fileprivate var arrProdGroup = [typeAliasDictionary]()
    fileprivate var arrSeleProdGrp = [typeAliasDictionary]()
    fileprivate var arrProducts = [typeAliasDictionary]()
    fileprivate var arrSeleProd = [typeAliasDictionary]()
    fileprivate var arrReport = [typeAliasDictionary]()
    fileprivate var pageNo = 0
    fileprivate var totalRecords = 0
    
    
    //MARK:-
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
        self.tfParty.setRightImage(UIImage(named: "ic_drop_down")!.tinted(with: .darkGray))
        self.tfProductGrp.setRightImage(UIImage(named: "ic_drop_down")!.tinted(with: .darkGray))
        self.tfProducts.setRightImage(UIImage(named: "ic_drop_down")!.tinted(with: .darkGray))
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dateFormatter.dateFormat = "dd-MM-yyyy"
//        let fromDate = dateFormatter.date(from: "\(userInfo[RES_KEY.From_Date] ?? "" as AnyObject)") ?? Date()
//        let toDate = dateFormatter.date(from: "\(userInfo[RES_KEY.To_Date] ?? "" as AnyObject)") ?? Date()
//        dateFormatter.dateFormat = "dd-MMM-yyyy"
//        self.tfFromDate.text = dateFormatter.string(from: fromDate)
//        self.tfToDate.text = dateFormatter.string(from: toDate)
        self.tfFromDate.text = "\(userInfo[RES_KEY.From_Date] ?? "" as AnyObject)"
        self.tfToDate.text = "\(userInfo[RES_KEY.To_Date] ?? "" as AnyObject)"
        if self.arrReport.count > 0{
            self.viewReportBG.isHidden = false
        }else {
            self.viewReportBG.isHidden = true
            self.pageNo = 0
        }
        setUpNavigationBar()
        self.getPartyList()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.heightTableView.constant = self.viewReportBG.frame.height-91
    }
    
    
    //MARK:- NAVIGATION METHODS
    func setUpNavigationBar(){
        Obj_AppDelegate.navigationController.setCustomTitle("Purchase Report")
        Obj_AppDelegate.navigationController.navigationDelegate = self
        Obj_AppDelegate.navigationController.setBack()
        if !self.viewReportBG.isHidden{
            Obj_AppDelegate.navigationController.setRightMenu(UIImage(named: "ic_nav_print")!.tinted(with: .white))
        }
    }
    func appNavigationController_BackAction() {
        if !self.viewReportBG.isHidden{
            UIView.transition(with: viewReportBG, duration: 0.4, options: .transitionCrossDissolve, animations: {
                self.viewReportBG.isHidden = true
            }) { (_) in }
            return
        }
        Obj_AppDelegate.navigationController.popViewController(animated: true)
    }
    func appNavigationController_RightMenuAction() {
        if self.arrReport.count<1{
            DesignModel.showMessage("Please genrate report to print!", for: self)
            return
        }
        var data = ""
        data += "<TABLE border=\"1\">"
        data += "<TR><td align='center' colspan=\"15\"><b>Purchase Report</b></td>";
        data += "</TR>";
        data += "<TR bgcolor=\"#E4DDC2\">";
        data += "<TH align='center' style=\"white-space: nowrap;font-size:10px;\"><b>Sr No</b></TH>";
        data += "<TH align='center' style=\"white-space: nowrap;font-size:10px;\"><b>Invoice Date</b></TH>";
        data += "<TH align='center' style=\"white-space: nowrap;font-size:10px;\"><b>Invoice No</b></TH>";
        data += "<TH align='center' style=\"white-space: nowrap;font-size:10px;\"><b>Book Name</b></TH>";
        data += "<TH align='center' style=\"white-space: nowrap;font-size:10px;\"><b>Party Name</b></TH>";
        data += "<TH align='center' style=\"white-space: nowrap;font-size:10px; \"><b>Product Group Name</b></TH>";
        data += "<TH align='center' style=\"white-space: nowrap;font-size:10px; \"><b>Product Name</b></TH>";
        data += "<TH align='center' style=\"white-space: nowrap;font-size:10px; \"><b>Pcs</b></TH>";
        data += "<TH align='center' style=\"white-space: nowrap;font-size:10px; \"><b>Qty</b></TH>";
        data += "<TH align='center' style=\"white-space: nowrap;font-size:10px; \"><b>Unit</b></TH>";
        data += "<TH align='center' style=\"white-space: nowrap;font-size:10px; \"><b>Purchase Rate</b></TH>";
        data += "<TH align='center' style=\"white-space: nowrap;font-size:10px; \"><b>Purchase Amount</b></TH>";
        data += "</TR>";
        var srNo = 0
        for dict in self.arrReport{
            srNo += 1
            let rate = Double("\(dict[RES_KEY.Rate] ?? "" as AnyObject)") ?? 0.00
            let amt = Double("\(dict[RES_KEY.Amount] ?? "" as AnyObject)") ?? 0.00
            let invoiceDate = dict.isKeyNull(RES_KEY.Invoice_Date) ? "-":"\(dict[RES_KEY.Invoice_Date]!)"
            let invoiceNo = dict.isKeyNull(RES_KEY.INVOICE_NO) ? "-":"\(dict[RES_KEY.INVOICE_NO]!)"
            let bookName = dict.isKeyNull(RES_KEY.Book_Name) ? "-":"\(dict[RES_KEY.Book_Name]!)"
            let partyName = dict.isKeyNull(RES_KEY.Party_Name) ? "-":"\(dict[RES_KEY.Party_Name]!)"
            let groupName = dict.isKeyNull(RES_KEY.Group_Name) ? "-":"\(dict[RES_KEY.Group_Name]!)"
            let prodName = dict.isKeyNull(RES_KEY.Product_Name) ? "-":"\(dict[RES_KEY.Product_Name]!)"
            let pcs = dict.isKeyNull(RES_KEY.Pcs) ? "-":"\(dict[RES_KEY.Pcs]!)"
            let qty = dict.isKeyNull(RES_KEY.Qty) ? "-":"\(dict[RES_KEY.Qty]!)"
            let unit = dict.isKeyNull(RES_KEY.Unit) ? "-":"\(dict[RES_KEY.Unit]!)"
            let rateStr = rate == 0.00 ? "-":String(round((rate*100)/100))
            let amtStr = amt == 0.00 ? "-":String(round((amt*100)/100))
            
            data += "<TR>";
            data += "<TD align='center' style =\"white-space: nowrap;font-size:7px;\">\(srNo)</TD>";
            data += "<TD align='center' style =\"white-space: nowrap;font-size:7px;\">\(invoiceDate)</TD>";
            data += "<TD align='center' style =\"white-space: nowrap;font-size:7px;\">\(invoiceNo)</TD>";
            data += "<TD align='center' style =\"white-space: nowrap;font-size:7px;\">\(bookName)</TD>";
            data += "<TD align='center' style =\"white-space: nowrap;font-size:7px;\">\(partyName)</TD>";
            data += "<TD align='center' style =\"word-wrap: break-word;font-size:7px;\">\(groupName)</TD>";
            data += "<TD align='center' style =\"word-wrap: break-word;font-size:7px;\">\(prodName)</TD>";
            data += "<TD align='center' style =\"word-wrap: break-word;font-size:7px;\">\(pcs)</TD>";
            data += "<TD align='center' style =\"word-wrap: break-word;font-size:7px;\">\(qty)</TD>";
            data += "<TD align='center' style =\"word-wrap: break-word;font-size:7px;\">\(unit)</TD>";
            data += "<TD align='right' style =\"word-wrap: break-word;font-size:7px;\">\(rateStr)</TD>";
            data += "<TD align='right' style =\"word-wrap: break-word;font-size:7px;\">\(amtStr)</TD>";
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
        let filePath = "\(directory)/purchaseReport.pdf"
        pdfData.write(toFile: filePath, atomically: true)
        let fileUrl = NSURL(fileURLWithPath: filePath)
        let activiyController = UIActivityViewController(activityItems: [fileUrl], applicationActivities: nil)
        Obj_AppDelegate.navigationController.present(activiyController, animated: true) {
            
        }
    }
    
    
    //MARK:- CUSTOME METHODS
    func getPartyList(){
        DesignModel.startActivityIndicator()
        let param = [REQ_KEY.PartyCode: "",
                     REQ_KEY.CompCode: "\(userInfo[RES_KEY.CompCode] ?? "" as AnyObject)"]
        Obj_OperationApi.callWebService(ApiMethod.GetPartyList, method: .post, parameters: param, onCompletion: { (responce) in
            if let arrData = responce[RES_KEY.Data] as? [typeAliasDictionary]{
                self.arrPartys = arrData
            }else{
                DesignModel.showMessage(MSG_ERR_SOMETING_WRONG, for: self)
            }
            self.getProductGroup()
        }) { (errStr) in
            DesignModel.showMessage(errStr, for: self)
        }
    }
    func getProductGroup() {
        DesignModel.startActivityIndicator()
        let param = [REQ_KEY.ProdGrpCode: "",
                     REQ_KEY.Status: "",
                     REQ_KEY.CompCode: "\(userInfo[RES_KEY.CompCode]  ?? "" as AnyObject)"]
        Obj_OperationApi.callWebService(ApiMethod.GetProdGrpList, method: .post, parameters: param, onCompletion: { (responce) in
            if let arrData = responce[RES_KEY.Data] as? [typeAliasDictionary]{
                self.arrProdGroup = arrData
            }else{
                DesignModel.showMessage(MSG_ERR_SOMETING_WRONG, for: self)
            }
        }) { (errStr) in
            DesignModel.showMessage(errStr, for: self)
        }
    }
    func getProducts(){
        if let grpDict = self.arrProdGroup.first{
            self.view.endEditing(true)
            DesignModel.startActivityIndicator()
            self.arrProducts = [typeAliasDictionary]()
            self.arrSeleProd = [typeAliasDictionary]()
            let param = [REQ_KEY.ProdGrpCode: "\(grpDict[RES_KEY.Group_Det_Code] ?? "" as AnyObject)"]
            Obj_OperationApi.callWebService(ApiMethod.AccountGrpDetList, method: .post, parameters: param, onCompletion: { (responce) in
                self.arrProducts = responce[RES_KEY.Data] as? [typeAliasDictionary] ?? [typeAliasDictionary]()
            }) { (errStr) in
                self.arrProducts = [typeAliasDictionary]()
                self.arrSeleProd = [typeAliasDictionary]()
                //                DesignModel.showMessage(errStr, for: self)
            }
        }else {
            self.arrProducts = [typeAliasDictionary]()
            self.arrSeleProd = [typeAliasDictionary]()
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
    func updateTotalView(){
        var totalPcs = 0
        var totalQty = 0
        var totalAmt = 0.00
        for dict in self.arrReport{
            let pcs = Int("\(dict[RES_KEY.Pcs] ?? "" as AnyObject)") ?? 0
            let qty = Int("\(dict[RES_KEY.Qty] ?? "" as AnyObject)") ?? 0
            let amount = Double("\(dict[RES_KEY.Amount] ?? "" as AnyObject)") ?? 0.0
            totalPcs += pcs
            totalQty += qty
            totalAmt += amount
        }
        self.lblTotalPcs.text = "Pcs: \(totalPcs)"
        self.lblTotalQty.text = "Qty: \(totalQty)"
        self.lblTotalAmount.text = "₹ \(withSeprate(val: totalAmt))"
    }
    func getReportData(){
        DesignModel.startActivityIndicator()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let fromDate = dateFormatter.date(from: "\(self.tfFromDate.text!)") ?? Date()
        let toDate = dateFormatter.date(from: "\(self.tfToDate.text!)") ?? Date()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        let partyDict = self.arrSeleParty.first ?? typeAliasDictionary()
        let grpDict = self.arrSeleProdGrp.first ?? typeAliasDictionary()
        let prodDict = self.arrProducts.first ?? typeAliasDictionary()
        self.pageNo += 1
        let params = [REQ_KEY.CompCode: "\(userInfo[RES_KEY.CompCode] ?? "" as AnyObject)",
            REQ_KEY.FromDate: dateFormatter.string(from: fromDate),
            REQ_KEY.ToDate: dateFormatter.string(from: toDate),
            REQ_KEY.PartyCode: "\(partyDict[RES_KEY.Party_Code] ?? "" as AnyObject)",
            REQ_KEY.ProdGrpCode: "\(grpDict[RES_KEY.P_Grp_Code] ?? "" as AnyObject)",
            REQ_KEY.ProdCode: "\(prodDict[RES_KEY.Product_Code] ?? "" as AnyObject)",
            REQ_KEY.PageNo: "\(self.pageNo)"]
        print(params)
        Obj_OperationApi.callWebService(ApiMethod.PurchaseReport, method: .post, parameters: params, onCompletion: { (responce) in
            print(responce)
            if self.pageNo == 1 {
                self.totalRecords = Int("\(responce[RES_KEY.Total_Record] ?? "" as AnyObject)") ?? 0
                if let arrData = responce[RES_KEY.Data] as? [typeAliasDictionary]{
                    self.arrReport = arrData
                    self.updateTotalView()
                    self.tableReport.reloadData()
                    if self.arrReport.count>0{
                        self.tableReport.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                        UIView.transition(with: self.viewReportBG, duration: 0.4, options: .transitionCrossDissolve, animations: {
                            self.viewReportBG.isHidden = false
                        }) { (_) in
                            Obj_AppDelegate.navigationController.setRightMenu(UIImage(named: "ic_nav_print")!.tinted(with: .white))
                        }
                    }else {
                        UIView.transition(with: self.viewReportBG, duration: 0.4, options: .transitionCrossDissolve, animations: {
                            self.viewReportBG.isHidden = true
                        }) { (_) in
                            self.navigationItem.setRightBarButton(nil, animated: true)
                            DesignModel.showMessage("No record found!!", for: self)
                        }
                    }
                }else {
                    UIView.transition(with: self.viewReportBG, duration: 0.4, options: .transitionCrossDissolve, animations: {
                        self.viewReportBG.isHidden = true
                    }) { (_) in
                        self.arrReport = [typeAliasDictionary]()
                        self.navigationItem.setRightBarButton(nil, animated: true)
                        DesignModel.showMessage(MSG_ERR_SOMETING_WRONG, for: self)
                    }
                }
            }else {
                if let arrData = responce[RES_KEY.Data] as? [typeAliasDictionary]{
                    self.arrReport.append(contentsOf: arrData)
                    self.updateTotalView()
                    self.tableReport.reloadData()
                }else {
                    DesignModel.showMessage("No other record found!!", for: self)
                }
            }
        }) { (errStr) in
            if self.pageNo == 1{
                self.arrReport = [typeAliasDictionary]()
                self.viewReportBG.isHidden = true
            }
            self.pageNo -= 1
            DesignModel.showMessage(errStr, for: self)
        }
    }
    
    
    //MARK:- TEXTFIELD DELEGATES
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.tfParty{
            let keys = [JD_UNIQUE_KEY: RES_KEY.Party_Code,
                        JD_VALUE_KEY: RES_KEY.Party_Name] as typeAliasDictionary
            self.showSelection("Selecct Party Name", array: self.arrPartys, arrSelected: self.arrSeleParty, dictKey: keys, inputType: .PARTY, notAvailableMessage: "No party name found!!", selectionType: .SINGLE)
            return false
        }else if textField == self.tfProductGrp{
            let keys = [JD_UNIQUE_KEY: RES_KEY.P_Grp_Code,
                        JD_VALUE_KEY: RES_KEY.P_Grp_Name] as typeAliasDictionary
            self.showSelection("Select Product Group", array: self.arrProdGroup, arrSelected: self.arrSeleProdGrp, dictKey: keys, inputType: .GROUP, notAvailableMessage: "No product group found!!", selectionType: .SINGLE)
            return false
        }else if textField == self.tfProducts{
            let keys = [JD_UNIQUE_KEY: RES_KEY.Product_Code,
                        JD_VALUE_KEY: RES_KEY.Procuct_Name] as typeAliasDictionary
            self.showSelection("Select Product Name", array: self.arrProducts, arrSelected: self.arrSeleProd, dictKey: keys, inputType: .PRODUCT, notAvailableMessage: "No product name found!!", selectionType: .SINGLE)
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
    
    
    //MARK:- JDSELECTION DELEGATE
    func selectedOption(arrSelected: [typeAliasDictionary], inputType: INPUT_TYPE) {
        let dict = arrSelected.first
        if inputType == .PARTY{
            self.arrSeleParty = arrSelected
            if arrSelected.count>0{
                self.tfParty.text = dict!.isKeyNull(RES_KEY.Party_Name) ? "-":"\(dict![RES_KEY.Party_Name]!)"
            }else {
                self.tfParty.text = ""
            }
        }else if inputType == .GROUP{
            self.arrSeleProdGrp = arrSelected
            if arrSelected.count>0{
                self.tfProductGrp.text = dict!.isKeyNull(RES_KEY.P_Grp_Name) ? "-":"\(dict![RES_KEY.P_Grp_Name]!)"
            }else {
                self.tfProductGrp.text = ""
            }
            self.getPartyList()
        }else if inputType == .PRODUCT{
            self.arrSeleParty = arrSelected
            if arrSelected.count>0{
                self.tfProducts.text = dict!.isKeyNull(RES_KEY.Procuct_Name) ? "-":"\(dict![RES_KEY.Procuct_Name]!)"
            }else {
                self.tfProducts.text = ""
            }
        }
    }
    
    
    //MARK:- BUTTON ACTIONS
    @IBAction func reportBtnAction(_ sender: UIButton){
        self.pageNo = 0
        self.getReportData()
    }
    @IBAction func clearBtnAction(_ sender: UIButton){
        self.tfParty.text = ""
        self.tfProductGrp.text = ""
        self.tfProducts.text = ""
        self.updateTotalView()
        self.arrSeleParty = [typeAliasDictionary]()
        self.arrSeleProdGrp = [typeAliasDictionary]()
        self.arrProducts = [typeAliasDictionary]()
        self.arrSeleProd = [typeAliasDictionary]()
    }
    
    
    //MARK:- TABLEVIE METHODS
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrReport.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PurchaseReportCell", for: indexPath) as? PurchaseReportCell{
            let dict = self.arrReport[indexPath.row]
            let rate = Double("\(dict[RES_KEY.Rate] ?? "" as AnyObject)") ?? 0.00
            let amt = Double("\(dict[RES_KEY.Amount] ?? "" as AnyObject)") ?? 0.00
            cell.lblSrNo.text = "\(indexPath.row+1)"
            cell.lblInvoiceDate.text = dict.isKeyNull(RES_KEY.Invoice_Date) ? "-":"\(dict[RES_KEY.Invoice_Date]!)"
            cell.lblInvoiceNo.text = dict.isKeyNull(RES_KEY.INVOICE_NO) ? "-":"\(dict[RES_KEY.INVOICE_NO]!)"
            cell.lblBookName.text = dict.isKeyNull(RES_KEY.Book_Name) ? "-":"\(dict[RES_KEY.Book_Name]!)"
            cell.lblPartyName.text = dict.isKeyNull(RES_KEY.Party_Name) ? "-":"\(dict[RES_KEY.Party_Name]!)"
            cell.lblGrpName.text = dict.isKeyNull(RES_KEY.Group_Name) ? "-":"\(dict[RES_KEY.Group_Name]!)"
            cell.lblProdName.text = dict.isKeyNull(RES_KEY.Product_Name) ? "-":"\(dict[RES_KEY.Product_Name]!)"
            cell.lblPcs.text = dict.isKeyNull(RES_KEY.Pcs) ? "-":"\(dict[RES_KEY.Pcs]!)"
            cell.lblQnt.text = dict.isKeyNull(RES_KEY.Qty) ? "-":"\(dict[RES_KEY.Qty]!)"
            cell.lblUnit.text = dict.isKeyNull(RES_KEY.Unit) ? "-":"\(dict[RES_KEY.Unit]!)"
            cell.lblRate.text = rate == 0.00 ? "-":withSeprate(val: rate)
            cell.lblAmount.text = amt == 0.00 ? "-":withSeprate(val: amt)
            
            if (indexPath.row == self.arrReport.count-1 && self.arrReport.count < self.totalRecords){
                self.getReportData()
            }
            
            return cell
        }
        return PurchaseReportCell()
    }
}
