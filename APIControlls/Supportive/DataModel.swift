//
//  DataModel.swift
//  Sparkle
//
//  Created by pcmac on 21/03/18.
//  Copyright © 2018 BrainWaves. All rights reserved.
//

import UIKit

class DataModel: NSObject {
    internal var isNoInternet: Bool = false
    
    class func isDictionaryAndNotNull(data: Any) -> Bool {
        if !(data is NSNull) && data is typeAliasDictionary {
            let dict: typeAliasDictionary = data as! typeAliasDictionary
            if dict.count != 0 {
                return true
            }
        }
        return false
    }
    
    class func removeNullFromDictionary(dictionary: typeAliasDictionary) -> typeAliasDictionary {
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
    
    class func getDeviceName() -> String {
        return UIDevice.current.name
    }
    
    class func getVendorIdentifier() -> String {
        return (UIDevice.current.identifierForVendor?.uuidString)!
    }
    
    class func getAppVersion() -> String {
        return Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    }
    
    class func getDocumentDirectoryPath() -> String {
        var paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        return paths[0]
    }
    
    class func getDataFromDocumentDirectory(fileName: String, folderName: String) -> NSData? {
        let documentsDirectory = self.getDocumentDirectoryPath()
        let fileManager = FileManager.default
        let fileName1: String = "\(documentsDirectory)\(folderName)\(fileName)"
        if fileManager.fileExists(atPath: fileName1) {
            return NSData(contentsOfFile: fileName1)
        }
        return nil
    }
    class func GetFontNames()
    {
        let fontFamilyNames = UIFont.familyNames
        for familyName in fontFamilyNames {
            print("------------------------------")
            print("Font Family Name = [\(familyName)]")
            let names = UIFont.fontNames(forFamilyName: familyName )
            print("Font Names = [\(names)]")
        }
    }
    class func getDocumentDirectoryPath(_ filename: String, folderName: String) -> String {
        let documentsDirectory = self.getDocumentDirectoryPath()
        let dataPath: String = folderName.isEmpty ? documentsDirectory : documentsDirectory + "/" + folderName
        
        if !FileManager.default.fileExists(atPath: dataPath) {
            do {
                try FileManager.default.createDirectory(atPath: dataPath, withIntermediateDirectories: false, attributes: nil)
            } catch { print("Folder creation error : \(error.localizedDescription)") }
        }
        return dataPath + "/"
    }
    
    class func writeDataAtPath(filePath: String, fileData: Data, isOverWriteOld: Bool) -> Bool {
        let fileManager: FileManager = FileManager.default
        
        let writeFile = { () -> Bool in
            do {
                try fileData.write(to: URL.init(fileURLWithPath: filePath), options: .atomic)
                return true
            } catch { print("File write error : \(error.localizedDescription)") }
            return false
        }
        
        if fileManager.fileExists(atPath: filePath) && isOverWriteOld {
            do {
                try fileManager.removeItem(atPath: filePath)
                return writeFile()
            } catch { print("File remove error : \(error.localizedDescription)") }
        }
        else { return writeFile() }
        return false
    }
    
    class func getImageFromBase64(_ encodedString: String) -> UIImage{
        if let decodedData = NSData(base64Encoded: encodedString, options: .ignoreUnknownCharacters) {
            return UIImage(data: decodedData as Data) ?? UIImage()
        }
        return UIImage()
    }

    
//    //MARK: - Reachability
//    //<--
//    func startHost() {
//        stopNotifier()
//        setupReachability(true)
//        startNotifier()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//            self.startHost()
//        }
//    }
//    
//    func setupReachability(_ useClosures: Bool) {
//        self.reachability = Reachability()
//        if useClosures {
//            reachability?.whenReachable = { reachability in
//                self.updateLabelColourWhenReachable(reachability)
//            }
//            reachability?.whenUnreachable = { reachability in
//                self.updateLabelColourWhenNotReachable(reachability)
//            }
//        } else {
//            NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(_:)), name: .reachabilityChanged, object: reachability)
//        }
//    }
//    func startNotifier() { do { try reachability?.startNotifier() } catch { return } }
//    func stopNotifier() {
//        reachability?.stopNotifier()
//        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: nil)
//        reachability = nil
//    }
//    func updateLabelColourWhenReachable(_ reachability: Reachability) {
//        print("\(reachability.description) - \(reachability.connection)")
//        if reachability.connection == .none { } else { }
//        print("\(reachability.connection)")
//    }
//    func updateLabelColourWhenNotReachable(_ reachability: Reachability) {
//        print("\(reachability.description) - \(reachability.connection)")
//        stopNotifier()
//        if isNoInternet {
//            isNoInternet = false
//            JD_Toast.showToast(NSLocalizedString("No Internet Connection...!", comment: ""), toastType: .failure)
//            return
//        }
//    }
//    @objc func reachabilityChanged(_ note: Notification) {
//        let reachability = note.object as! Reachability
//
//        if reachability.connection != .none {
//            updateLabelColourWhenReachable(reachability)
//        } else {
//            updateLabelColourWhenNotReachable(reachability)
//        }
//    }
}
