//
//  ItemButton.swift
//  yyyb
//
//  Created by admin on 2016/11/23.
//  Copyright © 2016年 norwaya. All rights reserved.
//

import UIKit

class ItemTextField: UITextField ,UITextFieldDelegate{
    public let type_num: Int = 0
    public let type_text: Int  = 1
    var id: Int = 0 //-> indexPakth.row
    var iid: Int = 0
    var input_type: Int?
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.delegate = self
        input_type = type_num
    }
    func setIntputType(type: Int){
        self.input_type = type
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (input_type != type_num){
            return true
        }
        for char in string.unicodeScalars{
            print(char.value)
            
            if char.value < 48{
                return false
            }
            if char.value > 57 {
                return false
            }
        }
        return true;
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return self.resignFirstResponder()
    }
    
}
