//
//  APP_MSG.swift
//  Sparkle
//
//  Created by pcmac on 21/03/18.
//  Copyright © 2018 BrainWaves. All rights reserved.
//

import Foundation



//public enum STATUS: String, CaseIterable {
//
//    case NEW                = "NEW"
//    case WAITING            = "WAITING"
//    case IN_PROGRESS        = "IN PROGRESS"
//    case HOLD               = "HOLD"
//    case COMPLETED          = "COMPLETED"
//
//}

//public enum ROLENAME: String{
//    case ADMIN              = "ADMIN"
//    case OPERATOR           = "OPERATOR"
//    case ENGINEER           = "ENGINEER"
//    case CUSTOMER           = "CUSTOMER"
//    case MANAGER            = "MANAGER"
//    case ADMINISTRATOR      = "ADMINISTRATOR"
//}

public enum SELECTION_TYPE: Int {
    case DUMMY
    case SINGLE
    case MULTIPLE
}
public enum SELECTION_ANIMATION: Int {
    case DUMMY
    case CROSS_DISSOLVE
    case RIGHT_TO_LEFT
    case FADE_IN_OUT
    case BOTTOM_TO_TOP
    case BLUR
}

public enum INPUT_TYPE: Int {
    case DUMMY
    case YEAR
    case COMPANY
    case ACCOUNT
    case GROUP
    case MAIN_GROUP
    case PARTY
    case PRODUCT
    case BOOK
    case TYPE
    case CAR
    case BRAND
}

let MSG_TITLE                               = "Charu Industries"
let MSG_ERR_SOMETING_WRONG                  = "Someting goes wrong...!"
let MSG_NO_DATA_AVAILABLE                   = "No Data Available!!!"
let MSG_NO_DATA_FOUND                       = "Sorry, NO Data Found!!"
