    //
//  OperationApi.swift
//  Sparkle
//
//  Created by pcmac on 21/03/18.
//  Copyright © 2018 BrainWaves. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
    

class OperationApi: NSObject,XMLParserDelegate {
    
    //MARK: VARIABLES
//    let Obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
//    internal var obj_DataModel = DataModel()
    internal var resultURL: URL!
    internal var _methodName: String!
//    fileprivate var xmlParser = XMLParser()
//    fileprivate var webData:Data = Data()
    fileprivate var nodeContent: String = ""
//    fileprivate var responseTag: String = ""
//    fileprivate var isInTag : Bool = true
    
    fileprivate var dictResponse = typeAliasDictionary()
    //internal var webData:Data!
    internal var theRequest: URLRequest!
    internal var theSession = URLSession()
    internal var isSoapRequest: Bool = false
    fileprivate var jsonResponse: String = ""
    
    
    //MARK: CUSTOME METHOD
    func callWebService(_ methodName: String, method: HTTPMethod, parameters: typeAliasStringDictionary, onCompletion: @escaping (_ responce: typeAliasDictionary) -> Void, onFailure: @escaping (_ errMsg: String) -> Void) {
        self.isSoapRequest = false
        var httpBody = ""
        for (pKey, pValue) in parameters {
            httpBody += "\(pKey)=\(pValue)&"
        }
        let length = "\(httpBody.count)"
        var theRequest = URLRequest(url: URL(string: "\(JWebService)/\(methodName)")!)
        theRequest.httpMethod = "POST"
        theRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        theRequest.addValue(length, forHTTPHeaderField: "Content-Length")
        theRequest.httpBody = httpBody.data(using: String.Encoding.utf8)
        Alamofire.request(theRequest).response { (responce) in
            if responce.data != nil{
                let parser = XMLParser(data: responce.data!)
                parser.delegate = self
                parser.parse()
                DispatchQueue.main.async {
                    DesignModel.stopActivityIndicator()
                    let resSurviceDict = self.jsonResponse.convertToDictionary2()
                    if !resSurviceDict.isEmpty {
                        if "\(resSurviceDict[RES_KEY.STATUS] ?? "" as AnyObject)" == KEY_STATUS_SUCCESS || "\(resSurviceDict["status"] ?? "" as AnyObject)" == "success"{
                            let resDict = self.removeNullFromDictionary(dictionary: resSurviceDict)
                            onCompletion(resDict)
                        }else {
                            onFailure(resSurviceDict[RES_KEY.Message] as? String ?? MSG_ERR_SOMETING_WRONG)
                        }
                    }else{
                        onFailure(MSG_ERR_SOMETING_WRONG)
                    }
                }
            }else if responce.error != nil{
                DispatchQueue.main.async {
                    DesignModel.stopActivityIndicator()
                    onFailure(responce.error!.localizedDescription)
                }
            }
        }
    }
 
    
    func callSoapWebService(_ methodName: String, parameters: typeAliasStringDictionary, onCompletion: @escaping (_ responce: typeAliasDictionary) -> Void, onFailure: @escaping (_ errMsg: String) -> Void) {
        self.isSoapRequest = true
        let soapAction: String = "\(JSOAPWebsiteUrl)/\(methodName)"
        var soapMessage: String = "<?xml version=\"1.0\" encoding=\"utf-8\"?> \n<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"> \n"
        soapMessage += "<soap:Body> \n"
        soapMessage += "<\(methodName) xmlns=\"\(JSOAPWebsiteUrl)/\"> \n"
        for (pKey, pvalue) in parameters {
            soapMessage += "<\(pKey)>\(self.getcodeforkeys(pvalue))</\(pKey)> \n" }
        soapMessage += "</\(methodName)> \n"
        soapMessage += "</soap:Body> \n"
        soapMessage += "</soap:Envelope>";
        
        let msgLength: String = "\(soapMessage.count)";
        var theRequest: URLRequest = URLRequest(url: URL(string: JWebService)!)
//        theRequest.addValue("ASP.NET_SessionId=\(tokenNo);Path=/;HttpOnly", forHTTPHeaderField: "cookie")
        theRequest.addValue(soapAction, forHTTPHeaderField: "SOAPAction")
        theRequest.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        theRequest.addValue(msgLength, forHTTPHeaderField: "Content-Length")
        theRequest.httpMethod = "POST"
        theRequest.httpBody = soapMessage.data(using: String.Encoding.utf8)
        theRequest.timeoutInterval = 99
        Alamofire.request(theRequest).response { (responce) in
            if responce.data != nil{
                let parser = XMLParser(data: responce.data!)
                parser.delegate = self
                parser.parse()
                DispatchQueue.main.async {
                    DesignModel.stopActivityIndicator()
                    let resSurviceDict = self.jsonResponse.convertToDictionary2()
                    if !resSurviceDict.isEmpty {
                        if "\(resSurviceDict[RES_KEY.STATUS] ?? "" as AnyObject)" == KEY_STATUS_SUCCESS || "\(resSurviceDict["status"] ?? "" as AnyObject)" == "success"{
                            let resDict = DataModel.removeNullFromDictionary(dictionary: resSurviceDict)
                            onCompletion(resDict)
                        }else {
                            if "\(resSurviceDict[RES_KEY.Message]!)" == "Unauthorised"{
//                                self.obj_AppDelegate.showLoginVC()
                                DesignModel.showMessage("\(resSurviceDict[RES_KEY.Message]!)", for: Obj_AppDelegate.navigationController)
                            }else{
                                onFailure(resSurviceDict[RES_KEY.Message] as! String)
                            }
                        }
                    }else{
                        onFailure(MSG_ERR_SOMETING_WRONG)
                    }
                }
            }else if responce.error != nil{
                DispatchQueue.main.async {
                    DesignModel.stopActivityIndicator()
                    onFailure(responce.error!.localizedDescription)
                }
            }
        }
    }

    
    
    //MARK:- SUPPORT METHODS
    func removeNullFromDictionary(dictionary: typeAliasDictionary) -> typeAliasDictionary {
        var dictionaryNew: typeAliasDictionary = dictionary
        for pKey in dictionaryNew.keys {
            if dictionaryNew[pKey] is [typeAliasDictionary] {
                var array: [typeAliasDictionary] = dictionaryNew[pKey] as! [typeAliasDictionary]
                for i in 0..<array.count {
                    let dictArray: typeAliasDictionary = array[i]
                    var dict: typeAliasDictionary = dictArray
                    dict = self.removeNullFromDictionary(dictionary: dict)
                    array[i] = dict
                }
                dictionaryNew[pKey] = array as AnyObject?
            }
            if dictionaryNew[pKey] is typeAliasDictionary {
                var dict: typeAliasDictionary = dictionaryNew[pKey] as! typeAliasDictionary
                dict = self.removeNullFromDictionary(dictionary: dict)
                dictionaryNew[pKey] = dict as AnyObject?
            }
            if dictionaryNew[pKey] is NSNull {
                dictionaryNew[pKey] = "" as AnyObject?
            }
        }
        return dictionaryNew
    }
    
    
    //MARK: SOAP WCF METHOD
    func getcodeforkeys(_ stCode: String) -> String {
        var st_CodeNew: String = stCode
        st_CodeNew = st_CodeNew.replace("&", withString: "&amp;")
        st_CodeNew = st_CodeNew.replace("<", withString: "&lt;")
        st_CodeNew = st_CodeNew.replace(">", withString: "&gt;")
        st_CodeNew = st_CodeNew.replace("'", withString: "&apos;")
        st_CodeNew = st_CodeNew.replace("\"", withString: "&quot;")
        return st_CodeNew
    }
    
    //MARK: XMLPARSER DELEGATE
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        nodeContent = nodeContent + string;
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if isSoapRequest{
            jsonResponse = ""
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if !self.isSoapRequest{
            jsonResponse = nodeContent
        }else if self.isSoapRequest && (elementName == ""){
            jsonResponse = nodeContent
        }
        nodeContent = ""
    }
}
