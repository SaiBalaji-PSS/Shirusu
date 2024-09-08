//
//  SaveDialogBoxVC.swift
//  Shirusu
//
//  Created by Sai Balaji on 07/09/24.
//

import UIKit

protocol SaveDialogBoxDelegate: AnyObject{
    func saveBtnPressed(fileName: String?)
    func cancelBtnPressed()
    
}
class SaveDialogBoxVC: UIViewController {
    weak var delegate: SaveDialogBoxDelegate?
    @IBOutlet weak var fileNameTextField: UITextField!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.cancelBtn.layer.borderColor = #colorLiteral(red: 0.737254902, green: 0, blue: 0.1764705882, alpha: 1)
        self.cancelBtn.layer.borderWidth = 1
    }


    @IBAction func saveBtnPressed(_ sender: Any) {
        self.delegate?.saveBtnPressed(fileName: self.fileNameTextField.text)
        self.dismiss(animated: true)
    }
    

    @IBAction func cancelBtnPressed(_ sender: Any) {
        self.delegate?.cancelBtnPressed()
        self.dismiss(animated: true)
    }
}
