//
//  JD_Extention.swift
//  Sparkle
//
//  Created by pcmac on 21/03/18.
//  Copyright © 2018 BrainWaves. All rights reserved.
//

import Foundation

import UIKit

extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}

extension String {
    
    func validateMobileNo() -> Bool {
        do {
            
            let pattern: String = "^[789]\\d{9}$"
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let nsString = self as NSString
            let results = regex.matches(in: self, options: [], range: NSMakeRange(0, nsString.length))
            return results.count > 0 ? true : false
            
        } catch let error as NSError {
            print("Invalid regex: \(error.localizedDescription)")
            return false
        }
    }
    
    func validateEmail() -> Bool {
        do {
            let pattern: String = "[A-Za-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[A-Za-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?\\.)+[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?"
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let nsString = self as NSString
            let results = regex.matches(in: self, options: [], range: NSMakeRange(0, nsString.length))
            return results.count > 0 ? true : false
            
        } catch let error as NSError {
            print("Invalid regex: \(error.localizedDescription)")
            return false
        }
    }
    
    func validatePassword() -> Bool {
        return self.count >= 6 && self.count <= 32 ? true : false
    }
    
    func removeThousandSeperator()->String{
        let decimal = self.components(separatedBy: ".")
        let intString = decimal[0].components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
        let Price = intString + "." + decimal[1]
        return Price
    }
    
    func isContainString(subString: String) -> Bool {
        return (self as NSString).range(of: subString).location != NSNotFound ? true : false
    }
    
    func setThousandSeperator()->String { return  self.setThousandSeperator(self, decimal: 2) }
    
    func setThousandSeperator(_ string:String , decimal:Int)->String {
        let numberFormatter = NumberFormatter.init()
        numberFormatter.groupingSeparator = ","
        numberFormatter.groupingSize = 3
        numberFormatter.decimalSeparator = "."
        numberFormatter.maximumFractionDigits = decimal
        numberFormatter.numberStyle = NumberFormatter.Style.currency
        numberFormatter.currencySymbol = ""
        numberFormatter.usesGroupingSeparator = true
        return numberFormatter.string(from: NSNumber.init(value: Double(string)! as Double))!
    }
    
    func setDecimalPoint()->String {
        let numberFormatter:NumberFormatter = NumberFormatter.init()
        numberFormatter.decimalSeparator = "."
        numberFormatter.maximumFractionDigits = 2
        return  numberFormatter.string(from: NSNumber.init(value: Double(self)! as Double))!
    }
}

extension UITextField {
    func setLeftImage(_ image: UIImage){
        let leftView = UIView(frame: CGRect(x: 0, y: (self.frame.height*25)/200, width: (self.frame.height*75)/100, height: (self.frame.height*75)/100))
        let imageView = UIImageView(image: image)
        let imagex = (self.frame.height*25)/200
        imageView.frame = CGRect(x: imagex, y: (leftView.frame.height*20)/200, width: (leftView.frame.height*80)/100, height: (leftView.frame.height*80)/100)
        leftView.addSubview(imageView)
        self.leftView = leftView
        self.leftViewMode = .always
    }
    func setRightImage(_ image: UIImage){
        let rightView = UIView(frame: CGRect(x: 0, y: (self.frame.height*25)/200, width: (self.frame.height*75)/100, height: (self.frame.height*75)/100))
        let imageView = UIImageView(image: image)
        let imagex = -((self.frame.height*25)/200)
        imageView.frame = CGRect(x: imagex, y: (rightView.frame.height*20)/200, width: (rightView.frame.height*80)/100, height: (rightView.frame.height*80)/100)
        rightView.addSubview(imageView)
        self.rightView = rightView
        self.rightViewMode = .always
    }
}

//extension UITextField {
//
//    open override func awakeFromNib() {
//        super.awakeFromNib()
//        self.autocapitalizationType = UITextAutocapitalizationType.none;
//        self.autocorrectionType = UITextAutocorrectionType.no;
//
//        let view = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
//        self.rightViewMode = UITextField.ViewMode.always;
//        self.rightView = view;
//
//        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(UITextField.viewClick))
//        view.addGestureRecognizer(tapGesture)
//        view.isUserInteractionEnabled = true
//        view.isMultipleTouchEnabled = true
//
//        let toolbar = UIToolbar.init()
//        toolbar.sizeToFit()
//
//        let barFlexible = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
//
//        let barBtnDone = UIBarButtonItem.init(image: #imageLiteral(resourceName: "icon_checkbox"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(btnBarDoneAction))
//
//        barBtnDone.tintColor = UIColor.black
//        toolbar.barTintColor = UIColor.lightGray
//        toolbar.tintColor = COLOUR_ORANGE
//        toolbar.items = [barFlexible,barBtnDone]
//        toolbar.alpha = 0.8
//        self.inputAccessoryView = toolbar
//
//        if self.keyboardType == UIKeyboardType.default {
//        }
//    }
//
//    @objc func viewClick() {
//        self.becomeFirstResponder();
//    }
//    @objc func btnBarDoneAction(){
//        self.resignFirstResponder()
//    }
//}
//extension UITextView
//{
//    open override func awakeFromNib() {
//        self.autocapitalizationType = UITextAutocapitalizationType.none;
//        self.autocorrectionType = UITextAutocorrectionType.no;
//
//        let view = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
//
//        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(UITextView.viewClick))
//        view.addGestureRecognizer(tapGesture)
//        view.isUserInteractionEnabled = true
//        view.isMultipleTouchEnabled = true
//
//        let toolbar = UIToolbar.init()
//        toolbar.sizeToFit()
//        let barFlexible = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
//
//        let barBtnDone = UIBarButtonItem.init(image: #imageLiteral(resourceName: "icon_checkbox"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(btnBarDoneAction))
//        barBtnDone.tintColor = UIColor.black
//        toolbar.barTintColor = UIColor.lightGray
//        toolbar.tintColor = COLOUR_ORANGE
//        toolbar.items = [barFlexible,barBtnDone]
//        toolbar.alpha = 0.9
//        self.inputAccessoryView = toolbar
//    }
//
//    @objc func viewClick() { self.becomeFirstResponder(); }
//    @objc func btnBarDoneAction() { self.resignFirstResponder() }
//
//}
extension UIImage
{
    func resizeWithPercent(percentage: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: size.width * percentage, height: size.height * percentage)))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
    func tinted(with color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }
        color.set()
        withRenderingMode(.alwaysTemplate)
            .draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
    }    
}
extension UILabel{
    
    func textHeight(_ textWidth: CGFloat, textFont: UIFont) -> CGFloat {
        let textRect: CGRect = String(self.text!).boundingRect(with: CGSize(width: textWidth, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: textFont], context: nil)
        let textSize: CGSize = textRect.size;
        
        return self.text! == "" ? 0.0 : textSize.height
    }
    func estimatedTextWidth() -> CGFloat {
        let font = UIFont.systemFont(ofSize: 16)
        let fontAttributes = [NSAttributedString.Key.font: font] // it says name, but a UIFont works
        let size = (self.text)?.size(withAttributes: fontAttributes)
        return (size?.width)! > CGFloat(325) ? 325 : (size?.width)! < CGFloat(75) ? 95
            : (size!.width + 30)
    }
}
extension String {

    mutating func replace(_ string: String, withString: String) -> String {
        return self.replacingOccurrences(of: string, with: withString)
    }
    
    mutating func encode() -> String {
        let customAllowedSet =  CharacterSet(charactersIn:" !+=\"#%/<>?@\\^`{|}$&()*-").inverted
        self = self.addingPercentEncoding(withAllowedCharacters: customAllowedSet)!
        return self
    }
    
    mutating func replaceWhiteSpace(_ withString: String) -> String {
        let components = self.components(separatedBy: CharacterSet.whitespaces)
        let filtered = components.filter({!$0.isEmpty})
        return filtered.joined(separator: "")
    }
    
    func textWidth(_ textHeight: CGFloat, textFont: UIFont) -> CGFloat {
        let textRect: CGRect = self.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: textHeight), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: textFont], context: nil)
        let textSize: CGSize = textRect.size
        return ceil(textSize.width)
    }
    
    func textHeight(_ textWidth: CGFloat, textFont: UIFont) -> CGFloat {
        let textRect: CGRect = self.boundingRect(with: CGSize(width: textWidth, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: textFont], context: nil)
        let textSize: CGSize = textRect.size
        return ceil(textSize.height)
    }
    
    func textSize(_ textFont: UIFont) -> CGSize {
        let textRect: CGRect = self.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: textFont], context: nil)
        return textRect.size;
    }
    
    func trim() -> String { return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) }
    
    func leftPadding(toLength: Int, withPad: String = " ") -> Int {
        
        guard toLength > self.count else { return Int(self)! }
        let padding = String(repeating: withPad, count: toLength - self.count)
        return Int(padding + self)!
    }
    
    func containsEmoji() -> Bool {
        for scalar in unicodeScalars {
            switch scalar.value {
            case 0x1F600...0x1F64F, // Emoticons
            0x1F300...0x1F5FF, // Misc Symbols and Pictographs
            0x1F680...0x1F6FF, // Transport and Map
            0x2600...0x26FF,   // Misc symbols
            0x2700...0x27BF,   // Dingbats
            0xFE00...0xFE0F:   // Variation Selectors
                return true
            default:
                continue
            }
        }
        return false
    }
    
    func convertToUrl() -> URL {
        let data:Data = self.data(using: String.Encoding.utf8)!
        var resultStr: String = String(data: data, encoding: String.Encoding.nonLossyASCII)!
        
        if !(resultStr.hasPrefix("itms://")) && !(resultStr.hasPrefix("file://")) && !(resultStr.hasPrefix("http://")) && !(resultStr.hasPrefix("https://")) { resultStr = "http://" + resultStr }
        
        resultStr = resultStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        return URL(string: resultStr)!
    }
    
    func isNumeric() -> Bool {
        var holder: Float = 0.00
        let scan: Scanner = Scanner(string: self)
        let RET: Bool = scan.scanFloat(&holder) && scan.isAtEnd
        if self == "." { return false }
        return RET
    }
    
    func isContainString(_ subString: String) -> Bool {
        let range = self.range(of: subString, options: NSString.CompareOptions.caseInsensitive, range: self.range(of: self))
        return range == nil ? false : true
    }
    
    func convertToDictionary() -> typeAliasStringDictionary {
        let jsonData: Data = self.data(using: String.Encoding.utf8)!
        do {
            let dict: typeAliasStringDictionary = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions()) as! typeAliasStringDictionary
            return dict
        } catch let error as NSError { print(error) }
        
        return typeAliasStringDictionary()
    }
    
    func convertToDictionary2() -> typeAliasDictionary {
        let jsonData: Data = self.data(using: .utf8)!
        do {
            let dict: typeAliasDictionary = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions()) as! typeAliasDictionary
            return dict
        } catch let error as NSError { print(error) }
        
        return typeAliasDictionary()
    }
    
    func convertToArray() -> [typeAliasDictionary] {
        let jsonData: Data = self.data(using: String.Encoding.utf8)!
        do {
            let array: [typeAliasDictionary] = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions()) as! [typeAliasDictionary]
            return array
        } catch let error as NSError { print(error) }
        
        return [typeAliasDictionary]()
    }
    
    func base64Encoded() -> String {
        if let data = self.data(using: .utf8) { return data.base64EncodedString() }
        return ""
    }
    
    func base64Decoded() -> String {
        if let data = Data(base64Encoded: self) { return String(data: data, encoding: .utf8)! }
        return ""
    }
    
    func hexToUIColor () -> UIColor {
        var cString:String = self.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) { cString.remove(at: cString.startIndex) }
        
        if ((cString.count) != 6) { return UIColor.gray }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func getRediansFromDegrees() -> Double {
        let degree: Double = Double(self)!
        return degree * .pi / 180.0
    }
    
    func extractString(_ checkingType: NSTextCheckingResult.CheckingType) -> [String] {
        var arrText = [String]()
        let detector = try! NSDataDetector(types: checkingType.rawValue)
        let matches = detector.matches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count))
        
        for match in matches {
            let url = (self as NSString).substring(with: match.range)
            arrText.append(url)
        }
        return arrText
    }
    
    func getPhoneNumber() -> [String] { return self.extractString(.phoneNumber) }
    
    func getUrl() -> [String]  { return self.extractString(.link) }
    
    func getAddress() -> [String]  { return self.extractString(.address) }
    
    var getIntergerFromString: String {
        let pattern = UnicodeScalar("0")..."9"
        return String(unicodeScalars
            .compactMap { pattern ~= $0 ? Character($0) : nil })
    }
}

//extension UITextField {
//
//    open override func awakeFromNib() {
//        super.awakeFromNib()
//        self.autocapitalizationType = UITextAutocapitalizationType.none;
//        self.autocorrectionType = UITextAutocorrectionType.no;
//
//        let view = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
//        self.rightViewMode = UITextField.ViewMode.always;
//        self.rightView = view;
//
//        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(UITextField.viewClick))
//        view.addGestureRecognizer(tapGesture)
//        view.isUserInteractionEnabled = true
//        view.isMultipleTouchEnabled = true
//
//        let toolbar = UIToolbar.init()
//        toolbar.sizeToFit()
//
//        let barFlexible = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
//
//        let barBtnDone = UIBarButtonItem.init(image: #imageLiteral(resourceName: "icon_keyboard"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(btnBarDoneAction))
//
//        barBtnDone.tintColor = UIColor.black
//        toolbar.barTintColor = UIColor.lightGray
//        toolbar.tintColor = COLOUR_ORANGE
//        toolbar.items = [barFlexible,barBtnDone]
//        toolbar.alpha = 0.8
//        self.inputAccessoryView = toolbar
//        
//        if self.keyboardType == UIKeyboardType.default {
//        }
//    }
//    
//    @objc func viewClick() {
//        self.becomeFirstResponder();
//    }
//    @objc func btnBarDoneAction(){
//        self.resignFirstResponder()
//    }
//}
//extension UITextView
//{
//    open override func awakeFromNib() {
//        self.autocapitalizationType = UITextAutocapitalizationType.none;
//        self.autocorrectionType = UITextAutocorrectionType.no;
//        
//        let view = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
//        
//        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(UITextView.viewClick))
//        view.addGestureRecognizer(tapGesture)
//        view.isUserInteractionEnabled = true
//        view.isMultipleTouchEnabled = true
//        
//        let toolbar = UIToolbar.init()
//        toolbar.sizeToFit()
//        let barFlexible = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
//        
//        let barBtnDone = UIBarButtonItem.init(image: #imageLiteral(resourceName: "icon_keyboard"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(btnBarDoneAction))
//        barBtnDone.tintColor = UIColor.black
//        toolbar.barTintColor = UIColor.lightGray
//        toolbar.tintColor = COLOUR_ORANGE
//        toolbar.items = [barFlexible,barBtnDone]
//        toolbar.alpha = 0.9
//        self.inputAccessoryView = toolbar
//    }
//    
//    @objc func viewClick() { self.becomeFirstResponder(); }
//    @objc func btnBarDoneAction() { self.resignFirstResponder() }
//    
//}

extension Dictionary {
    func convertToJSonString() -> String {
        do {
            let dataJSon = try JSONSerialization.data(withJSONObject: self as AnyObject, options: JSONSerialization.WritingOptions.prettyPrinted)
            let st: NSString = NSString.init(data: dataJSon, encoding: String.Encoding.utf8.rawValue)!
            return st as String
        } catch let error as NSError { print(error) }
        return ""
    }
    
    func isKeyNull(_ stKey: String) -> Bool {
        let dict: typeAliasDictionary = (self as AnyObject) as! typeAliasDictionary
        if let val = dict[stKey] {
            if "\(val)" == "" || "\(val)" == "<null>"{ return true }
            return false
        }
        return true
    }
}

extension NSRange {
    func toRange(string: String) -> Range<String.Index> {
        let startIndex = string.index(string.startIndex, offsetBy: location)
        let endIndex = string.index(startIndex, offsetBy: length)
        return startIndex..<endIndex
    }
}

extension UIButton {
   
    func setMultiLineText() {
        self.titleLabel?.numberOfLines = 0
        self.titleLabel?.textAlignment = NSTextAlignment.center
    }
}

extension UISegmentedControl {
    func setCubberLayout() {
        self.tintColor = COLOUR_ORANGE;
        self.subviews[0].tintColor = COLOUR_ORANGE
        self.titleForSegment(at: 0)
    }
}

extension UIView {
    
    class func loadFromNibNamed(_ nibNamed: String, bundle : Bundle? = nil) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? UIView
    }
    
    func refreshCorners(value: CGFloat) {
        layer.cornerRadius = value
    }
    
    func round(corners: UIRectCorner, radius: CGFloat) -> Void {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func setHighlight() {
        self.setViewBorder(COLOUR_ORANGE, borderWidth: 2, isShadow: false, cornerRadius: 0, backColor: UIColor.clear)
    }
    
    func unSetHighlight() {
        self.setViewBorder(COLOUR_ORANGE, borderWidth: 1, isShadow: false, cornerRadius: 0, backColor: UIColor.clear)
    }
    
    func setBottomBorder(_ borderColor: UIColor, borderWidth: CGFloat) {
        let tagLayer: String = "100000"
        if (self.layer.sublayers?.count)! > 1 && self.layer.sublayers?.last?.accessibilityLabel == tagLayer {
            self.layer.sublayers?.last?.removeFromSuperlayer()
        }
        let border: CALayer = CALayer()
        border.backgroundColor = borderColor.cgColor;
        border.accessibilityLabel = tagLayer;
        border.frame = CGRect(x: 0, y: self.frame.height - borderWidth, width: self.frame.width, height: borderWidth);
        self.layer.addSublayer(border)
    }
    
    func setViewBorder(_ borderColor: UIColor, borderWidth: CGFloat, isShadow: Bool, cornerRadius: CGFloat, backColor: UIColor) {
        self.backgroundColor = backColor;
        self.layer.borderWidth = borderWidth;
        self.layer.borderColor = borderColor.cgColor;
        self.layer.cornerRadius = cornerRadius;
        if isShadow { self.setShadowDrop(self) }
    }
    
    func setShadowDrop(_ view: UIView) {
        //http://stackoverflow.com/questions/4754392/uiview-with-rounded-corners-and-drop-shadow
        let layer: CALayer = self.layer
        layer.shadowOffset = CGSize(width: 1, height: 1);
        layer.shadowColor = UIColor.black.cgColor;
        layer.shadowRadius = 4.0;
        layer.shadowOpacity = 0.20;
        //layer.shadowPath = UIBezierPath(roundedRect: layer.bounds);
    }
    
    func applyGradient(colours: [UIColor]) -> Void {
        self.applyGradient(colours: colours, locations: nil)
    }
    
    func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    @IBInspectable var borderColor:UIColor? {
        set {
            layer.borderColor = newValue!.cgColor
        }
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor:color)
            }
            else {
                return nil
            }
        }
    }
    
    @IBInspectable var borderWidth:CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}

extension URL {
    func getDataFromQueryString() -> typeAliasStringDictionary {
        let urlComponents: URLComponents = URLComponents(url: self, resolvingAgainstBaseURL: false)!
        let arrQueryItems: Array<URLQueryItem> = urlComponents.queryItems!
        var dictParams = typeAliasStringDictionary()
        for item:URLQueryItem in arrQueryItems { dictParams[item.name] = item.value }
        return dictParams
    }
}
 
