//
//  Response_Keys.swift
//  Sparkle
//
//  Created by pcmac on 21/03/18.
//  Copyright © 2018 BrainWaves. All rights reserved.
//

import Foundation

typealias typeAliasDictionary               = [String: AnyObject]
typealias typeAliasStringDictionary         = [String: String]

//MARK:- STATIC KEYS

let KEY_STATUS_FAIL                         = "0"
let KEY_STATUS_SUCCESS                      = "1"
let KEY_DeviceType                          = "IPHONE"
let KEY_ADMIN_CODE                          = "1"



struct RES_KEY {
    
    
    //MARK:- GENERAL
    static let Data                         = "Data"
    static let Message                      = "Message"
    static let STATUS                       = "STATUS"
    static let INDEX                        = "INDEX"
    static let p_return_id                  = "p_return_id"
    static let p_message                    = "p_message"
    static let p_get_id                     = "p_get_id"
    
    //Company and Year List
    static let Comp_Code                    = "COMP_CODE"
    static let Comp_Name                    = "COMP_NAME"
    static let Year_Code                    = "YEAR_CODE"
    static let Year_Name                    = "YEAR_NAME"
    static let From_Date                    = "FROM_DATE"
    static let To_Date                      = "TO_DATE"
    
    //LOGIN
    static let UserID                       = "USERID"
    static let UserName                     = "USERNAME"
    static let EmpCode                      = "EMPCODE"
    static let Emp_Code                     = "EMP_CODE"
    static let RoleCode                     = "ROLE_CODE"
    static let RoleName                     = "ROLE_NAME"
    static let CompCode                     = "COMPCODE"
    static let UDID                         = "UDID"
    static let Email                        = "Email"
    static let Mobile                       = "MOBILE"
    static let Address                      = "ADDRESS"
    static let EmpName                      = "EMP_NAME"
    static let TokenNo                      = "TOKENNO"
    
    
    //Account List
    static let Ac_Code                      = "AC_CODE"
    static let Ac_Name                      = "AC_NAME"
    
    //LedgerReport
    static let Trans_Date                   = "TRANS_DATE"
    static let Trans_Type                   = "TRANS_TYPE"
    static let Cheque_No                    = "CHEQUE_NO"
    static let Trans_Mode                   = "TRANS_MODE"
    static let Voucher_No                   = "VOUCHER_NO"
    static let Debit_Amt                    = "REC_AMT"
    static let Credit_Amt                   = "PAY_AMT"
    static let Balance_Amt                  = "BAL_AMT"
    static let TYPE                         = "TYPE"
    
    //GroupDetList
    static let Group_Det_Code               = "GROUP_DET_CODE"
    static let Group_Det_Name               = "GROUP_DET_NAME"
    
    
    //Stock Report
    static let Total_Record                 = "TOT_RECORD"
    static let SrNo                         = "SRNO"
    static let Short_Code                   = "SHORT_CODE"
    static let Image_Link                   = "IMAGE_LINK"
    static let Main_Group_Name              = "MAIN_GROUP_NAME"
    static let Main_Group                   = "MAIN_GROUP"
    static let Sub_Group_Name               = "STONE_TYPE_NAME"
    static let Car_Make                     = "CAR_MAKE"
    static let Car_Model                    = "MODEL_NO"
    static let Car_Year                     = "CAR_YEAR"
    static let Cate_Name                    = "CATE_NAME"
    static let Stock                        = "QTY"
    static let Purchase                     = "PUR_VALUE"
    static let Spe_Price                    = "SPACIAL_VALUE"
    static let Del_Price                    = "DEALER_RATE"
    static let Cus_Price                    = "CUSTOMER_VALUE"
    static let Inc_Rate                     = "INCLUDED_VALUE"
    static let Inc_Ship_Value               = "INCLUDED_SHIP_VALUE"
    static let MRP                          = "MRP"
    static let Web_Prod_Name                = "WEB_PROD_NAME"
    static let Brand_Name                   = "BRAND_NAME"
    static let Material                     = "MATERIAL"
    static let Color                        = "COLOR"
    static let Pack_Det                     = "PACK_DET"
    static let Warranty                     = "WARRANTY"
    static let Weight                       = "WEIGHT"
    static let Width                        = "WIDTH"
    static let Length                       = "LENGTH"
    static let Height                       = "HEIGHT"
    static let CAR_MAKE                     = "CAR_MAKE"
    static let BRAND_NAME                   = "BRAND_NAME"
    static let CAR_YEAR                     = "CAR_YEAR"
    
    //Stock History Report
    static let Proc_Name                    = "PROC_NAME"
    static let Ac_Desc                      = "AC_DESCRIPTION"
    static let Stone_Type_Name              = "STONE_TYPE_NAME"
    static let Cat_Name                     = "CATE_NAME"
    static let R_Bal_Qty                    = "R_BAL_QTY"
    static let R_Bal_Rate                   = "R_BAL_RATE"
    static let Less_Qty                     = "LESS_QTY"
    static let Less_Rate                    = "LESS_RATE"
    static let Plus_Qty                     = "PLUS_QTY"
    static let Plus_Rate                    = "PLUS_RATE"
    
    //PARTY LIST
    static let Party_Code                   = "PARTY_CODE"
    static let Party_Name                   = "PARTY_NAME"
    
    //PRODUCT GROUP
    static let P_Grp_Code                   = "P_GRP_CODE"
    static let P_Grp_Name                   = "PGRPNAME"
    static let P_Grp_C_Name                 = "PGRPCNAME"
    
    //Prodcut Name
    static let Product_Code                 = "PRODUCT_CODE"
    static let Procuct_Name                 = "PRODUCT_NAME"
    
    
    //SALSE REPORT
    static let Invoice_Date                 = "INVOICE_DATE"
    static let Invoice_No                   = "Invoice_No"
    static let Book_Name                    = "TRANS_AC_NAME"
    static let Group_Name                   = "STONE_TYPE"
    static let Product_Name                 = "STONE_CATEGORY"
    static let Pcs                          = "PCS"
    static let Qty                          = "QTY"
    static let Unit                         = "UNIT"
    static let Rate                         = "RATE"
    static let Amount                       = "AMOUNT"
    
    //Prodcut Name
    static let Target_Val                 = "TARGET_VAL"
    static let Achieve_Val                = "INV_VALUE"
    
    //Register
    static let INVOICE_NO                   = "INVOICE_NO"
    static let SUPLR_INV_NO                 = "SUPLR_INV_NO"
    static let TRANS_AC_NAME                = "TRANS_AC_NAME"
    static let TAX_AMOUNT                   = "TAX_AMOUNT"
    static let TAXABLE_AMOUNT               = "TAXABLE_AMOUNT"
    static let TRANS_AMOUNT                 = "TRANS_AMOUNT"
    static let EXP_AMOUNT                   = "EXP_AMOUNT"
    static let CGST_AMOUNT                  = "CGST_AMOUNT"
    static let SGST_AMOUNT                  = "SGST_AMOUNT"
    static let IGST_AMOUNT                  = "IGST_AMOUNT"
    static let GSTIN_NO                     = "GSTIN_NO"
    static let TERMS                        = "TERMS"
    static let TYPE_CODE                    = "TYPE_CODE"
    static let TYPE_NAME                    = "TYPE_NAME"
    static let TYPE_CAP                     = "TYPE_CAP"
    
    //Transaction
    static let GROUP_DET_NAME               = "GROUP_DET_NAME"
    static let GROUP_DET_CODE               = "GROUP_DET_CODE"
    static let SRNO                         = "SRNO"
    static let SHORT_NAME                   = "SHORT_NAME"
    static let MOBILE_NO                    = "MOBILE_NO"
    static let AC_NAME                      = "AC_NAME"
    static let CLS_CR_AMT                   = "CLS_CR_AMT"
    static let CLS_CR_DOM_AMT               = "CLS_CR_DOM_AMT"
    static let CLS_CR_TRANS_AMT             = "CLS_CR_TRANS_AMT"
    static let CLS_DR_AMT                   = "CLS_DR_AMT"
    static let CLS_DR_DOM_AMT               = "CLS_DR_DOM_AMT"
    static let CLS_DR_TRANS_AMT             = "CLS_DR_TRANS_AMT"
    static let DR_AMT                       = "DR_AMT"
    static let DR_TRANS_AMT                 = "DR_TRANS_AMT"
    static let CR_AMT                       = "CR_AMT"
    static let CR_TRANS_AMT                 = "CR_TRANS_AMT"
    static let CR_DOM_AMT                   = "CR_DOM_AMT"
    static let DR_DOM_AMT                   = "DR_DOM_AMT"
    
}
