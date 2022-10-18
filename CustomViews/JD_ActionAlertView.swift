//
//  JD_ActionAlertView.swift
//  Sparkle
//
//  Created by pcmac on 21/03/18.
//  Copyright © 2018 BrainWaves. All rights reserved.
//

import UIKit

//public enum ALERT_TYPE: Int {
//    case DUMMY
//    case ADD_CARD
//    case EDIT_CARD
//    case DELETE_CARD
//}

public enum ACTION_SHEET_TYPE :Int {
    case ACTION_SHEET_DUMMY
    case ACTION_SHEET_MORE
}


//protocol JDActionAlertViewDelegate {
//    func jdAlertViewAction(_ alertType: ALERT_TYPE, buttonIndex: Int, buttonTitle: String, object: String)
//    func jdActionSheetAction(_ actionSheetType: ACTION_SHEET_TYPE, buttonIndex: Int, buttonTitle: String, object: String)
//}

class JD_ActionAlertView: NSObject {
    
    //MARK: PROPERTIES
//    var delegate: JDActionAlertViewDelegate! = nil
    
    
    //MARK: VARIABLES
    let obj_AppDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate var _string: String = ""
    fileprivate var _ACTION_SHEET_TYPE: ACTION_SHEET_TYPE!
    
    internal func showYesNoAlertView(_ message: String, for view: UIViewController, isYesDestructive: Bool, YesAction: (()->())? = nil, NoAction: (()->())? = nil) {
        let alertController = UIAlertController.init(title: MSG_TITLE, message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction.init(title: "No", style: UIAlertAction.Style.cancel) { (action) in
            NoAction?()
        })
        alertController.addAction(UIAlertAction.init(title: "Yes", style: isYesDestructive ? .destructive: .default) { (action) in
            YesAction?()
        })
        view.present(alertController, animated: true, completion: nil)
    }
    
    internal func showOkAlertView(_ message: String, for view: UIViewController,_ action:(()->())? = nil) {
        let alertController = UIAlertController.init(title: MSG_TITLE, message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction.init(title: "OK", style: UIAlertAction.Style.default) { (_) in
            action?()
        })
        view.present(alertController, animated: true, completion: nil)
    }
    
//    internal func showAlertView(_ arrTitle: [String], message: String, isIncludeCancelButton : Bool, alertType: ALERT_TYPE, object: String)
//    {
//        var arrTitle = arrTitle
//        _ALERT_TYPE = alertType
//        _string = object
//
//        let alertController = UIAlertController.init(title: MSG_TITLE, message: message, preferredStyle: UIAlertController.Style.alert)
//
//        for i in 0..<arrTitle.count {
//            alertController.addAction(UIAlertAction.init(title: arrTitle[i], style: UIAlertAction.Style.default) { (action) in
//                self.delegate.jdAlertViewAction(self._ALERT_TYPE, buttonIndex: i, buttonTitle: arrTitle[i], object: self._string)
//            })
//        }
//
//        if isIncludeCancelButton {
//            alertController.addAction(UIAlertAction.init(title: "Cancel", style: UIAlertAction.Style.destructive) { (action) in
//                self.delegate.jdAlertViewAction(self._ALERT_TYPE, buttonIndex: arrTitle.count, buttonTitle: "Cancel", object: self._string)
//            })
//        }
//        obj_AppDelegate.navigationController.present(alertController, animated: true, completion: nil)
//    }
//
//    internal func showActionSheet(_ arrTitle: [String], message: String, isIncludeCancelButton : Bool, actionSheetType: ACTION_SHEET_TYPE, object: String) {
//        var arrTitle = arrTitle
//        _ACTION_SHEET_TYPE = actionSheetType
//        _string = object
//
//        let alertController = UIAlertController.init(title: MSG_TITLE, message: message, preferredStyle: UIAlertController.Style.actionSheet)
//        for i in 0..<arrTitle.count {
//            alertController.addAction(UIAlertAction(title: arrTitle[i], style: .default, handler: {(_ action: UIAlertAction) -> Void in
//                self.delegate.jdActionSheetAction(self._ACTION_SHEET_TYPE, buttonIndex: i, buttonTitle: arrTitle[i], object: self._string)
//            }))
//        }
//        if isIncludeCancelButton {
//            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_ action: UIAlertAction) -> Void in
//                self.delegate.jdActionSheetAction(self._ACTION_SHEET_TYPE, buttonIndex: arrTitle.count, buttonTitle: "Cancel", object: self._string)
//            }))
//        }
//        obj_AppDelegate.navigationController.present(alertController, animated: true, completion: nil)
//    }
}
