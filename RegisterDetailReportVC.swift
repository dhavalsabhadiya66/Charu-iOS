//
//  RegisterDetailReportVC.swift
//  Charu Industries
//
//  Created by iMac on 01/12/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

class RegisterReportCell: UITableViewCell {
    
    @IBOutlet weak var lblSrNo: UILabel!
    @IBOutlet weak var lblInvoiceDate: UILabel!
    @IBOutlet weak var lblInvoiceNo: UILabel!
    @IBOutlet weak var lblSuplrInvoiceNo: UILabel!
    @IBOutlet weak var lblBookName: UILabel!
    @IBOutlet weak var lblCustomerName: UILabel!
    @IBOutlet weak var lblQty: UILabel!
    @IBOutlet weak var lblGoodsAmount: UILabel!
    @IBOutlet weak var lblTaxAmount: UILabel!
    @IBOutlet weak var lblAdditionalAmount: UILabel!
    @IBOutlet weak var lblTotalAmount: UILabel!
    @IBOutlet weak var lblTaxableAmount: UILabel!
    @IBOutlet weak var lblCGSTAmount: UILabel!
    @IBOutlet weak var lblSGSTAmount: UILabel!
    @IBOutlet weak var lblIGSTAmount: UILabel!
    @IBOutlet weak var lblTerms: UILabel!
    @IBOutlet weak var lblGSTINNo: UILabel!
    
}

class RegisterDetailReportVC: UIViewController, UITableViewDelegate, UITableViewDataSource, AppNavigationControllerDelegate {
    
    @IBOutlet weak var viewReportBG: UIView!
    @IBOutlet weak var heightTable: NSLayoutConstraint!
    @IBOutlet weak var tableReport: UITableView!
    
    @IBOutlet weak var lblQty: UILabel!
    @IBOutlet weak var lblGoodsAmount: UILabel!
    @IBOutlet weak var lblTaxAmount: UILabel!
    @IBOutlet weak var lblAdditionalAmount: UILabel!
    @IBOutlet weak var lblTotalAmount: UILabel!
    @IBOutlet weak var lblTaxableAmount: UILabel!
    @IBOutlet weak var lblCGSTAmount: UILabel!
    @IBOutlet weak var lblSGSTAmount: UILabel!
    
    fileprivate let userInfo = GetSetModel.getUserInfo()
    var arrReport = [typeAliasDictionary]()
    var arrSeleBookName = [typeAliasDictionary]()
    var arrSelePartyName = [typeAliasDictionary]()
    var arrSeleType = [typeAliasDictionary]()
    fileprivate let dateFormatter = DateFormatter()
    
    var fromDate = ""
    var toDate = ""
    var pageNo = 0
    var totalRecords = 0

    override func viewWillAppear(_ animated: Bool) {
        setUpNavigationBar()
        getRegisterData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.heightTable.constant = self.viewReportBG.frame.height-130
    }
    
    //MARK:- NAVIGATION METHODS
    func setUpNavigationBar(){
        Obj_AppDelegate.navigationController.setCustomTitle("Register Report")
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
        data += "<TR><td align='center' colspan=\"15\"><b>Register Report</b></td>";
        data += "</TR>";
        data += "<TR bgcolor=\"#E4DDC2\">";
        data += "<TH align='center' style=\"white-space: nowrap;font-size:10px;\"><b>Sr No</b></TH>";
        data += "<TH align='center' style=\"white-space: nowrap;font-size:10px;\"><b>Invoice Date</b></TH>";
        data += "<TH align='center' style=\"white-space: nowrap;font-size:10px; \"><b>Invoice No</b></TH>";
        data += "<TH align='center' style=\"white-space: nowrap;font-size:10px; \"><b>Suplr Invoice No</b></TH>";
        data += "<TH align='center' style=\"white-space: nowrap;font-size:10px; \"><b>Book Name</b></TH>";
        data += "<TH align='center' style=\"white-space: nowrap;font-size:10px;\"><b>Customer Name</b></TH>";
        data += "<TH align='center' style=\"white-space: nowrap;font-size:10px;\"><b>QTY</b></TH>";
        data += "<TH align='center' style=\"white-space: nowrap;font-size:10px; \"><b>Goods Amount</b></TH>";
        data += "<TH align='center' style=\"white-space: nowrap;font-size:10px; \"><b>Tax Amount</b></TH>";
        data += "<TH align='center' style=\"white-space: nowrap;font-size:10px; \"><b>Additional Amount</b></TH>";
        data += "<TH align='center' style=\"white-space: nowrap;font-size:10px;\"><b>Total Amount</b></TH>";
        data += "<TH align='center' style=\"white-space: nowrap;font-size:10px;\"><b>Taxable Amount</b></TH>";
        data += "<TH align='center' style=\"white-space: nowrap;font-size:10px; \"><b>CGST Amount</b></TH>";
        data += "<TH align='center' style=\"white-space: nowrap;font-size:10px; \"><b>SGST Amount</b></TH>";
        data += "<TH align='center' style=\"white-space: nowrap;font-size:10px; \"><b>IGST Amount</b></TH>";
        data += "<TH align='center' style=\"white-space: nowrap;font-size:10px;\"><b>Terms</b></TH>";
        data += "<TH align='center' style=\"white-space: nowrap;font-size:10px;\"><b>GSTIN No</b></TH>";
        data += "</TR>";
        var srNo = 0
        for dict in self.arrReport{
            srNo += 1
            
            let invoiceDate = dict.isKeyNull(RES_KEY.Invoice_Date) ? "-":"\(dict[RES_KEY.Invoice_Date]!)"
            let invoiceNo = dict.isKeyNull(RES_KEY.INVOICE_NO) ? "-":"\(dict[RES_KEY.INVOICE_NO]!)"
            let suplrInvoiceNo = dict.isKeyNull(RES_KEY.SUPLR_INV_NO) ? "-":"\(dict[RES_KEY.SUPLR_INV_NO]!)"
            let bookName = dict.isKeyNull(RES_KEY.TRANS_AC_NAME) ? "-":"\(dict[RES_KEY.TRANS_AC_NAME]!)"
            let customerName = dict.isKeyNull(RES_KEY.Party_Name) ? "-":"\(dict[RES_KEY.Party_Name]!)"
            let qty = dict.isKeyNull(RES_KEY.Qty) ? "-":"\(dict[RES_KEY.Qty]!)"
            let terms = dict.isKeyNull(RES_KEY.TERMS) ? "-":"\(dict[RES_KEY.TERMS]!)"
            let gstinNo = dict.isKeyNull(RES_KEY.GSTIN_NO) ? "-":"\(dict[RES_KEY.GSTIN_NO]!)"
            
            let goodsAmount = Double("\(dict[RES_KEY.Amount] ?? "" as AnyObject)") ?? 0.00
            let taxAmount = Double("\(dict[RES_KEY.TAX_AMOUNT] ?? "" as AnyObject)") ?? 0.00
            let additionalAmount = Double("\(dict[RES_KEY.EXP_AMOUNT] ?? "" as AnyObject)") ?? 0.00
            let totalAmount = Double("\(dict[RES_KEY.TRANS_AMOUNT] ?? "" as AnyObject)") ?? 0.00
            let taxableAmount = Double("\(dict[RES_KEY.TAXABLE_AMOUNT] ?? "" as AnyObject)") ?? 0.00
            let cgstAmount = Double("\(dict[RES_KEY.CGST_AMOUNT] ?? "" as AnyObject)") ?? 0.00
            let sgstAmount = Double("\(dict[RES_KEY.SGST_AMOUNT] ?? "" as AnyObject)") ?? 0.00
            let igstAmount = Double("\(dict[RES_KEY.IGST_AMOUNT] ?? "" as AnyObject)") ?? 0.00
            
            data += "<TR>";
            data += "<TD align='center' style =\"white-space: nowrap;font-size:7px;\">\(srNo)</TD>";
            data += "<TD align='center' style =\"white-space: nowrap;font-size:7px;\">\(invoiceDate)</TD>";
            data += "<TD align='center' style =\"word-wrap: break-word;font-size:7px;\">\(invoiceNo)</TD>";
            data += "<TD align='center' style =\"word-wrap: break-word;font-size:7px;\">\(suplrInvoiceNo)</TD>";
            data += "<TD align='center' style =\"word-wrap: break-word;font-size:7px;\">\(bookName)</TD>";
            data += "<TD align='center' style =\"white-space: nowrap;font-size:7px;\">\(customerName)</TD>";
            data += "<TD align='center' style =\"white-space: nowrap;font-size:7px;\">\(qty)</TD>";
            data += "<TD align='center' style =\"word-wrap: break-word;font-size:7px;\">\(goodsAmount)</TD>";
            data += "<TD align='center' style =\"word-wrap: break-word;font-size:7px;\">\(taxAmount)</TD>";
            data += "<TD align='center' style =\"word-wrap: break-word;font-size:7px;\">\(additionalAmount)</TD>";
            data += "<TD align='center' style =\"word-wrap: break-word;font-size:7px;\">\(totalAmount)</TD>";
            data += "<TD align='center' style =\"word-wrap: break-word;font-size:7px;\">\(taxableAmount)</TD>";
            data += "<TD align='center' style =\"word-wrap: break-word;font-size:7px;\">\(cgstAmount)</TD>";
            data += "<TD align='center' style =\"word-wrap: break-word;font-size:7px;\">\(sgstAmount)</TD>";
            data += "<TD align='center' style =\"word-wrap: break-word;font-size:7px;\">\(igstAmount)</TD>";
            data += "<TD align='center' style =\"word-wrap: break-word;font-size:7px;\">\(terms)</TD>";
            data += "<TD align='center' style =\"word-wrap: break-word;font-size:7px;\">\(gstinNo)</TD>";
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
        let filePath = "\(directory)/registerReport.pdf"
        pdfData.write(toFile: filePath, atomically: true)
        let fileUrl = NSURL(fileURLWithPath: filePath)
        let activiyController = UIActivityViewController(activityItems: [fileUrl], applicationActivities: nil)
        Obj_AppDelegate.navigationController.present(activiyController, animated: true) {
            
        }
    }
    
    func getRegisterData(){
        DesignModel.startActivityIndicator()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let fromDate = dateFormatter.date(from: "\(self.fromDate)") ?? Date()
        let toDate = dateFormatter.date(from: "\(self.toDate)") ?? Date()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        self.pageNo += 1
        var proGrpCode = 0
        if let proGrpDict = self.arrSeleType.first{
            proGrpCode = Int("\(proGrpDict[RES_KEY.TYPE_CODE] ?? "" as AnyObject)") ?? 0
        }
        let params = [REQ_KEY.CompCode: "\(userInfo[RES_KEY.CompCode] ?? "" as AnyObject)",
            REQ_KEY.FromDate: dateFormatter.string(from: fromDate),
            REQ_KEY.ToDate: dateFormatter.string(from: toDate),
            REQ_KEY.PartyCode: "",
            REQ_KEY.ProcessCode: "\(proGrpCode == 0 ? "" : "\(proGrpCode)")",
            REQ_KEY.PageNo: "\(self.pageNo)"]
        Obj_OperationApi.callWebService(ApiMethod.GetRegisterReport, method: .post, parameters: params, onCompletion: { (responce) in
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
    
    func updateTotalView(){
        var totalAmt = 0.00
        var totalQty = 0.00
        var totalGoodsAmt = 0.00
        var totalTaxAmt = 0.00
        var totalAddiAmt = 0.00
        var totalTaxableAmt = 0.00
        var totalCGSTAmt = 0.00
        var totalSGSTAmt = 0.00
        for dict in self.arrReport{
            let amount = Double("\(dict[RES_KEY.TRANS_AMOUNT] ?? "" as AnyObject)") ?? 0.0
            totalAmt += amount
            let qty = Double("\(dict[RES_KEY.Qty] ?? "" as AnyObject)") ?? 0.0
            totalQty += qty
            let goodsAmt = Double("\(dict[RES_KEY.Amount] ?? "" as AnyObject)") ?? 0.0
            totalGoodsAmt += goodsAmt
            let taxAmt = Double("\(dict[RES_KEY.TAX_AMOUNT] ?? "" as AnyObject)") ?? 0.0
            totalTaxAmt += taxAmt
            let addiAmt = Double("\(dict[RES_KEY.EXP_AMOUNT] ?? "" as AnyObject)") ?? 0.0
            totalAddiAmt += addiAmt
            let taxableAmt = Double("\(dict[RES_KEY.TAXABLE_AMOUNT] ?? "" as AnyObject)") ?? 0.0
            totalTaxableAmt += taxableAmt
            let cgstAmt = Double("\(dict[RES_KEY.CGST_AMOUNT] ?? "" as AnyObject)") ?? 0.0
            totalCGSTAmt += cgstAmt
            let sgstAmt = Double("\(dict[RES_KEY.SGST_AMOUNT] ?? "" as AnyObject)") ?? 0.0
            totalSGSTAmt += sgstAmt
        }
        self.lblTotalAmount.text = "₹ \(withSeprate(val: totalAmt))"
        self.lblQty.text = "₹ \(withSeprate(val: totalQty))"
        self.lblGoodsAmount.text = "₹ \(withSeprate(val: totalGoodsAmt))"
        self.lblTaxAmount.text = "₹ \(withSeprate(val: totalTaxAmt))"
        self.lblAdditionalAmount.text = "₹ \(withSeprate(val: totalAddiAmt))"
        self.lblTaxableAmount.text = "₹ \(withSeprate(val: totalTaxableAmt))"
        self.lblCGSTAmount.text = "₹ \(withSeprate(val: totalCGSTAmt))"
        self.lblSGSTAmount.text = "₹ \(withSeprate(val: totalSGSTAmt))"
    }
    
    //MARK:- TableView Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrReport.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "RegisterReportCell", for: indexPath) as? RegisterReportCell{
            let dict = self.arrReport[indexPath.row]
            cell.lblSrNo.text = "\(indexPath.row+1)"
            cell.lblInvoiceDate.text = dict.isKeyNull(RES_KEY.Invoice_Date) ? "-":"\(dict[RES_KEY.Invoice_Date]!)"
            cell.lblInvoiceNo.text = dict.isKeyNull(RES_KEY.INVOICE_NO) ? "-":"\(dict[RES_KEY.INVOICE_NO]!)"
            cell.lblSuplrInvoiceNo.text = dict.isKeyNull(RES_KEY.SUPLR_INV_NO) ? "-":"\(dict[RES_KEY.SUPLR_INV_NO]!)"
            cell.lblBookName.text = dict.isKeyNull(RES_KEY.TRANS_AC_NAME) ? "-":"\(dict[RES_KEY.TRANS_AC_NAME]!)"
            cell.lblCustomerName.text = dict.isKeyNull(RES_KEY.Party_Name) ? "-":"\(dict[RES_KEY.Party_Name]!)"
            cell.lblQty.text = dict.isKeyNull(RES_KEY.Qty) ? "-":"\(dict[RES_KEY.Qty]!)"
            cell.lblTerms.text = dict.isKeyNull(RES_KEY.TERMS) ? "-":"\(dict[RES_KEY.TERMS]!)"
            cell.lblGSTINNo.text = dict.isKeyNull(RES_KEY.GSTIN_NO) ? "-":"\(dict[RES_KEY.GSTIN_NO]!)"
            
            let goodsAmount = Double("\(dict[RES_KEY.Amount] ?? "" as AnyObject)") ?? 0.00
            cell.lblGoodsAmount.text = goodsAmount == 0.00 ? "-":withSeprate(val: goodsAmount)
            let taxAmount = Double("\(dict[RES_KEY.TAX_AMOUNT] ?? "" as AnyObject)") ?? 0.00
            cell.lblTaxAmount.text = taxAmount == 0.00 ? "-":withSeprate(val: taxAmount)
            let additionalAmount = Double("\(dict[RES_KEY.EXP_AMOUNT] ?? "" as AnyObject)") ?? 0.00
            cell.lblAdditionalAmount.text = additionalAmount == 0.00 ? "-":withSeprate(val: additionalAmount)
            let totalAmount = Double("\(dict[RES_KEY.TRANS_AMOUNT] ?? "" as AnyObject)") ?? 0.00
            cell.lblTotalAmount.text = totalAmount == 0.00 ? "-":withSeprate(val: totalAmount)
            let taxableAmount = Double("\(dict[RES_KEY.TAXABLE_AMOUNT] ?? "" as AnyObject)") ?? 0.00
            cell.lblTaxableAmount.text = taxableAmount == 0.00 ? "-":withSeprate(val: taxableAmount)
            let cgstAmount = Double("\(dict[RES_KEY.CGST_AMOUNT] ?? "" as AnyObject)") ?? 0.00
            cell.lblCGSTAmount.text = cgstAmount == 0.00 ? "-":withSeprate(val: cgstAmount)
            let sgstAmount = Double("\(dict[RES_KEY.SGST_AMOUNT] ?? "" as AnyObject)") ?? 0.00
            cell.lblSGSTAmount.text = sgstAmount == 0.00 ? "-":withSeprate(val: sgstAmount)
            let igstAmount = Double("\(dict[RES_KEY.IGST_AMOUNT] ?? "" as AnyObject)") ?? 0.00
            cell.lblIGSTAmount.text = igstAmount == 0.00 ? "-":withSeprate(val: igstAmount)
            
            if (indexPath.row == self.arrReport.count-1 && self.arrReport.count < self.totalRecords){
                self.getRegisterData()
            }
            
            return cell
        }
        return RegisterReportCell()
    }

}
