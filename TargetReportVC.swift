//
//  TargetReportVC.swift
//  Charu Industries
//
//  Created by iMac on 25/11/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

class TargetReportCell: UITableViewCell {
    
    @IBOutlet weak var lblSerialNo: UILabel!
    @IBOutlet weak var lblPartyName: UILabel!
    @IBOutlet weak var lblEmployeeName: UILabel!
    @IBOutlet weak var lblTargetValue: UILabel!
    @IBOutlet weak var lblAchieveValue: UILabel!
    
}

class TargetReportVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, JDSelectionDelegate, AppNavigationControllerDelegate {
    
    @IBOutlet weak var tfFromDate: UITextField!
    @IBOutlet weak var tfToDate: UITextField!
    @IBOutlet weak var tfProductGroup: UITextField!
    @IBOutlet weak var tfProductName: UITextField!
    @IBOutlet weak var lblTarget: UILabel!
    @IBOutlet weak var lblAchieve: UILabel!
    @IBOutlet weak var btnReport: UIButton!
    @IBOutlet weak var btnClear: UIButton!
    @IBOutlet weak var viewReportBG: UIView!
    @IBOutlet weak var heightTable: NSLayoutConstraint!
    @IBOutlet weak var tableReport: UITableView!
    
    fileprivate let userInfo = GetSetModel.getUserInfo()
    fileprivate let dateFormatter = DateFormatter()
    fileprivate let datePicker = UIDatePicker()
    fileprivate var arrEmplyeeName = [typeAliasDictionary]()
    fileprivate var arrSeleEmplyeeName = [typeAliasDictionary]()
    fileprivate var arrPartyName = [typeAliasDictionary]()
    fileprivate var arrSelePartyName = [typeAliasDictionary]()
    fileprivate var arrReport = [typeAliasDictionary]()

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
        self.tfProductGroup.setRightImage(UIImage(named: "ic_drop_down")!.tinted(with: .darkGray))
        self.tfProductName.setRightImage(UIImage(named: "ic_drop_down")!.tinted(with: .darkGray))
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
        self.viewReportBG.isHidden = self.arrReport.count < 1
        setUpNavigationBar()
        getEmployeeList()
        getPartyList()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.heightTable.constant = self.viewReportBG.frame.height-91
    }
    
    //MARK:- NAVIGATION METHODS
    func setUpNavigationBar(){
        Obj_AppDelegate.navigationController.setCustomTitle("Target Report")
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
        data += "<TR><td align='center' colspan=\"15\"><b>Target Report</b></td>";
        data += "</TR>";
        data += "<TR bgcolor=\"#E4DDC2\">";
        data += "<TH align='center' style=\"white-space: nowrap;font-size:10px;\"><b>Sr No</b></TH>";
        data += "<TH align='center' style=\"white-space: nowrap;font-size:10px;\"><b>Party Name</b></TH>";
        data += "<TH align='center' style=\"white-space: nowrap;font-size:10px; \"><b>Employee Name</b></TH>";
        data += "<TH align='center' style=\"white-space: nowrap;font-size:10px; \"><b>Target Value</b></TH>";
        data += "<TH align='center' style=\"white-space: nowrap;font-size:10px; \"><b>Achieve Value</b></TH>";
        data += "</TR>";
        var srNo = 0
        for dict in self.arrReport{
            srNo += 1
            let partyName = dict.isKeyNull(RES_KEY.Party_Name) ? "-":"\(dict[RES_KEY.Party_Name]!)"
            let employeeName = dict.isKeyNull(RES_KEY.EmpName) ? "-":"\(dict[RES_KEY.EmpName]!)"
            let targetValue = Double("\(dict[RES_KEY.Target_Val] ?? "" as AnyObject)") ?? 0.00
            let achieveValue = Double("\(dict[RES_KEY.Achieve_Val] ?? "" as AnyObject)") ?? 0.00
            data += "<TR>";
            data += "<TD align='center' style =\"white-space: nowrap;font-size:7px;\">\(srNo)</TD>";
            data += "<TD align='center' style =\"white-space: nowrap;font-size:7px;\">\(partyName)</TD>";
            data += "<TD align='center' style =\"word-wrap: break-word;font-size:7px;\">\(employeeName)</TD>";
            data += "<TD align='center' style =\"word-wrap: break-word;font-size:7px;\">\(targetValue)</TD>";
            data += "<TD align='center' style =\"word-wrap: break-word;font-size:7px;\">\(achieveValue)</TD>";
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
        let filePath = "\(directory)/targetReport.pdf"
        pdfData.write(toFile: filePath, atomically: true)
        let fileUrl = NSURL(fileURLWithPath: filePath)
        let activiyController = UIActivityViewController(activityItems: [fileUrl], applicationActivities: nil)
        Obj_AppDelegate.navigationController.present(activiyController, animated: true) {
            
        }
    }
    
    //MARK:- CUSTOME METHODS
    
    func getEmployeeList(){
        let userInfo = GetSetModel.getUserInfo()
        //        DesignModel.startActivityIndicator()
        let param = [REQ_KEY.EmpCode: "",
                     REQ_KEY.CompCode: "\(userInfo[RES_KEY.CompCode] ?? "" as AnyObject)"]
        Obj_OperationApi.callWebService(ApiMethod.EmpMasList, method: .post, parameters: param, onCompletion: { (responce) in
            print(responce)
            self.arrEmplyeeName = responce[RES_KEY.Data] as? [typeAliasDictionary] ?? [typeAliasDictionary]()
        }) { (errStr) in
            DesignModel.showMessage(errStr, for: self)
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
    
    func getTargetData(){
        let userInfo = GetSetModel.getUserInfo()
        DesignModel.startActivityIndicator()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let fromDate = dateFormatter.date(from: "\(self.tfFromDate.text!)") ?? Date()
        let toDate = dateFormatter.date(from: "\(self.tfToDate.text!)") ?? Date()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        var empCode = 0
        if let proGrpDict = self.arrSeleEmplyeeName.first{
            empCode = Int("\(proGrpDict[RES_KEY.Emp_Code] ?? "" as AnyObject)") ?? 0
        }
        var partyCode = 0
        if let proGrpDict = self.arrSelePartyName.first{
            partyCode = Int("\(proGrpDict[RES_KEY.Party_Code] ?? "" as AnyObject)") ?? 0
        }
        let param = [REQ_KEY.EmpCode: "\(empCode == 0 ? "" : "\(empCode)")",
            REQ_KEY.FromDate: dateFormatter.string(from: fromDate),
            REQ_KEY.ToDate: dateFormatter.string(from: toDate),
            REQ_KEY.PartyCode: "\(partyCode == 0 ? "" : "\(partyCode)")",
            REQ_KEY.CompCode: "\(userInfo[RES_KEY.CompCode] ?? "" as AnyObject)"]
        Obj_OperationApi.callWebService(ApiMethod.GetTargetReport, method: .post, parameters: param, onCompletion: { (responce) in
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
        if textField == self.tfProductGroup{
            let keys = [JD_UNIQUE_KEY: RES_KEY.Emp_Code,
                        JD_VALUE_KEY: RES_KEY.EmpName] as typeAliasDictionary
            self.showSelection("Select Employee Name", array: self.arrEmplyeeName, arrSelected: self.arrSeleEmplyeeName, dictKey: keys, inputType: .GROUP, notAvailableMessage: "No employee name found.", selectionType: .SINGLE)
            return false
        }else if textField == self.tfProductName{
            let keys = [JD_UNIQUE_KEY: RES_KEY.Party_Code,
                        JD_VALUE_KEY: RES_KEY.Party_Name] as typeAliasDictionary
            self.showSelection("Select Party Name", array: self.arrPartyName, arrSelected: self.arrSelePartyName, dictKey: keys, inputType: .PRODUCT, notAvailableMessage: "No party name found.", selectionType: .SINGLE)
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
        if inputType == .GROUP{
            self.arrSeleEmplyeeName = arrSelected
            if arrSelected.count > 0{
                self.tfProductGroup.text = dict!.isKeyNull(RES_KEY.EmpName) ? "-":"\(dict![RES_KEY.EmpName]!)"
            }else {
                self.tfProductGroup.text = ""
            }
        }else if inputType == .PRODUCT{
            self.arrSelePartyName = arrSelected
            if arrSelected.count > 0{
                self.tfProductName.text = dict!.isKeyNull(RES_KEY.Party_Name) ? "-":"\(dict![RES_KEY.Party_Name]!)"
            }else {
                self.tfProductName.text = ""
            }
        }
    }
    
    //MARK:- Button Actions
    @IBAction func reportBtnAction(_ sender: UIButton){
        getTargetData()
    }
        
    @IBAction func clearBtnAction(_ sebder: UIButton){
        dateFormatter.dateFormat = "dd-MM-yyyy"
        self.tfFromDate.text = "\(self.userInfo[RES_KEY.From_Date] ?? "" as AnyObject)"
        self.tfToDate.text = dateFormatter.string(from: Date())
        self.tfProductGroup.text = ""
        self.tfProductName.text = ""
        self.arrPartyName = [typeAliasDictionary]()
        self.arrEmplyeeName = [typeAliasDictionary]()
        self.arrSelePartyName = [typeAliasDictionary]()
        self.arrSeleEmplyeeName = [typeAliasDictionary]()
        self.arrReport = [typeAliasDictionary]()
        self.updateTotalView()
        self.tableReport.reloadData()
        self.viewReportBG.isHidden = true
    }
    
    func updateTotalView(){
        var totalAchieve = 0
        var totalTarget = 0
        for dict in self.arrReport{
            let achieve = Int("\(dict[RES_KEY.Achieve_Val] ?? "" as AnyObject)") ?? 0
            let target = Int("\(dict[RES_KEY.Target_Val] ?? "" as AnyObject)") ?? 0
            totalAchieve += achieve
            totalTarget += target
        }
        self.lblAchieve.text = "Achieve: \(withSeprate(val: totalAchieve))"
        self.lblTarget.text = "Target: \(withSeprate(val: totalTarget))"
    }
    
    //MARK:- TableView Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrReport.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TargetReportCell", for: indexPath) as? TargetReportCell{
            let dict = self.arrReport[indexPath.row]
            cell.lblSerialNo.text = "\(indexPath.row+1)"
            cell.lblPartyName.text = dict.isKeyNull(RES_KEY.Party_Name) ? "-":"\(dict[RES_KEY.Party_Name]!)"
            cell.lblEmployeeName.text = dict.isKeyNull(RES_KEY.EmpName) ? "-":"\(dict[RES_KEY.EmpName]!)"
            let targetValue = Double("\(dict[RES_KEY.Target_Val] ?? "" as AnyObject)") ?? 0.00
            cell.lblTargetValue.text = targetValue == 0.00 ? "-":withSeprate(val: targetValue)
            let achieveValue = Double("\(dict[RES_KEY.Achieve_Val] ?? "" as AnyObject)") ?? 0.00
            cell.lblAchieveValue.text = achieveValue == 0.00 ? "-":withSeprate(val: achieveValue)
            
            return cell
        }
        return TargetReportCell()
    }

}
