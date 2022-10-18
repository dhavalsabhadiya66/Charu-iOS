//
//  Api_Constant.swift
//  Sparkle
//
//  Created by pcmac on 21/03/18.
//  Copyright © 2018 BrainWaves. All rights reserved.
//

import Foundation


let JSOAPWebsiteUrl                             = "http://tempuri.org"

//LIVE
//let JWebService                                 = "http://103.218.110.11:1522/webservice.asmx"
let JWebService                                 = "http://43.240.9.153:1522/webservice.asmx"


struct ApiMethod {
    
    static let CheckLogin               = "CheckLogin"
    static let CompanyList              = "CompanyList"
    static let YearList                 = "YearList"
    static let AccountList              = "AccountList"
    static let GetLedgetReport          = "GetLedgerReport"
    static let AccountGrpList           = "AccountGrpList"
    static let AccountGrpDetList        = "AccountGrpDetList"
    static let GetStockReport           = "GetStockReport"
    static let GetStockHistoryReport    = "GetStockHistoryReport"
    static let GetPartyList             = "PartyMasList"
    static let GetProdGrpList           = "ProductGrpList"
    static let GetProductList           = "ProductList"
    static let SalesReport              = "GetSalesReport"
    static let PurchaseReport           = "GetPurchaseReport"
    static let MainGrpList              = "MainGrpList"
    static let EmpMasList               = "EmpMasList"
    static let PartyMasList             = "PartyMasList"
    static let GetTargetReport          = "GetTargetReport"
    static let RegisterTypeList         = "RegisterTypeList"
    static let GetRegisterReport        = "GetRegisterReport"
    static let TrialGroupList           = "TrialGroupList"
    static let GetTransClosingTrialReport           = "GetTransClosingTrialReport"
    
    static let GetCarMakeList           = "CarMakeList"
    static let GetCarBrandList          = "CarBrandList"
    static let GetCarYearList           = "CarYearList"
    
}

