//
//  CustomCellTableViewCell.swift
//  yyyb
//
//  Created by admin on 2016/11/19.
//  Copyright © 2016年 norwaya. All rights reserved.
//

import UIKit

class CustomCellTableViewCell: UITableViewCell {

    @IBOutlet weak var iv: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setLabel(name: String){
        label.text = name 
    }
    func setIv(name: String){
        iv.image = UIImage.init(named: "")
    }
    
}
