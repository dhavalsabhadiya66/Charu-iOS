//
//  GetSetModel.swift
//  Sparkle
//
//  Created by pcmac on 21/03/18.
//  Copyright © 2018 BrainWaves. All rights reserved.
//

import UIKit
import CoreLocation



// STATIC KEY
let NS_SERVICE_URL                              = "NS_SERVICE_URL"
let NS_SUB_PRODUCT_DATA                         = "NS_SUB_PRODUCT_DATA"
let NS_UDID                                     = "NS_UDID"
let NS_PASSWORD                                 = "NS_PASSWORD"
let NS_YEAR_CODE                                = "YEAR_CODE"
let NS_USER_INFO                                = "NS_USER_INFO"
let NS_IS_LOGGEDIN                              = "NS_IS_LOGGEDIN"



class GetSetModel: NSObject {
    
    //*************************** STRING ********************************
    class func setUDID(_ udid: String) {
        UserDefaults.standard.setValue(udid, forKey:NS_UDID)
        UserDefaults.standard.synchronize()
    }
    
    class func getUDID() -> String {
        var udid: String = " "
        if UserDefaults.standard.object(forKey: NS_UDID) != nil {
            udid = (UserDefaults.standard.value(forKey: NS_UDID) as! String)
        }
        return udid
    }
    
    class func setPassword(_ udid: String) {
        UserDefaults.standard.setValue(udid, forKey:NS_PASSWORD)
        UserDefaults.standard.synchronize()
    }
    
    class func getPassword() -> String {
        var udid: String = " "
        if UserDefaults.standard.object(forKey: NS_PASSWORD) != nil {
            udid = (UserDefaults.standard.value(forKey: NS_PASSWORD) as! String)
        }
        return udid
    }
    
    
    class func setYearCode(_ code: String) {
        UserDefaults.standard.setValue(code, forKey:NS_YEAR_CODE)
        UserDefaults.standard.synchronize()
    }
    
    class func getYearCode() -> String {
        var yearCode: String = ""
        if UserDefaults.standard.object(forKey: NS_YEAR_CODE) != nil {
            yearCode = (UserDefaults.standard.value(forKey: NS_YEAR_CODE) as! String)
        }
        return yearCode
    }
    
    //*************************** DICTIONARY ********************************
    
    class func setUserInfo(_ Data : typeAliasDictionary){
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: Data)
        UserDefaults.standard.setValue(encodedData, forKey: NS_USER_INFO)
        UserDefaults.standard.synchronize()
    }
    class func getUserInfo() -> typeAliasDictionary{
        var dictUserInfo = typeAliasDictionary()
        if let dictData = UserDefaults.standard.object(forKey: NS_USER_INFO) as? Data {
            dictUserInfo = NSKeyedUnarchiver.unarchiveObject(with: dictData) as?  typeAliasDictionary ?? typeAliasDictionary()
        }
        return dictUserInfo
    }
    
    
    /****************************** BOOL ************************************/
    
    class func setIsLoggedIn(_ registerd: Bool) {
        UserDefaults.standard.setValue(registerd, forKey: NS_IS_LOGGEDIN)
        UserDefaults.standard.synchronize()
    }

    class func getIsLoggedIn() -> Bool{
        var registerd: Bool = false
        if UserDefaults.standard.object(forKey: NS_IS_LOGGEDIN) != nil{
            registerd = (UserDefaults.standard.value(forKey: NS_IS_LOGGEDIN) as! Bool)
        }
        return registerd
    }
    
}
