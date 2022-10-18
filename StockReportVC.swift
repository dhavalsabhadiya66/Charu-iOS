//
//  StockReportVC.swift
//  Charu Industries
//
//  Created by admin on 03/09/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit
import SDWebImage

class StockReportVC: UIViewController, UITextFieldDelegate, AppNavigationControllerDelegate, JDSelectionDelegate {
    
    
    @IBOutlet weak var tfDate: UITextField!
    @IBOutlet weak var tfMainGroupName: UITextField!
    @IBOutlet weak var tfProductGroup: UITextField!
    @IBOutlet weak var tfProductName: UITextField!
    @IBOutlet weak var tfCarMakeName: UITextField!
    @IBOutlet weak var tfCarBarndName: UITextField!
    @IBOutlet weak var tfCarYear: UITextField!
    @IBOutlet weak var btnReport: UIButton!
    @IBOutlet weak var btnClear: UIButton!
    
    
    fileprivate let dateFormatter = DateFormatter()
    fileprivate let datePicker = UIDatePicker()
    fileprivate var arrReport = [typeAliasDictionary]()
    fileprivate var arrMainGroupName = [typeAliasDictionary]()
    fileprivate var arrSeleMainGroupName = [typeAliasDictionary]()
    fileprivate var arrProductGroup = [typeAliasDictionary]()
    fileprivate var arrSeleProductGroup = [typeAliasDictionary]()
    fileprivate var arrProductName = [typeAliasDictionary]()
    fileprivate var arrSeleProductName = [typeAliasDictionary]()
    fileprivate var arrCarMake = [typeAliasDictionary]()
    fileprivate var arrSeleCarMake = [typeAliasDictionary]()
    fileprivate var arrCarBrand = [typeAliasDictionary]()
    fileprivate var arrSeleCarBrand = [typeAliasDictionary]()
    fileprivate var arrCarYear = [typeAliasDictionary]()
    fileprivate var arrSeleCarYear = [typeAliasDictionary]()
    fileprivate var pageNo = 0
    fileprivate var totalRecords = 0
    
    let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    let mainStory = UIStoryboard(name: "Main", bundle: nil)
    
    
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        dateFormatter.calendar = Calendar.current
        dateFormatter.timeZone = Calendar.current.timeZone
        datePicker.datePickerMode = .date
        datePicker.calendar = Calendar.current
        datePicker.timeZone = Calendar.current.timeZone
        self.tfDate.inputView = datePicker
        self.tfDate.setRightImage(UIImage(named: "ic_drop_down")!.tinted(with: .darkGray))
        self.tfMainGroupName.setRightImage(UIImage(named: "ic_drop_down")!.tinted(with: .darkGray))
        self.tfProductGroup.setRightImage(UIImage(named: "ic_drop_down")!.tinted(with: .darkGray))
        self.tfProductName.setRightImage(UIImage(named: "ic_drop_down")!.tinted(with: .darkGray))
        self.tfCarMakeName.setRightImage(UIImage(named: "ic_drop_down")!.tinted(with: .darkGray))
        self.tfCarBarndName.setRightImage(UIImage(named: "ic_drop_down")!.tinted(with: .darkGray))
        self.tfCarYear.setRightImage(UIImage(named: "ic_drop_down")!.tinted(with: .darkGray))
        
        getMainGrpNameList()
        getProductGrpList()
        getProductNameList()
//        getCarMakeList()
//        getCarBrandList()
//        getCarYearList()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUpNavigationBar()
        if self.tfDate.text?.trim() == ""{
            dateFormatter.dateFormat = "dd-MM-yyyy"
            self.tfDate.text = self.dateFormatter.string(from: Date())
        }
        
    }
    
    
    //MARK:- NAVIGATION METHODS
    func setUpNavigationBar(){
        Obj_AppDelegate.navigationController.setCustomTitle("Stock Report")
        Obj_AppDelegate.navigationController.navigationDelegate = self
        Obj_AppDelegate.navigationController.setBack()
    }
    func appNavigationController_BackAction() {
        Obj_AppDelegate.navigationController.popViewController(animated: true)
    }
    
    //MARK:- CUSTOME METHODS
    
    func getMainGrpNameList(){
//        DesignModel.startActivityIndicator()
        let userInfo = GetSetModel.getUserInfo()
        let param = [REQ_KEY.CompCode: "\(userInfo[RES_KEY.CompCode] ?? "" as AnyObject)",
                     REQ_KEY.MainGrpName: ""]
        Obj_OperationApi.callWebService(ApiMethod.MainGrpList, method: .post, parameters: param, onCompletion: { (responce) in
//            print(responce)
            self.arrMainGroupName = responce[RES_KEY.Data] as? [typeAliasDictionary] ?? [typeAliasDictionary]()
        }) { (errStr) in
            DesignModel.showMessage(errStr, for: self)
        }
    }
    
    func getProductGrpList(){
//        DesignModel.startActivityIndicator()
        let param = [REQ_KEY.ProdGrpCode: "",
                     REQ_KEY.Status: ""]
        Obj_OperationApi.callWebService(ApiMethod.GetProdGrpList, method: .post, parameters: param, onCompletion: { (responce) in
//            print(responce)
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
//            print(responce)
            DesignModel.stopActivityIndicator()
            self.arrProductName = responce[RES_KEY.Data] as? [typeAliasDictionary] ?? [typeAliasDictionary]()
            self.getCarMakeList()
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
        if textField == self.tfMainGroupName{
            let keys = [JD_UNIQUE_KEY: RES_KEY.STATUS,
                        JD_VALUE_KEY: RES_KEY.Main_Group] as typeAliasDictionary
            self.showSelection("Select Main Group Name", array: self.arrMainGroupName, arrSelected: self.arrSeleMainGroupName, dictKey: keys, inputType: .MAIN_GROUP, notAvailableMessage: "No main group name found!!", selectionType: .SINGLE)
            return false
        }else if textField == self.tfProductGroup{
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
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField == self.tfDate{
            dateFormatter.dateFormat = "dd-MM-yyyy"
            textField.text = self.dateFormatter.string(from: self.datePicker.date)
        }
        return true
    }
    
    //MARK:- SELECTION DELEGATE
    func selectedOption(arrSelected: [typeAliasDictionary], inputType: INPUT_TYPE) {
        let dict = arrSelected.first
        if inputType == .MAIN_GROUP{
            self.arrSeleMainGroupName = arrSelected
            if arrSelected.count > 0{
                self.tfMainGroupName.text = dict!.isKeyNull(RES_KEY.Main_Group) ? "-":"\(dict![RES_KEY.Main_Group]!)"
            }else{
                self.tfMainGroupName.text = ""
            }
        }else if inputType == .GROUP{
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
    
    
    //MARK:- UIBUTTON ACTION
    @IBAction func reportBtnAction(_ sender: UIButton){
        let stockDetailReportVC = mainStory.instantiateViewController(withIdentifier: "StockDetailReportVC") as! StockDetailReportVC
        stockDetailReportVC.arrSeleProductName = arrSeleProductName
        stockDetailReportVC.arrSeleProductGroup = arrSeleProductGroup
        stockDetailReportVC.arrSeleMainGroupName = arrSeleMainGroupName
        stockDetailReportVC.arrSeleCarMake = arrSeleCarMake
        stockDetailReportVC.arrSeleCarBrand = arrSeleCarBrand
        stockDetailReportVC.arrSeleCarYear = arrSeleCarYear
        stockDetailReportVC.toDate = self.tfDate.text!
        obj_AppDelegate.navigationController.pushViewController(stockDetailReportVC, animated: true)
    }
    @IBAction func clearBtnAction(_ sender: UIButton){
        self.tfDate.resignFirstResponder()
        self.tfDate.text = self.dateFormatter.string(from: Date())
        self.datePicker.setDate(Date(), animated: false)
        self.tfProductGroup.text = ""
        self.tfProductName.text = ""
        self.tfMainGroupName.text = ""
        self.tfCarMakeName.text = ""
        self.tfCarBarndName.text = ""
        self.tfCarYear.text = ""
        self.arrReport = [typeAliasDictionary]()
        self.arrProductGroup = [typeAliasDictionary]()
        self.arrProductName = [typeAliasDictionary]()
        self.arrMainGroupName = [typeAliasDictionary]()
        self.arrSeleCarYear = [typeAliasDictionary]()
        self.arrSeleCarBrand = [typeAliasDictionary]()
        self.arrSeleCarMake = [typeAliasDictionary]()
        self.arrCarBrand = [typeAliasDictionary]()
        self.arrCarYear = [typeAliasDictionary]()
        self.arrCarMake = [typeAliasDictionary]()
        self.arrSeleProductGroup = [typeAliasDictionary]()
        self.arrSeleProductName = [typeAliasDictionary]()
        self.arrSeleMainGroupName = [typeAliasDictionary]()
        self.arrReport = [typeAliasDictionary]()
    }
}
