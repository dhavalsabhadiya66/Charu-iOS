
//
//  JD_Selection.swift
//  Sparkle
//
//  Created by pcmac on 21/03/18.
//  Copyright © 2018 BrainWaves. All rights reserved.
//

let JD_UNIQUE_KEY                       = "JD_Unique_Key"
let JD_VALUE_KEY                        = "JD_Value_Key"

let SELECTION_SUPER_VIEW_TAG            = 10001
let SELECTION_SUB_VIEW_TAG              = 110001

let JD_SELECTION_ROW_HEIGHT: CGFloat         = 40
let JD_SELECTION_PADDING: CGFloat            = 10

let JD_SELECTION_HEADER_HEIGHT: CGFloat      = JD_SELECTION_ROW_HEIGHT
let JD_SELECTION_FOOTER_HEIGHT: CGFloat      = JD_SELECTION_ROW_HEIGHT + JD_SELECTION_PADDING

let CELL_BG_COLOR                       = UIColor.white
let COLOUR_BLACK_TRANSPARENT                = RGBCOLOR(0, g: 0, b: 0, alpha: 0.4)

import UIKit

protocol JDSelectionDelegate {
    func selectedOption(arrSelected:[typeAliasDictionary] , inputType:INPUT_TYPE)
}

class JDSelection: UIView , UITableViewDelegate , UITableViewDataSource, UIGestureRecognizerDelegate,UITextFieldDelegate{
    
    
    //MARK:- PROPERTIES
    @IBOutlet var tableViewList: UITableView!
    @IBOutlet var viewFooter: UIView!
    @IBOutlet var btnSelectAll: UIButton?
    @IBOutlet var viewBG: UIView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var txtSearch: UITextField!
    @IBOutlet var btnDone: UIButton!
    @IBOutlet var btnClear: UIButton!

    @IBOutlet var constraintHeighttxtSearch: NSLayoutConstraint!
    @IBOutlet var constraintBottomlblTitleWithtxtSearch: NSLayoutConstraint!
    @IBOutlet var constraintBottomlblTitleWithtableViewList: NSLayoutConstraint!
    internal var delegate: JDSelectionDelegate! = nil

    //MARK:- VARIABLES
    static let sharedInstance = JDSelection()
    
    fileprivate var _title: String = ""
    fileprivate var _listArray = [typeAliasDictionary]()
    fileprivate var _selectedArray = [typeAliasDictionary]()
    fileprivate var _mainListArray = [typeAliasDictionary]()
    fileprivate var _keyDictionary = typeAliasDictionary()
    fileprivate var _isHideOnSelection: Bool = false
    fileprivate var _selectionType = SELECTION_TYPE.DUMMY
    fileprivate var _inputType = INPUT_TYPE.DUMMY
    fileprivate var _SELECTION_ANIMATION = SELECTION_ANIMATION.DUMMY
    fileprivate var _animateWithDuration: Float = 0
    fileprivate var heightAlertMessage: Float = 0
    fileprivate var _isSelectionCompulsory: Bool = false
    fileprivate var _isPaginationExist: Bool = false
    fileprivate var _isAlertStyle: Bool = false
    fileprivate var _isRemoveOnDoneClick: Bool = false
    fileprivate var _message: String = ""
    
    
    //MARK:- METHODS
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame : frame)
    }
    
    init(title: String, selectionType: SELECTION_TYPE, listArray: [typeAliasDictionary], selectedArray: [typeAliasDictionary], keyDictionary: typeAliasDictionary, inputType: INPUT_TYPE, isSelectionCompulsory: Bool, contentFrame: CGRect, isPaginationExist: Bool, isRemoveOnDoneClick: Bool) {
        super.init(frame: CGRect.zero)
        self.customJDSelectionWithView(title: title, selectionType: selectionType, message: "SPARKLE", listArray: listArray, selectedArray: selectedArray, keyDictionary: keyDictionary, inputType: inputType, isSelectionCompulsory: isSelectionCompulsory, animation: SELECTION_ANIMATION.BOTTOM_TO_TOP, animationDuration: Float(JD_POPOVER_DURATION), isBGTransparent: JD_POPOVER_BG_TRANSPARENT, borderColor: JD_POPOVER_BORDER_COLOR, borderWidth: JD_POPOVER_BORDER_WIDTH, cornerRadius: JD_POPOVER_CORNER_RADIUS, contentFrame: contentFrame, isOutSideClickedHidden: JD_POPOVER_OUT_SIDE_CLICK_HIDDEN, isPaginationExist: isPaginationExist, isRemoveOnDoneClick: isRemoveOnDoneClick)
    }
    
    func customJDSelectionWithView(title: String, selectionType: SELECTION_TYPE, message: String, listArray: [typeAliasDictionary], selectedArray: [typeAliasDictionary], keyDictionary: typeAliasDictionary, inputType: INPUT_TYPE, isSelectionCompulsory: Bool, animation: SELECTION_ANIMATION, animationDuration: Float, isBGTransparent: Bool, borderColor: UIColor, borderWidth: CGFloat, cornerRadius: CGFloat, contentFrame: CGRect, isOutSideClickedHidden: Bool, isPaginationExist: Bool, isRemoveOnDoneClick: Bool) {
        
        self.initSelectionPopoverWithView(title: title, selectionType: selectionType , message: message , listArray: listArray , selectedArray: selectedArray , keyDictionary: keyDictionary , inputType: inputType , isSelectionCompulsory: isSelectionCompulsory, animation: animation , animationDuration: Float(animationDuration), isBGTransparent: isBGTransparent, borderColor: borderColor, borderWidth: borderWidth, cornerRadius: cornerRadius, contentFrame: contentFrame , isOutSideClickedHidden: isOutSideClickedHidden, isPaginationExist: isPaginationExist, isRemoveOnDoneClick: isRemoveOnDoneClick)
    }
    
    fileprivate func initSelectionPopoverWithView(title: String, selectionType: SELECTION_TYPE, message: String, listArray: [typeAliasDictionary], selectedArray: [typeAliasDictionary], keyDictionary: typeAliasDictionary, inputType: INPUT_TYPE, isSelectionCompulsory: Bool, animation: SELECTION_ANIMATION, animationDuration: Float, isBGTransparent: Bool, borderColor: UIColor, borderWidth: CGFloat, cornerRadius: CGFloat, contentFrame: CGRect, isOutSideClickedHidden: Bool, isPaginationExist: Bool, isRemoveOnDoneClick: Bool) {
        
        var frame: CGRect = UIScreen.main.bounds
        if UIApplication.shared.statusBarOrientation == .portrait {
            frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(frame.size.width), height: CGFloat(frame.size.height))
        }
        
        loadXIB()
        self.frame = frame
        
        _title = title;
        _isSelectionCompulsory = isSelectionCompulsory
        _listArray = listArray
        _mainListArray = listArray
        _selectedArray = selectedArray
        _keyDictionary = keyDictionary
        _selectionType = selectionType
        _inputType = inputType
        _animateWithDuration = animationDuration
        _message = message
        _SELECTION_ANIMATION = animation
        _isPaginationExist = isPaginationExist
        _isRemoveOnDoneClick = isRemoveOnDoneClick
        lblTitle.text = _title
        
        viewBG.backgroundColor = COLOUR_BLACK_TRANSPARENT
        viewBG.layer.borderWidth = borderWidth
        viewBG.layer.borderColor = borderColor.cgColor
        viewBG.layer.cornerRadius = cornerRadius
        viewBG.clipsToBounds = true

        
        //--> Set Frame
        if isPaginationExist{
            constraintHeighttxtSearch.constant = 25
            constraintBottomlblTitleWithtxtSearch.isActive = true
            constraintBottomlblTitleWithtableViewList.isActive = false
            txtSearch.placeholder = "Enter \(_title)"
            txtSearch.isHidden = false
        }
        else{
            constraintHeighttxtSearch.constant = 0
            constraintBottomlblTitleWithtxtSearch.isActive = false
            constraintBottomlblTitleWithtableViewList.isActive = true
            txtSearch.isHidden = true

        }
//        let viewHeight = contentFrame.height
        let viewHeight = _listArray.count > 6 ? ((JD_SELECTION_ROW_HEIGHT * 6) + 85) : ((JD_SELECTION_ROW_HEIGHT * CGFloat(_listArray.count)) + CGFloat(_listArray.count - 1) + 80)

        let width = contentFrame.width
        let _ : typeAliasDictionary! = DesignModel.setConstraint_ConWidth_ConHeight_Horizontal_Vertical(viewBG, superView: self, width: width, height: viewHeight)

        tableViewList.rowHeight = JD_SELECTION_ROW_HEIGHT
        tableViewList.tableFooterView = UIView.init(frame: CGRect.zero)
        //-->
        
        if _message.count != 0 {
            _isAlertStyle = true
            //heightAlertMessage = [DesignModel getTextHeight:_message textWidth:(CGRectGetWidth(contentFrame) - (MESSAGE_PADDING * 2)) textFont:FONT_MESSAGE];
            //heightAlertMessage = heightAlertMessage > MESSAGE_MAX_HEIGHT ? heightAlertMessage + 10 : MESSAGE_MAX_HEIGHT;
        }
        else {
            _isAlertStyle = false
            heightAlertMessage = 0
        }
        
        if isOutSideClickedHidden && _isRemoveOnDoneClick {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.closeJDSelectionAction))
            tapGesture.delegate = self
            self.tag = SELECTION_SUPER_VIEW_TAG
            self.addGestureRecognizer(tapGesture)
            self.isMultipleTouchEnabled = true
            self.isUserInteractionEnabled = true
        }

//        if _SELECTION_ANIMATION != .BLUR && !isBGTransparent {
            self.backgroundColor = COLOUR_BLACK_TRANSPARENT
//        }
        
        //Set Frame
        var tableHeight: CGFloat = 100
        if _selectionType == .MULTIPLE {
            tableHeight = (CGFloat(_listArray.count) * JD_SELECTION_ROW_HEIGHT)
        }
        else {
            tableHeight = (CGFloat(_listArray.count) * JD_SELECTION_ROW_HEIGHT)
        }


        if _selectionType == .MULTIPLE {
            btnSelectAll = DesignModel.createImageButton(CGRect.init(x: tableViewList.frame.width - 40, y: 0, width: 40, height: tableHeight), unSelectedImage: #imageLiteral(resourceName: "icon_radiobtn_off"), selectedImage: #imageLiteral(resourceName: "icon_radiobtn_on"), tag: 0)
            btnSelectAll?.addTarget(self, action: #selector(btnSelectAllAction), for: .touchUpInside)
            
            if !_listArray.isEmpty && _listArray.count == _selectedArray.count{
                btnSelectAll?.isSelected = true
            }
            else { btnSelectAll?.isSelected = false }
        }
        
        //CROSS ANIMATION
        self.alpha = 0
        UIView.animate(withDuration: 0.3, delay: 0.0, options:UIView.AnimationOptions.beginFromCurrentState, animations: {
            self.alpha = 1
            self.tableViewList.reloadData()
            }, completion: nil)

        //Set Animation
        if _SELECTION_ANIMATION == .CROSS_DISSOLVE {
        }
        
        if self._selectionType == .SINGLE {
            self.btnDone.isHidden = true
        }else if self._selectionType == .MULTIPLE {
            self.btnDone.isHidden = false
        }
    }
    
    private func loadXIB() {
        let view = Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?[0] as! UIView
        view.translatesAutoresizingMaskIntoConstraints = false;
        view.layer.cornerRadius = 5
        self.addSubview(view)
        view.layoutIfNeeded()
    }
    
    @objc func closeJDSelectionAction() {
        self.btnCloseAction()
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let view: UIView? = touch.view
        let viewTag = Int(view!.tag)
        if viewTag != SELECTION_SUPER_VIEW_TAG {
            return false
        }
        return true
    }
    
    @IBAction func btnDoneAction() {
        self.alpha = 1
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIView.AnimationOptions.beginFromCurrentState, animations: {
            self.alpha = 0
            self.removeFromSuperview()
            }, completion:{ (finished) in
                self.layer.removeAllAnimations()
                self.delegate.selectedOption(arrSelected: self._selectedArray, inputType: self._inputType)
                self.btnCloseAction()
        })
        for UIView in self.subviews {
            UIView.removeFromSuperview()
        }
    }
    
    @IBAction func btnClearAction() {
        btnSelectAll?.isSelected = false
        _selectedArray = [typeAliasDictionary]()
        if _isPaginationExist {
            _listArray = _mainListArray
            tableViewList.reloadData()
        }
        else {
            tableViewList.reloadRows(at: tableViewList.indexPathsForVisibleRows!, with: .none)
        }
        if self._selectionType == .SINGLE {
            self.alpha = 1
            UIView.animate(withDuration: 0.3, delay: 0.0, options: UIView.AnimationOptions.beginFromCurrentState, animations: {
                self.alpha = 0
                self.removeFromSuperview()
            }, completion:{ (finished) in
                self.layer.removeAllAnimations()
                self.delegate.selectedOption(arrSelected: self._selectedArray, inputType: self._inputType)
                self.btnCloseAction()
            })
            for UIView in self.subviews { UIView.removeFromSuperview() }
        }
    }
    
    @IBAction func btnCloseAction() {
        self.alpha = 1
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIView.AnimationOptions.beginFromCurrentState, animations: {
            self.alpha = 0
            }, completion:{ (finished) in
                self.removeFromSuperview()
                self.layer.removeAllAnimations()
        })
    }
    
    @objc fileprivate func btnSelectAllAction(button:UIButton) {
        if _listArray.count == 0 {
            return
        }
        
        if (btnSelectAll?.isSelected)! {
            if _isPaginationExist {
                if _keyDictionary.count != 0 {
                    let keyName: String = _keyDictionary[JD_UNIQUE_KEY] as! String
                    for dict in _listArray {
                        let predicate = NSPredicate(format: "SELF.%@ MATCHES %@", keyName, dict[keyName] as! NSPredicate)
                        let filteredArr: [typeAliasDictionary] = _selectedArray.filter { predicate.evaluate(with: $0) }
                        if filteredArr.count != 0 {
                            //_selectedArray.removeObjects(in: filteredArr)
                        }
                    }
                }
                else {
                    for st in _listArray {
                        let predicate = NSPredicate(format: "SELF MATCHES %@", st)
                        let filteredArr: [typeAliasDictionary] = _selectedArray.filter { predicate.evaluate(with: $0) }
                        if filteredArr.count != 0 {
//                            _selectedArray.removeObjects(in: filteredArr)
                        }
                    }
                }
            }
            else { _selectedArray = [typeAliasDictionary]() }
        }
        else {
            if _isPaginationExist {
                if _keyDictionary.count != 0 {
                    let keyName: String = _keyDictionary[JD_UNIQUE_KEY] as! String
                    for dict1 in _listArray {
                        let dict: typeAliasDictionary = dict1
                        let predicate = NSPredicate(format: "SELF.%@ MATCHES %@", keyName, dict[keyName] as! NSPredicate)
                        let filteredArr: [typeAliasDictionary] = _selectedArray.filter { predicate.evaluate(with: $0) }
                        if filteredArr.count != 0 {
                            _selectedArray.append(dict)
                        }
                    }
                }
                else {
                    for st in _listArray {
                        let predicate = NSPredicate(format: "SELF MATCHES %@", st)
                        let filteredArr: [typeAliasDictionary] = _selectedArray.filter { predicate.evaluate(with: $0) }
                        if filteredArr.count != 0 {
                            //_selectedArray.append(str)
                        }
                    }
                }
            }
            else { _selectedArray = [typeAliasDictionary]() }
        }
        btnSelectAll?.isSelected = !(btnSelectAll?.isSelected)!
        tableViewList.reloadData()
    }
    
    //MARK:- TEXTFIELD DELEGATE
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        let text: String = textField.text!
        let resultingString: String = text.replacingCharacters(in: range.toRange(string: text), with: string)
//        if resultingString.characters.count == 0{
//            _listArray = _mainListArray
//            btnOtherCity.isHidden = true
//            lblNotFound.isHidden = true
//            tableViewList.reloadData()
//            btnSelectAll?.isSelected = false
//            return true
//        }
        if _keyDictionary.count != 0{
            let stValue = _keyDictionary[JD_VALUE_KEY]!
            print(stValue)

            let predicate = NSPredicate(format: "SELF.%@ BEGINSWITH[cd] %@", stValue as! CVarArg, resultingString)
            _listArray = _mainListArray.filter { predicate.evaluate(with: $0) }
            tableViewList.reloadData()
        }else{
            let predicate = NSPredicate(format: "SELF BEGINSWITH[cd] %@", resultingString)
            _listArray = _mainListArray.filter { predicate.evaluate(with: $0)}
            tableViewList.reloadData()
        }
        if resultingString.count == 0{
            _listArray = _mainListArray
            tableViewList.reloadData()
            btnSelectAll?.isSelected = false
            return true
        }
        btnSelectAll?.isSelected = false
        return true
    }
    
    //MARK:- TABLEVIEW DATASOURCE
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return _listArray.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "cell"
        let cell:UITableViewCell = UITableViewCell.init(style: .default, reuseIdentifier: identifier)
        
        cell.selectionStyle = .none
//        cell.accessoryType = .none
     //   cell.accessoryView = UIView(frame: CGRect.zero)
        
         if _keyDictionary.count != 0 {
            let dictInfo: typeAliasDictionary = _listArray[indexPath.row]

            let keyName: String = _keyDictionary[JD_UNIQUE_KEY] as! String
            let valueName: String = _keyDictionary[JD_VALUE_KEY] as! String
            
            let listID: Any = dictInfo[keyName]!
            for i in 0..<_selectedArray.count {
                let dict: typeAliasDictionary = _selectedArray[i]
                let selectedID: Any = dict[keyName]!
                if String(describing: selectedID) == String(describing: listID) {
                    cell.backgroundColor = COLOR_PRIME_BLUE
                    break
                }
            }
            cell.textLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
            cell.textLabel?.text = dictInfo[valueName] as? String
        }
         else {
            let listID: Any = _listArray[indexPath.row]
            
            for i in 0..<_selectedArray.count {
                let selectedID: Any = _selectedArray[i]
                if String(describing: selectedID) == String(describing: listID) {
                    cell.backgroundColor = COLOR_PRIME_BLUE
                    
                }
            }
            cell.textLabel?.font = UIFont.systemFont(ofSize: 12.0)
            cell.textLabel?.text = String(describing: _listArray[indexPath.row])
        }

        return cell
    }

    func dictionary(dict: typeAliasDictionary, containsValue value : String) -> Bool {
        let contains = dict.contains { (_,v) -> Bool in
            return v as! String == value
        }
        return contains
    }
    
    //MARK: TABLEVIEW DELEGATE
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dict: typeAliasDictionary = _listArray[indexPath.row]
        if _selectionType == .MULTIPLE {
            
            //Check if selected dict is exist in selectedArray or not
            var isExists: Bool = false
            var index: Int = -1
            if _keyDictionary.count != 0 {
                for dictStored in _selectedArray {
                    let key: String = _keyDictionary[JD_UNIQUE_KEY] as! String
                    let dictStoreValue: Any = dictStored[key]!
                    let dictValue: Any = dict[key]!
                    if String(describing: dictStoreValue) == String(describing: dictValue) {
                        isExists = true
                        //index = _selectedArray.index{ $0[dictStoreValue] == value }
                        index = Int(_selectedArray._bridgeToObjectiveC().index(of: dictStored))
                        break
                    }
                }
                if isExists {
                    _selectedArray.remove(at: index)
                }
                else {
                    _selectedArray.append(dict)
                }
            }
            else {
                let a = dictionary(dict: dict, containsValue: "PARAMETER_KEY")
                if !a {
                    //_selectedArray.remove(at: _selectedArray.index(of: dict)!)
                    print("this value already exists");
                }
                else {
                    _selectedArray.append(dict)
                }
            }
        }
        
        else if _selectionType == .SINGLE {
            _selectedArray = [typeAliasDictionary]()
            _selectedArray.append(dict)
            self.alpha = 1
            UIView.animate(withDuration: 0.3, delay: 0.0, options: UIView.AnimationOptions.beginFromCurrentState, animations: {
                self.alpha = 0
                self.removeFromSuperview()
            }, completion:{ (finished) in
                self.layer.removeAllAnimations()
                self.delegate.selectedOption(arrSelected: self._selectedArray, inputType: self._inputType)
                self.btnCloseAction()
            })
            for UIView in self.subviews { UIView.removeFromSuperview() }
        }
        
        if _selectedArray.count == _listArray.count {
            btnSelectAll?.isSelected = true
        }
        else {
            btnSelectAll?.isSelected = false
        }
        
//        if _selectionType == .SINGLE {
//            self.btnDoneAction()
//        }
        
        print("Selection open..1!1!111")

        tableViewList.reloadRows(at: tableViewList.indexPathsForVisibleRows!, with: .none)
        tableViewList.reloadData()
    }
    
   /* func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if _selectionType == .MULTIPLE{
            
            let view: UIView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableViewList.frame.width, height: 40))
            view.backgroundColor = .white
            let label: UILabel = DesignModel.createLabel(CGRect.init(x: 5, y: 0, width: view.frame.width - 50, height: view.frame.height), text: "Select All", textColor: .black, textAlignment: .left, textFont: UIFont.init(name: FONT_AVENIRLTSTD_MEDIUM, size: 13.0)!, backColor: .clear, tag: 0)
            view.addSubview(label)
            
            btnSelectAll = DesignModel.createImageButton(CGRect.init(x: label.frame.maxX + 15, y: 7, width: 25, height: 25), unSelectedImage:#imageLiteral(resourceName: "icon_uncheckbox_selectAll") , selectedImage: #imageLiteral(resourceName: "icon_checkbox_selectAll"), tag: 0)
            
            btnSelectAll?.addTarget(self, action: #selector(btnSelectAllAction), for: .touchUpInside)

            if !_listArray.isEmpty && _listArray.count == _selectedArray.count{
                btnSelectAll?.isSelected = true
            }
            else{ btnSelectAll?.isSelected = false}
            
            view.addSubview(btnSelectAll!)
            DesignModel.setBottomBorderView(view, borderColor: .gray, borderWidth: 1)
            return view
        }
        else{ return UIView.init(frame: CGRect.zero)}
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if _selectionType == .MULTIPLE { return 40 }
        else { return 0 }
    }*/
}
