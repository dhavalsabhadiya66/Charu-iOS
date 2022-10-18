//
//  DesignModel.swift
//  ECommerce
//
//  Created by admin on 17/12/18.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
import UIKit

let FRAME_SCREEN                                = UIScreen.main.bounds

let PRIORITY_LOW: UILayoutPriority              = UILayoutPriority(rawValue: 555)
let PRIORITY_HIGH: UILayoutPriority             = UILayoutPriority(rawValue: 999)

//MARK: COLOUR
//**************************COLOR******************************************
public func RGBCOLOR(_ r: CGFloat, g: CGFloat , b: CGFloat) -> UIColor {
    return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
}

public func RGBCOLOR(_ r: CGFloat, g: CGFloat , b: CGFloat, alpha: CGFloat) -> UIColor {
    return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: alpha)
}

let COLOUR_NAV                              = RGBCOLOR(0, g: 57, b: 92)
let COLOR_GOLDERN_YELLOW                    = RGBCOLOR(231, g: 170, b: 47)
let COLOUR_ORANGE                           = RGBCOLOR(248, g: 82, b: 110)
let COLOR_BTN_SKYBLUE                       = RGBCOLOR(50, g:194, b:223)
let COLOR_PRIME                             = RGBCOLOR(9, g: 80, b: 172)
let COLOR_PRIME_BLUE                        = RGBCOLOR(0, g: 57, b: 92)
let COLOR_PRIMEDARK                         = RGBCOLOR(143, g:119, b:75)

//let COLOR_SKYBLUE                           = RGBCOLOR(147, g:194, b:223)
//let COLOR_RED                               = RGBCOLOR(199, g: 53, b: 30)

//MARK:- COLOR CODES
//TED: 008080, DUSTYROSE: DCAE96, GRAY: 808080, BROWN: 964B00, NUDE: E3BC9A, GOLD: FFD700


//MARK: CONSTRINT CONSTANT
//******************CONSTRINT CONSTANT******************************************
let CONSTRAINT_TOP                          = "CONSTRAINT_TOP"
let CONSTRAINT_BOTTOM                       = "CONSTRAINT_BOTTOM"
let CONSTRAINT_LEADING                      = "CONSTRAINT_LEADING"
let CONSTRAINT_TRAILING                     = "CONSTRAINT_TRAILING"
let CONSTRAINT_WIDTH                        = "CONSTRAINT_WIDTH"
let CONSTRAINT_HEIGHT                       = "CONSTRAINT_HEIGHT"
let CONSTRAINT_HORIZONTAL                   = "CONSTRAINT_HORIZONTAL"
let CONSTRAINT_VERTICAL                     = "CONSTRAINT_VERTICAL"

//MARK JDPOPOVER CONSTANT
//*******************************************************************************
let JD_POPOVER_ANIMATION                    = "POPOVER_ANIMATION_BOTTOM_TO_TOP"
let JD_SELECTION_ANIMATION                  = "SELECTION_ANIMATION_BOTTOM_TO_TOP"
let JD_IMAGE_ZOOMER_ANIMATION               = "IMAGE_ZOOMER_CROSS_DISSOLVE"
let JD_FILTER_ANIMATION                     = "FILTER_ANIMATION_FADE_IN_OUT"
let JD_POPOVER_DURATION:Double              = 0.3        //0.5
let JD_POPOVER_BG_TRANSPARENT:Bool          = true
let JD_POPOVER_BORDER_COLOR                 = COLOUR_ORANGE
let JD_POPOVER_BORDER_WIDTH:CGFloat         = 0
let JD_POPOVER_CORNER_RADIUS:CGFloat        = 10
let JD_POPOVER_OUT_SIDE_CLICK_HIDDEN:Bool   = true
//*******************************************************************************

let TAG_LAYER_TOP                           = "700"
let TAG_LAYER_BOTTOM                        = "800"


//MARK: CLASS
class DesignModel: NSObject {
    
    //MARK: VARIABLE
    var _JDActivityIndicator: JD_ActivityIndicator?
    
    static let sharedInstance = DesignModel()
    
    class func startActivityIndicator() {
        self.startActivityIndicator(title: "Loading...")
    }
    
    class func startActivityIndicator(title: String) {
        sharedInstance._JDActivityIndicator = JD_ActivityIndicator(title: title)
        Obj_AppDelegate.navigationController.view.addSubview(sharedInstance._JDActivityIndicator!)
    }
    
    class func stopActivityIndicator() {
        sharedInstance._JDActivityIndicator?.removeFromSuperview()
    }
    
    class func showMessage(_ message:String, for view: UIViewController){
        let alert = UIAlertController(title: MSG_TITLE, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        view.present(alert, animated: true, completion: nil)
    }
    
    class func sideMenuButton() -> UIButton {
        let btnSideMenu = UIButton(type: .custom)
        btnSideMenu.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        btnSideMenu.setImage(UIImage(named: "icon_side_menu")!, for: UIControl.State())
        return btnSideMenu
    }
    
    class func setViewBorder(_ view: UIView, borderColor: UIColor, borderWidth: CGFloat, isShadow: Bool, cornerRadius: CGFloat, backColor: UIColor) {
        view.backgroundColor = backColor
        view.layer.borderWidth = borderWidth
        view.layer.borderColor = borderColor.cgColor
        view.layer.cornerRadius = cornerRadius
        if isShadow {
            setShadowDrop(view)
        }
    }
    
    class func setViewBorderWithoutBackColor(_ view: UIView, borderColor: UIColor, borderWidth: CGFloat, isShadow: Bool, cornerRadius: CGFloat) {
        view.layer.borderWidth = borderWidth
        view.layer.borderColor = borderColor.cgColor
        view.layer.cornerRadius = cornerRadius
        if isShadow {
            setShadowDrop(view)
        }
    }
    
    class func setTopBorder(_ view: UIView, borderColor: UIColor, borderWidth: CGFloat) {
        if view.layer.sublayers!.last!.accessibilityLabel != TAG_LAYER_TOP {
            let border = CALayer()
            border.backgroundColor = borderColor.cgColor
            border.accessibilityLabel = String(TAG_LAYER_TOP)
            border.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: borderWidth)
            view.layer.addSublayer(border)
        }
    }
    
    class func setBottomBorderView(_ view: UIView, borderColor: UIColor, borderWidth: CGFloat) {
        if  view.layer.sublayers!.last!.accessibilityLabel != TAG_LAYER_BOTTOM {
            let border = CALayer()
            border.backgroundColor = borderColor.cgColor
            border.accessibilityLabel = String(TAG_LAYER_BOTTOM)
            border.frame = CGRect(x: 0, y: view.frame.height - borderWidth, width: view.frame.width, height: borderWidth)
            view.layer.addSublayer(border)
        }
    }
    class func setShadowDrop(_ view: UIView) {
        let layer = view.layer
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 4.0
        layer.shadowOpacity = 0.40
        layer.shadowPath = UIBezierPath(rect: layer.bounds).cgPath
    }
    
    class func createImageView(_ frame: CGRect, image: UIImage, contentMode: UIView.ContentMode) -> UIImageView
    {
        let imageView: UIImageView = UIImageView.init(frame: frame);
        imageView.image = image;
        imageView.contentMode = contentMode;
        return imageView;
    }
    
    class func createImageView(_ frame: CGRect, imageName: String, contentMode: UIView.ContentMode) -> UIImageView
    {
        let imageView: UIImageView = self.createImageView(frame, image:UIImage(named: imageName)!, contentMode:contentMode);
        return imageView;
    }
    
    class func createImageView(_ frame: CGRect, imageName: String, tag: Int, contentMode: UIView.ContentMode) -> UIImageView
    {
        let imageView: UIImageView = self.createImageView(frame, image:UIImage(named: imageName)!, tag:tag , contentMode:contentMode);
        return imageView;
    }
    
    class func createImageView(_ frame: CGRect, image: UIImage, tag: Int, contentMode: UIView.ContentMode) -> UIImageView
    {
        let imageView: UIImageView = self.createImageView(frame, tag:tag, contentMode:contentMode);
        imageView.image = image;
        return imageView;
    }
    
    class func createImageView(_ frame: CGRect, tag: Int, contentMode: UIView.ContentMode) -> UIImageView
    {
        let imageView: UIImageView = UIImageView.init(frame: frame);
        imageView.tag = tag;
        imageView.contentMode = contentMode;
        return imageView;
    }
    
    class func createTableView(_ frame: CGRect, rowHeight: CGFloat, separatorColor: UIColor, isBounce: Bool) -> UITableView {
        let tableView = UITableView(frame: frame, style: .plain)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.rowHeight = rowHeight
        tableView.bounces = isBounce
        //tableView.tableFooterView! = UIView(frame: CGRect.zero)
        tableView.separatorColor = separatorColor
        tableView.backgroundColor = UIColor.clear
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }
    
    //MARK: IMAGE METHODS
    class func resizeImageByWidth(_ image: UIImage, width: CGFloat) -> UIImage {
        let imageWidth: CGFloat = image.size.width;
        let imageHeight: CGFloat = image.size.height;
        let newHeight: CGFloat = (imageHeight / imageWidth) * width;
        return self.imageByScalingToSize(image, targetSize: CGSize(width: width, height: newHeight))
    }
    
    class func resizeImageByHeight(_ image: UIImage, height: CGFloat) -> UIImage {
        let imageWidth: CGFloat = image.size.width;
        let imageHeight: CGFloat = image.size.height;
        let newWidth: CGFloat = (imageWidth / imageHeight) * height;
        return self.imageByScalingToSize(image, targetSize: CGSize(width: newWidth, height: height))
    }
    
    class func imageByScalingToSize(_ sourceImage: UIImage, targetSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(targetSize, false, 2.0);
        sourceImage.draw(in: CGRect(x: 0, y: 0,width: targetSize.width,height: targetSize.height))
        let generatedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        return generatedImage;
    }
    
    class func createImageButton(_ frame: CGRect, imageName: String, tag: Int) -> UIButton {
        return self.createImageButton(frame, image: UIImage(named: imageName)!, tag: tag)
    }
    
    class func createImageButton(_ frame: CGRect, image: UIImage, tag: Int) -> UIButton {
        let button: UIButton = UIButton(type: UIButton.ButtonType.custom)
        button.frame = frame
        button.tag = tag
        button.setImage(image, for: UIControl.State())
        button.showsTouchWhenHighlighted = true
        button.backgroundColor = UIColor.clear
        button.showsTouchWhenHighlighted = true
        button.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
        return button
    }
    
    class func createImageButton(_ frame: CGRect, unSelectedImage: UIImage, selectedImage: UIImage, tag: Int) -> UIButton {
        let button: UIButton = self.createImageButton(frame, image: unSelectedImage, tag: tag)
        button.setImage(selectedImage, for: UIControl.State.selected)
        return button
    }
    
    class func createImageButton(_ frame: CGRect, unSelectedImageName: String, selectedImageName: String, tag: Int) -> UIButton {
        return self.createImageButton(frame, unSelectedImage: UIImage.init(named: unSelectedImageName)!, selectedImage: UIImage(named: selectedImageName)!, tag: tag)
    }
    
    class func createButton(_ frame: CGRect, title: String, bgColor: UIColor, titleFont: UIFont, titleColor: UIColor, cornerRadius: CGFloat) -> UIButton {
        let btn = UIButton(type: .custom)
        btn.frame = frame
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(titleColor, for: .normal)
        btn.titleLabel!.font = titleFont
        btn.backgroundColor = bgColor
        btn.layer.cornerRadius = cornerRadius
        btn.showsTouchWhenHighlighted = true
        return btn
    }
    
    class func createButton(_ frame: CGRect, title: String, tag: Int, titleColor: UIColor, titleFont: UIFont, textAlignment: UIControl.ContentHorizontalAlignment, bgColor: UIColor, borderWidth: CGFloat, borderColor: UIColor?, cornerRadius: CGFloat) -> UIButton {
        let button: UIButton = UIButton(type: UIButton.ButtonType.custom)
        button.frame = frame
        button.tag = tag
        button.setTitle("", for: .normal)
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = titleFont
        button.contentHorizontalAlignment = textAlignment
        button.backgroundColor = bgColor
        button.layer.cornerRadius = cornerRadius
        button.showsTouchWhenHighlighted = true
        button.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
        
        if borderWidth != 0 { button.layer.borderWidth = borderWidth }
        if borderColor != nil { button.layer.borderColor = borderColor!.cgColor }
        
        return button
    }
    
    class func createImageButton(_ frame: CGRect, bgColor: UIColor, borderColor: UIColor, borderWidth: CGFloat, cornerRadius: CGFloat, tag: Int) -> UIButton {
        let btn = UIButton(type: .custom)
        btn.frame = frame
        btn.backgroundColor = bgColor
        btn.layer.cornerRadius = cornerRadius
        btn.showsTouchWhenHighlighted = true
        btn.titleLabel!.numberOfLines = 0
        btn.tag = tag
        if borderWidth != 0 {
            btn.layer.borderColor = borderColor.cgColor
            btn.layer.borderWidth = borderWidth
        }
        return btn
    }
    
    class func createLabel(_ frame:CGRect,text:String,textColor:UIColor,textAlignment:NSTextAlignment,textFont:UIFont,backColor:UIColor,tag:Int) -> UILabel
    {
        let label:UILabel = UILabel.init(frame: frame)
        label.textColor = textColor
        label.text = text
        label.font = textFont
        label.textAlignment = textAlignment
        label.tag = tag
        label.backgroundColor = backColor
        label.numberOfLines = 0
        
        return label
        
    }
    class func createPaddingLabel(frame: CGRect, labelTag: Int, textColor: UIColor, textAlignment: NSTextAlignment, textFont: UIFont, padding: UIEdgeInsets) -> UILabel {
        
        let label:UILabel = UILabel.init(frame: frame)
        
        label.tag = labelTag
        label.textColor = textColor
        label.font = textFont
        label.textAlignment = textAlignment
        label.textColor = textColor
        label.numberOfLines = 0
        label.backgroundColor = UIColor.clear
        
        return label
    }
    class func createRegularLabel(_ frame: CGRect, labelTag: Int, textColor: UIColor, textAlignment: NSTextAlignment, textFont: UIFont) -> UILabel {
        let label = UILabel(frame: frame)
        label.tag = labelTag
        label.textColor = textColor
        label.font = textFont
        label.textAlignment = textAlignment
        label.textColor = textColor
        label.backgroundColor = UIColor.clear
        label.numberOfLines = 0
        return label
    }
    
    class func createScrollView(_ frame:CGRect ,tag: Int, Bounces:Bool)
        -> UIScrollView {
            let scrollView: UIScrollView = UIScrollView(frame: frame)
            scrollView.tag = tag
            scrollView.bounces = Bounces
            scrollView.isUserInteractionEnabled = true
            scrollView.isMultipleTouchEnabled = true
            
            return scrollView
    }
    
    
    class func getTextWidthWithoutFont(_ text:String , textHeight:CGFloat)-> CGFloat{
        let textRect = text.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: textHeight), options: .usesLineFragmentOrigin, attributes: nil, context: nil)
        
        return textRect.size.width
    }
    
    class func getTextWidth(_ text: String, textHeight: CGFloat, textFont: UIFont) -> CGFloat {
        let textRect = text.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: textHeight), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: textFont], context: nil)
        let textSize = textRect.size
        return textSize.width
    }
    
    //MARK: ACTIVITYINDICATOR METHODS
    class func createActivityIndicator(_ frame:CGRect , indicatorStyle :UIActivityIndicatorView.Style) -> UIActivityIndicatorView
    {
        let activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView.init(frame: frame)
        activityIndicator.style = indicatorStyle
        activityIndicator.hidesWhenStopped = true
        
        return activityIndicator
    }
    
    //MARK: SEARCH DESIGN COMMON METHOD
    class func setSelectedButtonStyle(_ button: UIButton) {
        button.isSelected = true
        button.setTitleColor(UIColor.white, for: .selected)
        DesignModel.setViewBorder(button, borderColor: COLOUR_ORANGE, borderWidth: 1, isShadow: false, cornerRadius: 0, backColor: COLOUR_ORANGE)
    }
    
    class func setUnSelectedButtonStyle(_ button: UIButton) {
        DesignModel.setViewBorder(button, borderColor: COLOUR_ORANGE, borderWidth: 1, isShadow: false, cornerRadius: 0, backColor: UIColor.clear)
        button.isSelected = false
        button.setTitleColor(COLOUR_ORANGE, for: .normal)
    }
    
    class func setSelectedButtonStyle_2(_ button: UIButton) {
        DesignModel.setViewBorder(button, borderColor: COLOUR_ORANGE, borderWidth: 1, isShadow: false, cornerRadius: 5, backColor: COLOUR_ORANGE)
        button.isSelected = true
        button.setTitleColor(COLOUR_ORANGE, for: .selected)
    }
    
    class func setUnSelectedButtonStyle_2(_ button: UIButton) {
        button.backgroundColor = COLOUR_ORANGE
        button.isSelected = false
        button.setTitleColor(COLOUR_ORANGE, for: .normal)
    }
    
    //MARK: NSLAYOUTCONSTRAINT METHODS
    class func setConstraint_ConWidth_ConHeight_Horizontal_Vertical(_ subView: UIView, superView: UIView, width: CGFloat, height: CGFloat) -> typeAliasDictionary {
        subView.translatesAutoresizingMaskIntoConstraints  = false;
        
        //WIDTH -  CONSTATNT
        let constraintWidth: NSLayoutConstraint = NSLayoutConstraint(item: subView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: width)
        superView.addConstraint(constraintWidth)
        
        //HEIGHT -  CONSTATNT
        let constraintHeight: NSLayoutConstraint = NSLayoutConstraint(item: subView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: height)
        superView.addConstraint(constraintHeight)
        
        //HORZONTAL
        let constraintHorizontal: NSLayoutConstraint = NSLayoutConstraint(item: subView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: superView, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        superView.addConstraint(constraintHorizontal)
        
        //VERTICAL
        let constraintVertical: NSLayoutConstraint = NSLayoutConstraint(item: subView, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: superView, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
        superView.addConstraint(constraintVertical)
        
        superView.layoutIfNeeded()
        
        return [CONSTRAINT_WIDTH:constraintWidth,
                CONSTRAINT_HEIGHT:constraintHeight,
                CONSTRAINT_HORIZONTAL:constraintHorizontal,
                CONSTRAINT_VERTICAL:constraintVertical]
    }
    
    
    class func setConstraint_ConWidth_ConHeight_Leading_Top(_ subView: UIView, superView: UIView, width: CGFloat, height: CGFloat , top:CGFloat , leading:CGFloat) -> typeAliasDictionary {
        subView.translatesAutoresizingMaskIntoConstraints  = false;
        
        //WIDTH -  CONSTATNT
        let constraintWidth: NSLayoutConstraint = NSLayoutConstraint(item: subView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: width)
        superView.addConstraint(constraintWidth)
        
        //HEIGHT -  CONSTATNT
        let constraintHeight: NSLayoutConstraint = NSLayoutConstraint(item: subView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: height)
        superView.addConstraint(constraintHeight)
        
        //HORZONTAL
        let constraintHorizontal: NSLayoutConstraint = NSLayoutConstraint(item: subView, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: superView, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: leading)
        superView.addConstraint(constraintHorizontal)
        
        //VERTICAL
        let constraintVertical: NSLayoutConstraint = NSLayoutConstraint(item: subView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: superView, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: top)
        superView.addConstraint(constraintVertical)
        
        superView.layoutIfNeeded()
        
        return [CONSTRAINT_WIDTH:constraintWidth,
                CONSTRAINT_HEIGHT:constraintHeight,
                CONSTRAINT_HORIZONTAL:constraintHorizontal,
                CONSTRAINT_VERTICAL:constraintVertical]
    }
    
    class func setConstraint_Leading_Top_ConWidth_ConHeight(subView: UIView, superView: UIView, leading: CGFloat, top: CGFloat, width: CGFloat, height: CGFloat) -> typeAliasDictionary {
        subView.translatesAutoresizingMaskIntoConstraints  = false;
        
        //LEADING - TO SUPERVIEW
        let constraintLeading: NSLayoutConstraint = NSLayoutConstraint(item: subView, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: superView, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: leading)
        superView.addConstraint(constraintLeading)
        
        //TOP - TO SUPERVIEW
        let constraintTop: NSLayoutConstraint = NSLayoutConstraint(item: subView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: superView, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: top)
        superView.addConstraint(constraintTop)
        
        //WIDTH -  CONSTATNT
        let constraintWidth: NSLayoutConstraint = NSLayoutConstraint(item: subView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: width)
        superView.addConstraint(constraintWidth)
        
        //HEIGHT -  CONSTATNT
        let constraintHeight: NSLayoutConstraint = NSLayoutConstraint(item: subView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: height)
        superView.addConstraint(constraintHeight)
        
        superView.layoutIfNeeded()
        
        return [CONSTRAINT_LEADING:constraintLeading,
                CONSTRAINT_TOP:constraintTop,
                CONSTRAINT_WIDTH:constraintWidth,
                CONSTRAINT_HEIGHT:constraintHeight]
        
    }
    
    class func setConstraint_Trailing_Top_ConWidth_ConHeight(subView: UIView, superView: UIView, trailing: CGFloat, top: CGFloat, width: CGFloat, height: CGFloat) -> typeAliasDictionary {
        subView.translatesAutoresizingMaskIntoConstraints  = false;
        
        //TRAILING - TO SUPERVIEW
        let constraintTrailing: NSLayoutConstraint = NSLayoutConstraint(item: subView, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: superView, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: trailing)
        superView.addConstraint(constraintTrailing)
        
        //TOP - TO SUPERVIEW
        let constraintTop: NSLayoutConstraint = NSLayoutConstraint(item: subView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: superView, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: top)
        superView.addConstraint(constraintTop)
        
        //WIDTH -  CONSTATNT
        let constraintWidth: NSLayoutConstraint = NSLayoutConstraint(item: subView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: width)
        superView.addConstraint(constraintWidth)
        
        //HEIGHT -  CONSTATNT
        let constraintHeight: NSLayoutConstraint = NSLayoutConstraint(item: subView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: height)
        superView.addConstraint(constraintHeight)
        
        superView.layoutIfNeeded()
        
        return [CONSTRAINT_TRAILING:constraintTrailing,
                CONSTRAINT_TOP:constraintTop,
                CONSTRAINT_WIDTH:constraintWidth,
                CONSTRAINT_HEIGHT:constraintHeight]
    }
    
    
    class func setScrollSubViewConstraint(_ subView: UIView, superView :UIView, toView: UIView, leading: CGFloat, trailing: CGFloat, top: CGFloat, bottom: CGFloat, width: CGFloat, height: CGFloat) -> typeAliasDictionary {
        
        subView.translatesAutoresizingMaskIntoConstraints  = false;
        
        //LEADING - TO SUPERVIEW
        let constraintLeading: NSLayoutConstraint = NSLayoutConstraint(item: subView, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: toView, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: leading)
        superView.addConstraint(constraintLeading)
        
        //TRAILING - TO SUPERVIEW
        let constraintTrailing: NSLayoutConstraint = NSLayoutConstraint(item: subView, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: toView, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: trailing)
        superView.addConstraint(constraintTrailing);
        
        //TOP - TO SUPERVIEW
        let constraintTop: NSLayoutConstraint = NSLayoutConstraint(item: subView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: toView, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: top)
        superView.addConstraint(constraintTop);
        
        //BOTTOM - TO SUPERVIEW
        let constraintBottom: NSLayoutConstraint = NSLayoutConstraint(item: subView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: toView, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: bottom)
        superView.addConstraint(constraintBottom);
        
        //WIDTH -  CONSTATNT
        let constraintWidth: NSLayoutConstraint = NSLayoutConstraint(item: subView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: toView, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant: width)
        superView.addConstraint(constraintWidth);
        
        //HEIGHT - CONSTANT
        let constraintHeight: NSLayoutConstraint = NSLayoutConstraint(item: subView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: toView, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1, constant: height)
        superView.addConstraint(constraintHeight);
        
        superView.layoutIfNeeded()
        
        return [CONSTRAINT_LEADING:constraintLeading,
                CONSTRAINT_TRAILING:constraintTrailing,
                CONSTRAINT_TOP:constraintTop,
                CONSTRAINT_BOTTOM:constraintBottom,
                CONSTRAINT_WIDTH:constraintWidth,
                CONSTRAINT_HEIGHT:constraintHeight]
    }
    
    
    //MARK: ROTATION
    class func rotateView(_ view: UIView, angle: CGFloat, isAnimation: Bool) {
        if isAnimation {
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .beginFromCurrentState, animations: {() -> Void in
                view.transform = CGAffineTransform(rotationAngle: angle)
            }, completion: { _ in })
        }
        else {
            view.transform = CGAffineTransform(rotationAngle: angle)
        }
    }
    
    class func rotateView_90(_ view: UIView, isAnimation: Bool) {
        self.rotateView(view, angle: (-(.pi / 2)), isAnimation: isAnimation)
    }
    
    class func rotateView_MINUS_90(_ view: UIView, isAnimation: Bool) {
        self.rotateView(view, angle: (.pi / 2), isAnimation: isAnimation)
    }
    
    class func rotateView_180(_ view: UIView, isAnimation: Bool) {
        self.rotateView(view, angle: .pi, isAnimation: isAnimation)
    }
    
    class func rotateView_360(_ view: UIView, isAnimation: Bool) {
        self.rotateView(view, angle: (.pi * 2), isAnimation: isAnimation)
    }
    
    class func getOrientation(_ view: UIView) -> Int {
        //0 - Potrait , 1 - Landscape
        let frame = view.frame
        return frame.width > frame.height ? 1 : 0
    }
    
    class func showShareActivity(with data: NSMutableData, for view: UIView){
//        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
//        let activityViewController = UIActivityViewController(activityItems: [data], applicationActivities: nil)
//        activityViewController.popoverPresentationController?.sourceView = view
//        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.postToFacebook, UIActivity.ActivityType.mail, UIActivity.ActivityType.message]
//        appDelegate.navigationController.present(activityViewController, animated: true) {
//            DesignModel.stopActivityIndicator()
//        }
    }
}


class DisablePastTextField: UITextField {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)){
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
}
