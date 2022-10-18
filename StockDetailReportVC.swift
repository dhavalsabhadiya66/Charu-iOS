//
//  StockDetailReportVC.swift
//  Charu Industries
//
//  Created by iMac on 10/12/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

class StockReportCell: UITableViewCell {
  
    @IBOutlet weak var lblSrNO: UILabel!
    @IBOutlet weak var lblSKU: UILabel!
    @IBOutlet weak var lblMainGroup: UILabel!
    @IBOutlet weak var lblSubGroup: UILabel!
    @IBOutlet weak var lblCarMake: UILabel!
    @IBOutlet weak var lblCarModel: UILabel!
    @IBOutlet weak var lblYear: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblStock: UILabel!
    @IBOutlet weak var lblPurchase: UILabel!
    @IBOutlet weak var lblSPrice: UILabel!
    @IBOutlet weak var lblDPrice: UILabel!
    @IBOutlet weak var lblCPrice: UILabel!
    @IBOutlet weak var lblIncShip: UILabel!
    @IBOutlet weak var lblMRP: UILabel!
    @IBOutlet weak var lblWebProduct: UILabel!
    @IBOutlet weak var lblBrand: UILabel!
    @IBOutlet weak var lblMaterial: UILabel!
    @IBOutlet weak var lblColor: UILabel!
    @IBOutlet weak var lblPackDet: UILabel!
    @IBOutlet weak var lblWarranty: UILabel!
    @IBOutlet weak var lblWeight: UILabel!
    @IBOutlet weak var lblWidth: UILabel!
    @IBOutlet weak var lblLength: UILabel!
    @IBOutlet weak var lblHeight: UILabel!
    @IBOutlet weak var btnImage: UIButton!
    @IBOutlet weak var ivImage: UIImageView!
    
}

class StockDetailReportVC: UIViewController, UITableViewDataSource, UITableViewDelegate, AppNavigationControllerDelegate {
    
    @IBOutlet weak var tableReport: UITableView!
    @IBOutlet weak var heightTableView: NSLayoutConstraint!
    @IBOutlet weak var viewReportBG: UIView!
    
    let dateFormatter = DateFormatter()
    var arrReport = [typeAliasDictionary]()
    var arrMainGroupName = [typeAliasDictionary]()
    var arrSeleMainGroupName = [typeAliasDictionary]()
    var arrProductGroup = [typeAliasDictionary]()
    var arrSeleProductGroup = [typeAliasDictionary]()
    var arrProductName = [typeAliasDictionary]()
    var arrSeleProductName = [typeAliasDictionary]()
    var arrCarMake = [typeAliasDictionary]()
    var arrSeleCarMake = [typeAliasDictionary]()
    var arrCarBrand = [typeAliasDictionary]()
    var arrSeleCarBrand = [typeAliasDictionary]()
    var arrCarYear = [typeAliasDictionary]()
    var arrSeleCarYear = [typeAliasDictionary]()
    var pageNo = 0
    var totalRecords = 0
    var toDate = ""

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUpNavigationBar()
        if self.arrReport.count > 0{
            self.viewReportBG.isHidden = false
        }else {
            self.viewReportBG.isHidden = true
            self.pageNo = 0
        }
        getReportData()
        
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.heightTableView.constant = self.viewReportBG.frame.height-43
    }
    
    //MARK:- NAVIGATION METHODS
    func setUpNavigationBar(){
        Obj_AppDelegate.navigationController.setCustomTitle("Stock Report")
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
        data += "<TR><td align='center' colspan=\"15\"><b>Stock Report</b></td>";
        data += "</TR>";
        data += "<TR bgcolor=\"#E4DDC2\">";
        data += "<TH align='center' style=\"white-space: nowrap;font-size:8px;\"><b>Sr.No</b></TH>";
        data += "<TH align='center' style=\"white-space: nowrap;font-size:8px;\"><b>SKU</b></TH>";
        data += "<TH align='center' style=\"white-space: nowrap;font-size:8px;\"><b>Main Group</b></TH>";
        data += "<TH align='center' style=\"white-space: nowrap;font-size:8px;\"><b>Sub Group</b></TH>";
        data += "<TH align='center' style=\"white-space: nowrap;font-size:8px;\"><b>Car Make</b></TH>";
        data += "<TH align='center' style=\"white-space: nowrap;font-size:8px; \"><b>Car Model</b></TH>";
        data += "<TH align='center' style=\"white-space: nowrap;font-size:8px; \"><b>Year/Narration</b></TH>";
        data += "<TH align='center' style=\"white-space: nowrap;font-size:8px; \"><b>Item Name</b></TH>";
        data += "<TH align='center' style=\"white-space: nowrap;font-size:8px; \"><b>Stock</b></TH>";
        data += "<TH align='center' style=\"white-space: nowrap;font-size:8px; \"><b>Purchase</b></TH>";
        data += "<TH align='center' style=\"white-space: nowrap;font-size:8px; \"><b>Special Price</b></TH>";
        data += "<TH align='center' style=\"white-space: nowrap;font-size:8px;\"><b>Dealer Price</b></TH>";
        data += "<TH align='center' style=\"white-space: nowrap;font-size:8px;\"><b>Customer Price</b></TH>";
        data += "<TH align='center' style=\"white-space: nowrap;font-size:8px;\"><b>Included Ship</b></TH>";
        data += "<TH align='center' style=\"white-space: nowrap;font-size:8px;\"><b>MRP</b></TH>";
        data += "<TH align='center' style=\"white-space: nowrap;font-size:8px;\"><b>Web ProdName</b></TH>";
        data += "<TH align='center' style=\"white-space: nowrap;font-size:8px; \"><b>Brand</b></TH>";
        data += "<TH align='center' style=\"white-space: nowrap;font-size:8px; \"><b>Material/Narration</b></TH>";
        data += "<TH align='center' style=\"white-space: nowrap;font-size:8px; \"><b>Color</b></TH>";
        data += "<TH align='center' style=\"white-space: nowrap;font-size:8px; \"><b>Pack Detail</b></TH>";
        data += "<TH align='center' style=\"white-space: nowrap;font-size:8px; \"><b>Warranty</b></TH>";
        data += "<TH align='center' style=\"white-space: nowrap;font-size:8px; \"><b>Weight</b></TH>";
        data += "<TH align='center' style=\"white-space: nowrap;font-size:8px; \"><b>Width</b></TH>";
        data += "<TH align='center' style=\"white-space: nowrap;font-size:8px; \"><b>Length</b></TH>";
        data += "<TH align='center' style=\"white-space: nowrap;font-size:8px; \"><b>Height</b></TH>";
        data += "</TR>";
        for dict in self.arrReport{
            let stockInt = Int("\(dict[RES_KEY.Stock] ?? "" as AnyObject)") ?? 0
            let purchaseDouble = Double("\(dict[RES_KEY.Purchase] ?? "" as AnyObject)") ?? 0.00
            let sPrice = Double("\(dict[RES_KEY.Spe_Price] ?? "" as AnyObject)") ?? 0.00
            let dPrice = Double("\(dict[RES_KEY.Del_Price] ?? "" as AnyObject)") ?? 0.00
            let cPrice = Double("\(dict[RES_KEY.Cus_Price] ?? "" as AnyObject)") ?? 0.00
            let inShip = Double("\(dict[RES_KEY.Inc_Rate] ?? "" as AnyObject)") ?? 0.00
            let mrpDou = Double("\(dict[RES_KEY.MRP] ?? "" as AnyObject)") ?? 0.00
            let srNo = dict.isKeyNull(RES_KEY.SrNo) ? "-":"\(dict[RES_KEY.SrNo]!)"
            let sku = dict.isKeyNull(RES_KEY.Short_Code) ? "-":"\(dict[RES_KEY.Short_Code]!)"
            let mainGrp = dict.isKeyNull(RES_KEY.Main_Group_Name) ? "-":"\(dict[RES_KEY.Main_Group_Name]!)"
            let subGrp = dict.isKeyNull(RES_KEY.Sub_Group_Name) ? "-":"\(dict[RES_KEY.Sub_Group_Name]!)"
            let carMake = dict.isKeyNull(RES_KEY.Car_Make) ? "-":"\(dict[RES_KEY.Car_Make]!)"
            let carModel = dict.isKeyNull(RES_KEY.Car_Model) ? "-":"\(dict[RES_KEY.Car_Model]!)"
            let carYear = dict.isKeyNull(RES_KEY.Car_Year) ? "-":"\(dict[RES_KEY.Car_Year]!)"
            let itemName = dict.isKeyNull(RES_KEY.Cate_Name) ? "-":"\(dict[RES_KEY.Cate_Name]!)"
            let stock = stockInt == 0 ? "-":"\(stockInt)"
            let purchase = purchaseDouble == 0.00 ? "-":String(round((purchaseDouble*100)/100))
            let spePrice = sPrice == 0.00 ? "-":String(round((sPrice*100)/100))
            let delPrice = dPrice == 0.00 ? "-":String(round((dPrice*100)/100))
            let cusPrice = cPrice == 0.00 ? "-":String(round((cPrice*100)/100))
            let incRate = inShip == 0.00 ? "-":String(round((inShip*100)/100))
            let mrp = mrpDou == 0.00 ? "-":String(round((mrpDou*100)/100))
            let webProName = dict.isKeyNull(RES_KEY.Web_Prod_Name) ? "-":"\(dict[RES_KEY.Web_Prod_Name]!)"
            let brand = dict.isKeyNull(RES_KEY.Brand_Name) ? "-":"\(dict[RES_KEY.Brand_Name]!)"
            let material = dict.isKeyNull(RES_KEY.Material) ? "-":"\(dict[RES_KEY.Material]!)"
            let color = dict.isKeyNull(RES_KEY.Color) ? "-":"\(dict[RES_KEY.Color]!)"
            let pacDet = dict.isKeyNull(RES_KEY.Pack_Det) ? "-":"\(dict[RES_KEY.Pack_Det]!)"
            let warranty = dict.isKeyNull(RES_KEY.Warranty) ? "-":"\(dict[RES_KEY.Warranty]!)"
            let weight = dict.isKeyNull(RES_KEY.Weight) ? "-":"\(dict[RES_KEY.Weight]!)"
            let width = dict.isKeyNull(RES_KEY.Width) ? "-":"\(dict[RES_KEY.Width]!)"
            let length = dict.isKeyNull(RES_KEY.Length) ? "-":"\(dict[RES_KEY.Length]!)"
            let height = dict.isKeyNull(RES_KEY.Height) ? "-":"\(dict[RES_KEY.Height]!)"
            data += "<TR>";
            data += "<TD align='center' style =\"white-space: nowrap;font-size:5px;\">\(srNo)</TD>";
            data += "<TD align='center' style =\"white-space: nowrap;font-size:5px;\">\(sku)</TD>";
            data += "<TD align='center' style =\"white-space: nowrap;font-size:5px;\">\(mainGrp)</TD>";
            data += "<TD align='center' style =\"white-space: nowrap;font-size:5px;\">\(subGrp)</TD>";
            data += "<TD align='center' style =\"white-space: nowrap;font-size:5px;\">\(carMake)</TD>";
            data += "<TD align='center' style =\"word-wrap: break-word;font-size:5px;\">\(carModel)</TD>";
            data += "<TD align='center' style =\"word-wrap: break-word;font-size:5px;\">\(carYear)</TD>";
            data += "<TD align='center' style =\"word-wrap: break-word;font-size:5px;\">\(itemName)</TD>";
            data += "<TD align='center' style =\"word-wrap: break-word;font-size:5px;\">\(stock)</TD>";
            data += "<TD align='center' style =\"word-wrap: break-word;font-size:5px;\">\(purchase)</TD>";
            data += "<TD align='right' style =\"white-space: nowrap;font-size:5px;\">\(spePrice)</TD>";
            data += "<TD align='right' style =\"white-space: nowrap;font-size:5px;\">\(delPrice)</TD>";
            data += "<TD align='right' style =\"white-space: nowrap;font-size:5px;\">\(cusPrice)</TD>";
            data += "<TD align='right' style =\"white-space: nowrap;font-size:5px;\">\(incRate)</TD>";
            data += "<TD align='right' style =\"white-space: nowrap;font-size:5px;\">\(mrp)</TD>";
            data += "<TD align='center' style =\"word-wrap: break-word;font-size:5px;\">\(webProName)</TD>";
            data += "<TD align='center' style =\"word-wrap: break-word;font-size:5px;\">\(brand)</TD>";
            data += "<TD align='center' style =\"word-wrap: break-word;font-size:5px;\">\(material)</TD>";
            data += "<TD align='center' style =\"word-wrap: break-word;font-size:5px;\">\(color)</TD>";
            data += "<TD align='center' style =\"word-wrap: break-word;font-size:5px;\">\(pacDet)</TD>";
            data += "<TD align='center' style =\"word-wrap: break-word;font-size:5px;\">\(warranty)</TD>";
            data += "<TD align='center' style =\"word-wrap: break-word;font-size:5px;\">\(weight)</TD>";
            data += "<TD align='center' style =\"word-wrap: break-word;font-size:5px;\">\(width)</TD>";
            data += "<TD align='center' style =\"word-wrap: break-word;font-size:5px;\">\(length)</TD>";
            data += "<TD align='center' style =\"word-wrap: break-word;font-size:5px;\">\(height)</TD>";
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
        let filePath = "\(directory)/stockReport.pdf"
        pdfData.write(toFile: filePath, atomically: true)
        let fileUrl = NSURL(fileURLWithPath: filePath)
        let activiyController = UIActivityViewController(activityItems: [fileUrl], applicationActivities: nil)
        Obj_AppDelegate.navigationController.present(activiyController, animated: true) {
            
        }
    }
    
    func getReportData(){
        let userInfo = GetSetModel.getUserInfo()
        DesignModel.startActivityIndicator()
        dateFormatter.dateFormat = "dd-MM-yyyy"
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
        self.pageNo += 1
        let param = [REQ_KEY.ProdGrpCode: "\(prodGroupCode == 0 ? "" : "\(prodGroupCode)")",
                     REQ_KEY.MainGrpName: "",
                     REQ_KEY.ProdCode: "\(prodCode == 0 ? "" : "\(prodCode)")",
                     REQ_KEY.CompCode: "\(userInfo[RES_KEY.CompCode] ?? "" as AnyObject)",
                     REQ_KEY.Date: dateFormatter.string(from: toDate),
                     REQ_KEY.CarMakeName: "\(carMakeDict[RES_KEY.CAR_MAKE] ?? "" as AnyObject)",
                     REQ_KEY.CarBrandName: "\(carBrandDict[RES_KEY.BRAND_NAME] ?? "" as AnyObject)",
                     REQ_KEY.CarYearName: "\(carYearDict[RES_KEY.CAR_YEAR] ?? "" as AnyObject)",
                     REQ_KEY.PageNo: "\(self.pageNo)"]
        print(param)
        Obj_OperationApi.callWebService(ApiMethod.GetStockReport, method: .post, parameters: param, onCompletion: { (responce) in
            print(responce)
            if self.pageNo == 1 {
                self.totalRecords = Int("\(responce[RES_KEY.Total_Record] ?? "" as AnyObject)") ?? 0
                if let arrData = responce[RES_KEY.Data] as? [typeAliasDictionary]{
                    self.arrReport = arrData
                    self.tableReport.reloadData()
                    if self.arrReport.count>0{
                        self.tableReport.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
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
            }else {
                if let arrData = responce[RES_KEY.Data] as? [typeAliasDictionary]{
                    self.arrReport.append(contentsOf: arrData)
                    self.tableReport.reloadData()
                }else {
                    DesignModel.showMessage("No other record found!!", for: self)
                }
            }
            self.heightTableView.constant = self.viewReportBG.frame.height-43
        }) { (errStr) in
            if self.pageNo == 1{
                self.arrReport = [typeAliasDictionary]()
                self.viewReportBG.isHidden = true
            }
            self.pageNo -= 1
            DesignModel.showMessage(errStr, for: self)
        }
    }
    @objc func showImage(_ sender: UIButton){
        let dict = self.arrReport[sender.tag]
        let imageUrl = URL(string: getJSON(strURL: "\(dict[RES_KEY.Image_Link]!)"))
        let viewImageBG = UIView(frame: UIScreen.main.bounds)
        viewImageBG.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        let imageView = UIImageView(frame: self.view.frame)
        imageView.contentMode = .scaleAspectFit
        if(imageUrl != nil){
            imageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "img_no_image"))
        }else{
            imageView.image = UIImage(named: "img_no_image")
        }
//        imageView.sd_setImage(with: imageUrl) { (image, error, catchType, url) in
//            if error != nil || image == nil{
//                imageView.image = UIImage(named: "img_no_image")
//                DesignModel.showMessage("No image found!!", for: self)
//            }
//        }
        let cancelBtn = UIButton()
        if #available(iOS 11.0, *) {
            cancelBtn.frame = CGRect(x: 20, y: 40, width: 42, height: 42)
        } else {
            cancelBtn.frame = CGRect(x: 20, y: 20, width: 42, height: 42)
        }
        cancelBtn.imageView?.contentMode = .scaleAspectFit
        cancelBtn.setImage(UIImage(named: "ic_cancel")!.tinted(with: .white), for: .normal)
        cancelBtn.addTarget(self, action: #selector(cancelImageAction(_:)), for: .touchUpInside)
        viewImageBG.addSubview(imageView)
        viewImageBG.addSubview(cancelBtn)
        viewImageBG.transform = CGAffineTransform.identity.scaledBy(x: 0.01, y: 0.01)
        Obj_AppDelegate.navigationController.view.addSubview(viewImageBG)
        UIView.animate(withDuration: 0.4) {
            viewImageBG.transform = CGAffineTransform.identity
        }
    }
    @objc func cancelImageAction(_ sender: UIButton){
        Obj_AppDelegate.navigationController.view.subviews.last?.removeFromSuperview()
    }
    
    //MARK:- TABLEVIEW METHODS
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrReport.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "StockReportCell", for: indexPath) as? StockReportCell{
            let dict = self.arrReport[indexPath.row]
            let stock = Int("\(dict[RES_KEY.Stock] ?? "" as AnyObject)") ?? 0
            let purchase = Int("\(dict[RES_KEY.Purchase] ?? "" as AnyObject)") ?? 0
            let sPrice = Int("\(dict[RES_KEY.Spe_Price] ?? "" as AnyObject)") ?? 0
            let dPrice = Int("\(dict[RES_KEY.Del_Price] ?? "" as AnyObject)") ?? 0
            let cPrice = Int("\(dict[RES_KEY.Cus_Price] ?? "" as AnyObject)") ?? 0
            let inShip = Int("\(dict[RES_KEY.Inc_Ship_Value] ?? "" as AnyObject)") ?? 0
            let mrp = Int("\(dict[RES_KEY.MRP] ?? "" as AnyObject)") ?? 0
            cell.lblSrNO.text = dict.isKeyNull(RES_KEY.SrNo) ? "-":"\(dict[RES_KEY.SrNo]!)"
            cell.lblSKU.text = dict.isKeyNull(RES_KEY.Short_Code) ? "-":"\(dict[RES_KEY.Short_Code]!)"
            cell.lblMainGroup.text = dict.isKeyNull(RES_KEY.Main_Group_Name) ? "-":"\(dict[RES_KEY.Main_Group_Name]!)"
            cell.lblSubGroup.text = dict.isKeyNull(RES_KEY.Sub_Group_Name) ? "-":"\(dict[RES_KEY.Sub_Group_Name]!)"
            cell.lblCarMake.text = dict.isKeyNull(RES_KEY.Car_Make) ? "-":"\(dict[RES_KEY.Car_Make]!)"
            cell.lblCarModel.text = dict.isKeyNull(RES_KEY.Car_Model) ? "-":"\(dict[RES_KEY.Car_Model]!)"
            cell.lblYear.text = dict.isKeyNull(RES_KEY.Car_Year) ? "-":"\(dict[RES_KEY.Car_Year]!)"
            cell.lblName.text = dict.isKeyNull(RES_KEY.Cate_Name) ? "-":"\(dict[RES_KEY.Cate_Name]!)"
            cell.lblStock.text = stock == 0 ? "-":"\(stock)"
            cell.lblPurchase.text = purchase == 0 ? "-":String(purchase)
            cell.lblSPrice.text = sPrice == 0 ? "-":String(sPrice)
            cell.lblDPrice.text = dPrice == 0 ? "-":String(dPrice)
            cell.lblCPrice.text = cPrice == 0 ? "-":String(cPrice)
            cell.lblIncShip.text = inShip == 0 ? "-":String(inShip)
            cell.lblMRP.text = mrp == 0 ? "-":String(mrp)
            cell.lblWebProduct.text = dict.isKeyNull(RES_KEY.Web_Prod_Name) ? "-":"\(dict[RES_KEY.Web_Prod_Name]!)"
            cell.lblBrand.text = dict.isKeyNull(RES_KEY.Brand_Name) ? "-":"\(dict[RES_KEY.Brand_Name]!)"
            cell.lblMaterial.text = dict.isKeyNull(RES_KEY.Material) ? "-":"\(dict[RES_KEY.Material]!)"
            cell.lblColor.text = dict.isKeyNull(RES_KEY.Color) ? "-":"\(dict[RES_KEY.Color]!)"
            cell.lblPackDet.text = dict.isKeyNull(RES_KEY.Pack_Det) ? "-":"\(dict[RES_KEY.Pack_Det]!)"
            cell.lblWarranty.text = dict.isKeyNull(RES_KEY.Warranty) ? "-":"\(dict[RES_KEY.Warranty]!)"
            cell.lblWeight.text = dict.isKeyNull(RES_KEY.Weight) ? "-":"\(dict[RES_KEY.Weight]!)"
            cell.lblWidth.text = dict.isKeyNull(RES_KEY.Width) ? "-":"\(dict[RES_KEY.Width]!)"
            cell.lblLength.text = dict.isKeyNull(RES_KEY.Length) ? "-":"\(dict[RES_KEY.Length]!)"
            cell.lblHeight.text = dict.isKeyNull(RES_KEY.Height) ? "-":"\(dict[RES_KEY.Height]!)"
            
            let urlStr = "\(dict[RES_KEY.Image_Link] ?? "" as AnyObject)"
            cell.btnImage.tag = indexPath.row
            if URL(string: getJSON(strURL: urlStr)) != nil{
                cell.btnImage.isEnabled = true
                //                cell.btnImage.setImage(UIImage(named: "ic_image")!.tinted(with: COLOR_PRIME_BLUE), for: .normal)
                cell.btnImage.addTarget(self, action: #selector(showImage(_:)), for: .touchUpInside)
            }else {
                cell.btnImage.isEnabled = false
                //                cell.btnImage.setImage(UIImage(named: "ic_image")!.tinted(with: .lightGray), for: .normal)
                cell.btnImage.removeTarget(self, action: #selector(showImage(_:)), for: .touchUpInside)
            }
            
            let url = URL(string: getJSON(strURL: urlStr))
            if(url != nil){
                cell.ivImage.sd_setImage(with: url, placeholderImage: UIImage(named: "img_no_image"))
            }else{
                cell.ivImage.image = UIImage(named: "img_no_image")
            }
            
            
            if (indexPath.row == self.arrReport.count-1 && self.arrReport.count < self.totalRecords){
                self.getReportData()
            }
            
            return cell
        }
        return StockReportCell()
    }
    
    // When url space available then use to function
    func getJSON(strURL: String) -> String{
        if let encoded = strURL.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
            let myURL = URL(string: encoded) {
            print(myURL)
            return encoded
        }
        return strURL
    }

}
