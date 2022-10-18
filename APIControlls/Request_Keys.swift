//
//  Request_Keys.swift
//  Sparkle
//
//  Created by pcmac on 21/03/18.
//  Copyright © 2018 BrainWaves. All rights reserved.
//

import Foundation



//SPTypes
let SPTYPE_Insert                       = "I"
let SPTYPE_Update                       = "U"
let SPTYPE_Delete                       = "D"


struct REQ_KEY {
    
    //Company And Year
    static let CompCode                 = "CompCode"
    static let CompGrpCode              = "CompGrpCode"
    static let ShortName                = "ShortName"
    static let Status                   = "Status"
    static let YearCode                 = "YearCode"
    
    //LogIn
    static let UserName                 = "UserName"
    static let Password                 = "Password"
    static let UDID                     = "UDID"
    static let DeviceType               = "DeviceType"
    
    //ACCOUNT LIST
    static let AccountCode              = "AccountCode"
    static let AccountName              = "AccountName"
    
    //LEDGER REPORT
    static let FromDate                 = "FromDate"
    static let ToDate                   = "ToDate"
    static let BasicCode                = "BasicCode"
    static let GroupCode                = "GroupCode"
    static let GroupDetCode             = "GroupDetCode"
    static let AcCode                   = "AcCode"
    static let Currency                 = "Currency"
    
    //STOCK REPORT
    static let Date                     = "Date"
    static let PageNo                   = "PageNo"
    static let MainGrpName              = "MainGrpName"
    static let ProductCode              = "ProductCode"
    static let CarMakeName              = "CarMakeName"
    static let CarBrandName             = "CarBrandName"
    static let CarYearName              = "CarYearName"
    
    //SALSE REPORT
    static let ProdCode                 = "ProdCode"
    static let PartyCode                = "PartyCode"
    static let ProdGrpCode              = "ProdGrpCode"
    
    //Target
    static let EmpCode                  = "EmpCode"
    
    //Register
    static let Register_Type            = "Type"
    static let ProcessCode              = "ProcessCode"
    
}
