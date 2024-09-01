//
//  CustomTextField.swift
//  Shirusu
//
//  Created by Sai Balaji on 01/09/24.
//

import UIKit

class CustomTextField: UITextView {

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
    
    override func buildMenu(with builder: UIMenuBuilder) {
        if #available(iOS 17.0, *){
            builder.remove(menu: .autoFill)
        }
        super.buildMenu(with: builder)
    }

}
