//
//  CustomSearchTextField.swift
//  Shirusu
//
//  Created by Sai Balaji on 07/09/24.
//

import UIKit

protocol CustomSearchTextFieldDelegate: AnyObject{
    func didPressSearchButton(text: String?)
}
class CustomSearchTextField: UIView {
    weak var delegate: CustomSearchTextFieldDelegate?
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchBtn: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
       
    }
    
    func commonInit(){
        let viewFromNib = Bundle.main.loadNibNamed("CustomSearchTextField", owner: self,options: nil)?.first! as! UIView
        viewFromNib.frame = self.bounds
        self.addSubview(viewFromNib)
        self.searchTextField.layer.borderColor = UIColor.darkGray.cgColor
        self.searchTextField.layer.borderWidth = 1
        self.searchTextField.setLeftPaddingPoints(8)
        
    }
    
    
    @IBAction func searchBtnPressed(_ sender: UIButton) {
        self.delegate?.didPressSearchButton(text: self.searchTextField.text)
    }
    
}


extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
