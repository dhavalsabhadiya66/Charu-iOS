//
//  SideMenuCell.swift
//  Sparkle
//
//  Created by pcmac on 22/03/18.
//  Copyright © 2018 BrainWaves. All rights reserved.
//

import UIKit
//protocol SideMenuDelegate {
//    func SideMenu_SwitchAction(_ btn : UISwitch)
//}
class SideMenuCell: UITableViewCell {
    
//    var delegate : SideMenuDelegate! = nil
    @IBOutlet var viewBG: UIView!
    @IBOutlet var lblTittle: UILabel!
    @IBOutlet var imgMainImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
//    @IBAction func SwitchAction(_ sender: UISwitch) {
//        self.delegate.SideMenu_SwitchAction(sender)
//    }
    
}
