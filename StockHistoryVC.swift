//
//  StockHistoryVC.swift
//  Charu Industries
//
//  Created by iMac on 25/11/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

class StockHistoryReportCell: UITableViewCell {
    
    @IBOutlet weak var lblSerialNo: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblAccountName: UILabel!
    @IBOutlet weak var lblProductGroup: UILabel!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblInQty: UILabel!
    @IBOutlet weak var lblInRate: UILabel!
    @IBOutlet weak var lblOutQty: UILabel!
    @IBOutlet weak var lblOutRate: UILabel!
    @IBOutlet weak var lblBalQty: UILabel!
    @IBOutlet weak var lblBalRate: UILabel!
    
}

class StockHistoryVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, JDSelectionDelegate, AppNavigationControllerDelegate {
    
    @IBOutlet weak var tfFromDate: UITextField!
    @IBOutlet weak var tfToDate: UITextField!
    @IBOutlet weak var tfProductGroup: UITextField!
    @IBOutlet weak var tfProductName: UITextField!
    @IBOutlet weak var lblInQty: UILabel!
    @IBOutlet weak var lblOutQty: UILabel!
    @IBOutlet weak var lblBalQty: UILabel!
    @IBOutlet weak var btnReport: UIButton!
    @IBOutlet weak var btnClear: UIButton!
    @IBOutlet weak var viewReportBG: UIView!
    @IBOutlet weak var heightTable: NSLayoutConstraint!
    @IBOutlet weak var tableReport: UITableView!
    
    @IBOutlet weak var tfCarMakeName: UITextField!
    @IBOutlet weak var tfCarBarndName: UITextField!
    @IBOutlet weak var tfCarYear: UITextField!
    
    fileprivate let userInfo = GetSetModel.getUserInfo()
    fileprivate let dateFormatter = DateFormatter()
    fileprivate let datePicker = UIDatePicker()
    fileprivate var arrProductGroup = [typeAliasDictionary]()
    fileprivate var arrSeleProductGroup = [typeAliasDictionary]()
    fileprivate var arrProductName = [typeAliasDictionary]()
    fileprivate var arrSeleProductName = [typeAliasDictionary]()
    fileprivate var arrReport = [typeAliasDictionary]()
    
    fileprivate var arrCarMake = [typeAliasDictionary]()
    fileprivate var arrSeleCarMake = [typeAliasDictionary]()
    fileprivate var arrCarBrand = [typeAliasDictionary]()
    fileprivate var arrSeleCarBrand = [typeAliasDictionary]()
    fileprivate var arrCarYear = [typeAliasDictionary]()
    fileprivate var arrSeleCarYear = [typeAliasDictionary]()
    
    let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    let mainStory = UIStoryboard(name: "Main", bundle: nil)

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
        self.tfCarMakeName.setRightImage(UIImage(named: "ic_drop_down")!.tinted(with: .darkGray))
        self.tfCarBarndName.setRightImage(UIImage(named: "ic_drop_down")!.tinted(with: .darkGray))
        self.tfCarYear.setRightImage(UIImage(named: "ic_drop_down")!.tinted(with: .darkGray))
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
        getProductGrpList()
        getProductNameList()
        
//        getCarMakeList()
//        getCarBrandList()
//        getCarYearList()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.heightTable.constant = self.viewReportBG.frame.height-91
    }
    
    //MARK:- NAVIGATION METHODS
    func setUpNavigationBar(){
        Obj_AppDelegate.navigationController.setCustomTitle("Stock History Report")
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
        data += "<TR><td align='center' colspan=\"15\"><b>Stock History Report</b></td>";
        data += "</TR>";
        data += "<TR bgcolor=\"#E4DDC2\">";
        data += "<TH align='center' style=\"white-space: nowrap;font-size:10px;\"><b>Sr No</b></TH>";
        data += "<TH align='center' style=\"white-space: nowrap;font-size:10px;\"><b>Invoice Date</b></TH>";
        data += "<TH align='center' style=\"white-space: nowrap;font-size:10px; \"><b>Type</b></TH>";
        data += "<TH align='center' style=\"white-space: nowrap;font-size:10px; \"><b>Account Name</b></TH>";
        data += "<TH align='center' style=\"white-space: nowrap;font-size:10px; \"><b>Product Group</b></TH>";
        data += "<TH align='center' style=\"white-space: nowrap;font-size:10px; \"><b>Product Name</b></TH>";
        data += "<TH align='center' style=\"white-space: nowrap;font-size:10px; \"><b>In.Qty</b></TH>";
        data += "<TH align='center' style=\"white-space: nowrap;font-size:10px; \"><b>In.Rate</b></TH>";
        data += "<TH align='center' style=\"white-space: nowrap;font-size:10px; \"><b>Out.Qty</b></TH>";
        data += "<TH align='center' style=\"white-space: nowrap;font-size:10px; \"><b>Out.Rate</b></TH>";
        data += "<TH align='center' style=\"white-space: nowrap;font-size:10px; \"><b>Bal.Qty</b></TH>";
        data += "<TH align='center' style=\"white-space: nowrap;font-size:10px; \"><b>Bal.Rate</b></TH>";
        data += "</TR>";
        var srNo = 0
        for dict in self.arrReport{
            srNo += 1
            let invoiceDate = dict.isKeyNull(RES_KEY.Invoice_Date) ? "-":"\(dict[RES_KEY.Invoice_Date]!)"
            let type = dict.isKeyNull(RES_KEY.Proc_Name) ? "-":"\(dict[RES_KEY.Proc_Name]!)"
            let accountName = dict.isKeyNull(RES_KEY.Ac_Desc) ? "-":"\(dict[RES_KEY.Ac_Desc]!)"
            let productGroup = dict.isKeyNull(RES_KEY.Stone_Type_Name) ? "-":"\(dict[RES_KEY.Stone_Type_Name]!)"
            let productName = dict.isKeyNull(RES_KEY.Cat_Name) ? "-":"\(dict[RES_KEY.Cat_Name]!)"
            let inQty = Int("\(dict[RES_KEY.Plus_Qty] ?? "" as AnyObject)") ?? 0
            let inRate = Double("\(dict[RES_KEY.Plus_Rate] ?? "" as AnyObject)") ?? 0.00
            let plusQty = Int("\(dict[RES_KEY.Less_Qty] ?? "" as AnyObject)") ?? 0
            let plusRate = Double("\(dict[RES_KEY.Less_Rate] ?? "" as AnyObject)") ?? 0.00
            let balQty = Int("\(dict[RES_KEY.R_Bal_Qty] ?? "" as AnyObject)") ?? 0
            let balRate = Double("\(dict[RES_KEY.R_Bal_Rate] ?? "" as AnyObject)") ?? 0.00
            data += "<TR>";
            data += "<TD align='center' style =\"white-space: nowrap;font-size:7px;\">\(srNo)</TD>";
            data += "<TD align='center' style =\"white-space: nowrap;font-size:7px;\">\(invoiceDate)</TD>";
            data += "<TD align='center' style =\"word-wrap: break-word;font-size:7px;\">\(type)</TD>";
            data += "<TD align='center' style =\"word-wrap: break-word;font-size:7px;\">\(accountName)</TD>";
            data += "<TD align='center' style =\"word-wrap: break-word;font-size:7px;\">\(productGroup)</TD>";
            data += "<TD align='center' style =\"word-wrap: break-word;font-size:7px;\">\(productName)</TD>";
            data += "<TD align='center' style =\"word-wrap: break-word;font-size:7px;\">\(inQty)</TD>";
            data += "<TD align='center' style =\"word-wrap: break-word;font-size:7px;\">\(inRate)</TD>";
            data += "<TD align='center' style =\"word-wrap: break-word;font-size:7px;\">\(plusQty)</TD>";
            data += "<TD align='center' style =\"word-wrap: break-word;font-size:7px;\">\(plusRate)</TD>";
            data += "<TD align='center' style =\"word-wrap: break-word;font-size:7px;\">\(balQty)</TD>";
            data += "<TD align='center' style =\"word-wrap: break-word;font-size:7px;\">\(balRate)</TD>";
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
        let filePath = "\(directory)/stockHistoryReport.pdf"
        pdfData.write(toFile: filePath, atomically: true)
        let fileUrl = NSURL(fileURLWithPath: filePath)
        let activiyController = UIActivityViewController(activityItems: [fileUrl], applicationActivities: nil)
        Obj_AppDelegate.navigationController.present(activiyController, animated: true) {
            
        }
    }
    
    //MARK:- CUSTOME METHODS
    
    func getProductGrpList(){
        //        DesignModel.startActivityIndicator()
        let param = [REQ_KEY.ProdGrpCode: "",
                     REQ_KEY.Status: ""]
        Obj_OperationApi.callWebService(ApiMethod.GetProdGrpList, method: .post, parameters: param, onCompletion: { (responce) in
            print(responce)
            self.arrProductGroup = responce[RES_KEY.Data] as? [typeAliasDictionary] ?? [typeAliasDictionary]()
        }) { (errStr) in
            DesignModel.showMessage(errStr, for: self)
        }
    }
    
    func getProductNameList(){
        let userInfo = GetSetModel.getUserInfo()
        var prodGroupCode = 0
        if let proGrpDict = self.arrSeleProductGroup.first{
            prodGroupCode = Int("\(proGrpDict[RES_KEY.P_Grp_Code] ?? "" as AnyObject)") ?? 0
        }
        let mainGroupName = ""
        //        if let proGrpDict = self.arrSeleMainGroupName.first{
        //            mainGroupName = (proGrpDict[RES_KEY.Main_Group] as AnyObject) as! String
        //        }
        DesignModel.startActivityIndicator()
        let param = [REQ_KEY.ProdGrpCode: "\(prodGroupCode == 0 ? "" : "\(prodGroupCode)")",
            REQ_KEY.MainGrpName: mainGroupName,
            REQ_KEY.CompCode: "\(userInfo[RES_KEY.CompCode] ?? "" as AnyObject)",
            REQ_KEY.ProductCode: "",
            REQ_KEY.Status: ""]
        Obj_OperationApi.callWebService(ApiMethod.GetProductList, method: .post, parameters: param, onCompletion: { (responce) in
            print(responce)
            DesignModel.stopActivityIndicator()
            self.arrProductName = responce[RES_KEY.Data] as? [typeAliasDictionary] ?? [typeAliasDictionary]()
            self.getCarMakeList()
        }) { (errStr) in
            DesignModel.showMessage(errStr, for: self)
        }
    }
    
    func getReportData(){
        let userInfo = GetSetModel.getUserInfo()
        if self.arrSeleProductGroup.count < 1 {
            DesignModel.showMessage("Please select product group", for: self)
            return
        }
        DesignModel.startActivityIndicator()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let fromDate = dateFormatter.date(from: "\(self.tfFromDate.text!)") ?? Date()
        let toDate = dateFormatter.date(from: "\(self.tfToDate.text!)") ?? Date()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        var prodGroupCode = 0
        if let proGrpDict = self.arrSeleProductGroup.first{
            prodGroupCode = Int("\(proGrpDict[RES_KEY.P_Grp_Code] ?? "" as AnyObject)") ?? 0
        }
        var prodCode = 0
        if let proGrpDict = self.arrSeleProductName.first{
            prodCode = Int("\(proGrpDict[RES_KEY.Product_Code] ?? "" as AnyObject)") ?? 0
        }
        let carMakeDict = self.arrSeleCarMake.first ?? typeAliasDictionary()
        let carBrandDict = self.arrSeleCarBrand.first ?? typeAliasDictionary()
        let carYearDict = self.arrSeleCarYear.first ?? typeAliasDictionary()
        let param = [REQ_KEY.ProdGrpCode: "\(prodGroupCode == 0 ? "" : "\(prodGroupCode)")",
            REQ_KEY.YearCode: GetSetModel.getYearCode(),
            REQ_KEY.FromDate: dateFormatter.string(from: fromDate),
            REQ_KEY.ToDate: dateFormatter.string(from: toDate),
            REQ_KEY.ProdCode: "\(prodCode == 0 ? "" : "\(prodCode)")",
            REQ_KEY.CarMakeName: "\(carMakeDict[RES_KEY.CAR_MAKE] ?? "" as AnyObject)",
            REQ_KEY.CarBrandName: "\(carBrandDict[RES_KEY.BRAND_NAME] ?? "" as AnyObject)",
            REQ_KEY.CarYearName: "\(carYearDict[RES_KEY.CAR_YEAR] ?? "" as AnyObject)",
            REQ_KEY.CompCode: "\(userInfo[RES_KEY.CompCode] ?? "" as AnyObject)"]
        Obj_OperationApi.callWebService(ApiMethod.GetStockHistoryReport, method: .post, parameters: param, onCompletion: { (responce) in
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
    
    func getCarMakeList(){
        let userInfo = GetSetModel.getUserInfo()
        var prodGroupCode = 0
        if let proGrpDict = self.arrSeleProductGroup.first{
            prodGroupCode = Int("\(proGrpDict[RES_KEY.P_Grp_Code] ?? "" as AnyObject)") ?? 0
        }
        var prodCode = 0
        if let proDict = self.arrSeleProductName.first{
            prodCode = Int("\(proDict[RES_KEY.Product_Code] ?? "" as AnyObject)") ?? 0
        }
        let param = [REQ_KEY.ProdGrpCode: "\(prodGroupCode == 0 ? "" : "\(prodGroupCode)")",
            REQ_KEY.ProductCode: "\(prodCode == 0 ? "" : "\(prodCode)")",
            REQ_KEY.MainGrpName: "",
            REQ_KEY.CarMakeName: "",
            REQ_KEY.CompCode: "\(userInfo[RES_KEY.CompCode] ?? "" as AnyObject)"]
        Obj_OperationApi.callWebService(ApiMethod.GetCarMakeList, method: .post, parameters: param, onCompletion: { (responce) in
            //            print(responce)
            self.arrCarMake = responce[RES_KEY.Data] as? [typeAliasDictionary] ?? [typeAliasDictionary]()
            self.getCarBrandList()
        }) { (errStr) in
            self.arrCarMake.removeAll()
            self.arrCarBrand.removeAll()
            self.arrCarYear.removeAll()
            //            DesignModel.showMessage(errStr, for: self)
        }
    }
    
    func getCarBrandList(){
        let userInfo = GetSetModel.getUserInfo()
        var prodGroupCode = 0
        if let proGrpDict = self.arrSeleProductGroup.first{
            prodGroupCode = Int("\(proGrpDict[RES_KEY.P_Grp_Code] ?? "" as AnyObject)") ?? 0
        }
        var prodCode = 0
        if let proDict = self.arrSeleProductName.first{
            prodCode = Int("\(proDict[RES_KEY.Product_Code] ?? "" as AnyObject)") ?? 0
        }
        let carMakeDict = self.arrSeleCarMake.first ?? typeAliasDictionary()
        let param = [REQ_KEY.ProdGrpCode: "\(prodGroupCode == 0 ? "" : "\(prodGroupCode)")",
            REQ_KEY.ProductCode: "\(prodCode == 0 ? "" : "\(prodCode)")",
            REQ_KEY.MainGrpName: "",
            REQ_KEY.CarMakeName: "\(carMakeDict[RES_KEY.CAR_MAKE] ?? "" as AnyObject)",
            REQ_KEY.CarBrandName: "",
            REQ_KEY.CompCode: "\(userInfo[RES_KEY.CompCode] ?? "" as AnyObject)"]
        Obj_OperationApi.callWebService(ApiMethod.GetCarBrandList, method: .post, parameters: param, onCompletion: { (responce) in
            print(responce)
            self.arrCarBrand = responce[RES_KEY.Data] as? [typeAliasDictionary] ?? [typeAliasDictionary]()
            self.getCarYearList()
        }) { (errStr) in
            self.arrCarBrand.removeAll()
            self.arrCarYear.removeAll()
            //            DesignModel.showMessage(errStr, for: self)
        }
    }
    
    func getCarYearList(){
        let userInfo = GetSetModel.getUserInfo()
        var prodGroupCode = 0
        if let proGrpDict = self.arrSeleProductGroup.first{
            prodGroupCode = Int("\(proGrpDict[RES_KEY.P_Grp_Code] ?? "" as AnyObject)") ?? 0
        }
        var prodCode = 0
        if let proDict = self.arrSeleProductName.first{
            prodCode = Int("\(proDict[RES_KEY.Product_Code] ?? "" as AnyObject)") ?? 0
        }
        let carMakeDict = self.arrSeleCarMake.first ?? typeAliasDictionary()
        let carBrandDict = self.arrSeleCarBrand.first ?? typeAliasDictionary()
        let param = [REQ_KEY.ProdGrpCode: "\(prodGroupCode == 0 ? "" : "\(prodGroupCode)")",
            REQ_KEY.ProductCode: "\(prodCode == 0 ? "" : "\(prodCode)")",
            REQ_KEY.MainGrpName: "",
            REQ_KEY.CarMakeName: "\(carMakeDict[RES_KEY.CAR_MAKE] ?? "" as AnyObject)",
            REQ_KEY.CarBrandName: "\(carBrandDict[RES_KEY.BRAND_NAME] ?? "" as AnyObject)",
            REQ_KEY.CarYearName: "",
            REQ_KEY.CompCode: "\(userInfo[RES_KEY.CompCode] ?? "" as AnyObject)"]
        Obj_OperationApi.callWebService(ApiMethod.GetCarYearList, method: .post, parameters: param, onCompletion: { (responce) in
            print(responce)
            self.arrCarYear = responce[RES_KEY.Data] as? [typeAliasDictionary] ?? [typeAliasDictionary]()
        }) { (errStr) in
            self.arrCarYear.removeAll()
            //            DesignModel.showMessage(errStr, for: self)
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
            let keys = [JD_UNIQUE_KEY: RES_KEY.P_Grp_Code,
                        JD_VALUE_KEY: RES_KEY.P_Grp_C_Name] as typeAliasDictionary
            self.showSelection("Select Product Group", array: self.arrProductGroup, arrSelected: self.arrSeleProductGroup, dictKey: keys, inputType: .GROUP, notAvailableMessage: "No product group found.", selectionType: .SINGLE)
            return false
        }else if textField == self.tfProductName{
            let keys = [JD_UNIQUE_KEY: RES_KEY.Product_Code,
                        JD_VALUE_KEY: RES_KEY.Procuct_Name] as typeAliasDictionary
            self.showSelection("Select Product Name", array: self.arrProductName, arrSelected: self.arrSeleProductName, dictKey: keys, inputType: .PRODUCT, notAvailableMessage: "No product name found.", selectionType: .SINGLE)
            return false
        }else if textField == self.tfCarMakeName{
            let keys = [JD_UNIQUE_KEY: RES_KEY.CAR_MAKE,
                        JD_VALUE_KEY: RES_KEY.CAR_MAKE] as typeAliasDictionary
            self.showSelection("Select Car Make Name", array: self.arrCarMake, arrSelected: self.arrSeleCarMake, dictKey: keys, inputType: .CAR, notAvailableMessage: "No car make name found.", selectionType: .SINGLE)
            return false
        }else if textField == self.tfCarBarndName{
            let keys = [JD_UNIQUE_KEY: RES_KEY.BRAND_NAME,
                        JD_VALUE_KEY: RES_KEY.BRAND_NAME] as typeAliasDictionary
            self.showSelection("Select Car Brand Name", array: self.arrCarBrand, arrSelected: self.arrSeleCarBrand, dictKey: keys, inputType: .BRAND, notAvailableMessage: "No car brand name found.", selectionType: .SINGLE)
            return false
        }else if textField == self.tfCarYear{
            let keys = [JD_UNIQUE_KEY: RES_KEY.CAR_YEAR,
                        JD_VALUE_KEY: RES_KEY.CAR_YEAR] as typeAliasDictionary
            self.showSelection("Select Car Year Name", array: self.arrCarYear, arrSelected: self.arrSeleCarYear, dictKey: keys, inputType: .YEAR, notAvailableMessage: "No car year name found.", selectionType: .SINGLE)
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
            self.arrSeleProductGroup = arrSelected
            if arrSelected.count > 0{
                self.tfProductGroup.text = dict!.isKeyNull(RES_KEY.P_Grp_C_Name) ? "-":"\(dict![RES_KEY.P_Grp_C_Name]!)"
            }else {
                self.tfProductGroup.text = ""
            }
            getProductNameList()
        }else if inputType == .PRODUCT{
            self.arrSeleProductName = arrSelected
            if arrSelected.count > 0{
                self.tfProductName.text = dict!.isKeyNull(RES_KEY.Procuct_Name) ? "-":"\(dict![RES_KEY.Procuct_Name]!)"
            }else {
                self.tfProductName.text = ""
            }
        }else if inputType == .CAR{
            self.arrSeleCarMake = arrSelected
            if arrSelected.count > 0{
                self.tfCarMakeName.text = dict!.isKeyNull(RES_KEY.CAR_MAKE) ? "-":"\(dict![RES_KEY.CAR_MAKE]!)"
            }else {
                self.tfCarMakeName.text = ""
            }
        }else if inputType == .BRAND{
            self.arrSeleCarBrand = arrSelected
            if arrSelected.count > 0{
                self.tfCarBarndName.text = dict!.isKeyNull(RES_KEY.BRAND_NAME) ? "-":"\(dict![RES_KEY.BRAND_NAME]!)"
            }else {
                self.tfCarBarndName.text = ""
            }
        }else if inputType == .YEAR{
            self.arrSeleCarYear = arrSelected
            if arrSelected.count > 0{
                self.tfCarYear.text = dict!.isKeyNull(RES_KEY.CAR_YEAR) ? "-":"\(dict![RES_KEY.CAR_YEAR]!)"
            }else {
                self.tfCarYear.text = ""
            }
        }
    }
    
    //MARK:- Button Actions
    @IBAction func reportBtnAction(_ sender: UIButton){
//        getReportData()
        if self.arrSeleProductGroup.count < 1 {
            DesignModel.showMessage("Please select product group", for: self)
            return
        }
        let stockHistoryDetailReportVC = mainStory.instantiateViewController(withIdentifier: "StockHistoryDetailVC") as! StockHistoryDetailVC
        stockHistoryDetailReportVC.arrSeleProductName = arrSeleProductName
        stockHistoryDetailReportVC.arrSeleProductGroup = arrSeleProductGroup
        stockHistoryDetailReportVC.arrSeleCarMake = arrSeleCarMake
        stockHistoryDetailReportVC.arrSeleCarBrand = arrSeleCarBrand
        stockHistoryDetailReportVC.arrSeleCarYear = arrSeleCarYear
        stockHistoryDetailReportVC.toDate = self.tfToDate.text!
        stockHistoryDetailReportVC.fromDate = self.tfFromDate.text!
        obj_AppDelegate.navigationController.pushViewController(stockHistoryDetailReportVC, animated: true)
    }
        
    @IBAction func clearBtnAction(_ sebder: UIButton){
        dateFormatter.dateFormat = "dd-MM-yyyy"
        self.tfFromDate.text = "\(self.userInfo[RES_KEY.From_Date] ?? "" as AnyObject)"
        self.tfToDate.text = dateFormatter.string(from: Date())
        self.tfProductGroup.text = ""
        self.tfProductName.text = ""
        self.tfCarMakeName.text = ""
        self.tfCarBarndName.text = ""
        self.tfCarYear.text = ""
        self.arrProductName = [typeAliasDictionary]()
        self.arrProductGroup = [typeAliasDictionary]()
        self.arrSeleProductName = [typeAliasDictionary]()
        self.arrSeleProductGroup = [typeAliasDictionary]()
        self.arrReport = [typeAliasDictionary]()
        self.arrSeleCarYear = [typeAliasDictionary]()
        self.arrSeleCarBrand = [typeAliasDictionary]()
        self.arrSeleCarMake = [typeAliasDictionary]()
        self.arrCarBrand = [typeAliasDictionary]()
        self.arrCarYear = [typeAliasDictionary]()
        self.arrCarMake = [typeAliasDictionary]()
        self.updateTotalView()
        self.tableReport.reloadData()
        self.viewReportBG.isHidden = true
    }
    
    func updateTotalView(){
        var totalInQty = 0
        var totalOutQty = 0
        var totalBalQty = 0
        for dict in self.arrReport{
            let inQty = Int("\(dict[RES_KEY.Plus_Qty] ?? "" as AnyObject)") ?? 0
            let outQty = Int("\(dict[RES_KEY.Less_Qty] ?? "" as AnyObject)") ?? 0
            let balQty = Int("\(dict[RES_KEY.R_Bal_Qty] ?? "" as AnyObject)") ?? 0
            totalInQty += inQty
            totalOutQty += outQty
            totalBalQty += balQty
        }
        self.lblInQty.text = "In.Qty \(totalInQty)"
        self.lblOutQty.text = "Out.Qty \(totalOutQty)"
        self.lblBalQty.text = "Bal.Qty \(totalBalQty)"
    }
    
    //MARK:- TableView Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrReport.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "StockHistoryReportCell", for: indexPath) as? StockHistoryReportCell{
            let dict = self.arrReport[indexPath.row]
            cell.lblSerialNo.text = "\(indexPath.row+1)"
            cell.lblDate.text = dict.isKeyNull(RES_KEY.Invoice_Date) ? "-":"\(dict[RES_KEY.Invoice_Date]!)"
            cell.lblType.text = dict.isKeyNull(RES_KEY.Proc_Name) ? "-":"\(dict[RES_KEY.Proc_Name]!)"
            cell.lblAccountName.text = dict.isKeyNull(RES_KEY.Ac_Desc) ? "-":"\(dict[RES_KEY.Ac_Desc]!)"
            cell.lblProductGroup.text = dict.isKeyNull(RES_KEY.Stone_Type_Name) ? "-":"\(dict[RES_KEY.Stone_Type_Name]!)"
            cell.lblProductName.text = dict.isKeyNull(RES_KEY.Cat_Name) ? "-":"\(dict[RES_KEY.Cat_Name]!)"
            let inQty = Int("\(dict[RES_KEY.Plus_Qty] ?? "" as AnyObject)") ?? 0
            cell.lblInQty.text = inQty == 0 ? "0":String(inQty)
            let inRate = Double("\(dict[RES_KEY.Plus_Rate] ?? "" as AnyObject)") ?? 0.00
            cell.lblInRate.text = inRate == 0.00 ? "-":withSeprate(val: inRate)
            let plusQty = Int("\(dict[RES_KEY.Less_Qty] ?? "" as AnyObject)") ?? 0
            cell.lblOutQty.text = plusQty == 0 ? "0":String(plusQty)
            let plusRate = Double("\(dict[RES_KEY.Less_Rate] ?? "" as AnyObject)") ?? 0.00
            cell.lblOutRate.text = plusRate == 0.00 ? "-":withSeprate(val: plusRate)
            let balQty = Int("\(dict[RES_KEY.R_Bal_Qty] ?? "" as AnyObject)") ?? 0
            cell.lblBalQty.text = balQty == 0 ? "0":String(balQty)
            let balRate = Double("\(dict[RES_KEY.R_Bal_Rate] ?? "" as AnyObject)") ?? 0.00
            cell.lblBalRate.text = balRate == 0.00 ? "-":withSeprate(val: balRate)
            
            return cell
        }
        return StockHistoryReportCell()
    }

}
