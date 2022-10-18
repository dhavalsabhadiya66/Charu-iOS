//
//  StockHistoryDetailVC.swift
//  Charu Industries
//
//  Created by iMac on 25/03/21.
//  Copyright © 2021 admin. All rights reserved.
//

import UIKit

class StockHistoryDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource, AppNavigationControllerDelegate {
    
    @IBOutlet weak var viewReportBG: UIView!
    @IBOutlet weak var heightTable: NSLayoutConstraint!
    @IBOutlet weak var tableReport: UITableView!
    
    @IBOutlet weak var lblInQty: UILabel!
    @IBOutlet weak var lblOutQty: UILabel!
    @IBOutlet weak var lblBalQty: UILabel!
    
    var arrProductGroup = [typeAliasDictionary]()
    var arrSeleProductGroup = [typeAliasDictionary]()
    var arrProductName = [typeAliasDictionary]()
    var arrSeleProductName = [typeAliasDictionary]()
    var arrReport = [typeAliasDictionary]()
    
    var arrCarMake = [typeAliasDictionary]()
    var arrSeleCarMake = [typeAliasDictionary]()
    var arrCarBrand = [typeAliasDictionary]()
    var arrSeleCarBrand = [typeAliasDictionary]()
    var arrCarYear = [typeAliasDictionary]()
    var arrSeleCarYear = [typeAliasDictionary]()
    let dateFormatter = DateFormatter()
    
    var fromDate = ""
    var toDate = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        getReportData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewReportBG.isHidden = self.arrReport.count < 1
        setUpNavigationBar()
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
    
    func getReportData(){
        let userInfo = GetSetModel.getUserInfo()
//        if self.arrSeleProductGroup.count < 1 {
//            DesignModel.showMessage("Please select product group", for: self)
//            return
//        }
        DesignModel.startActivityIndicator()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let fromDate = dateFormatter.date(from: "\(self.fromDate)") ?? Date()
        let toDate = dateFormatter.date(from: "\(self.toDate)") ?? Date()
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
