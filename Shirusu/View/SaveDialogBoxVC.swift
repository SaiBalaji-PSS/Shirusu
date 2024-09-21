//
//  SaveDialogBoxVC.swift
//  Shirusu
//
//  Created by Sai Balaji on 07/09/24.
//

import UIKit

protocol SaveDialogBoxDelegate: AnyObject{
    func saveBtnPressed(fileName: String?)
    func icloudSaveBtnPressed(fileName: String?)
    func cancelBtnPressed()
    
}
class SaveDialogBoxVC: UIViewController {
    weak var delegate: SaveDialogBoxDelegate?
    @IBOutlet weak var fileNameTextField: UITextField!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    
    @IBOutlet weak var alertLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.cancelBtn.layer.borderColor = #colorLiteral(red: 0.737254902, green: 0, blue: 0.1764705882, alpha: 1)
        self.cancelBtn.layer.borderWidth = 1
        self.alertLbl.isHidden = true
        self.fileNameTextField.delegate = self
    }


    @IBAction func saveBtnPressed(_ sender: Any) {
        if let fileName = fileNameTextField.text{
            if fileName.isEmpty{
                self.alertLbl.isHidden = false
            }
            else{
              
                self.alertLbl.isHidden = true
                self.dismiss(animated: true)
                self.delegate?.saveBtnPressed(fileName: fileName)
            }
        }
        else{
            self.alertLbl.isHidden = false 
        }
       
       
    }
    
    @IBAction func icloudDriveSaveBtnPressed(_ sender: Any) {
        if let fileName = fileNameTextField.text{
            if fileName.isEmpty{
                self.alertLbl.isHidden = false
            }
            else{
              
                self.alertLbl.isHidden = true
                self.dismiss(animated: true)
                self.delegate?.icloudSaveBtnPressed(fileName: fileName)
            }
        }
        else{
            self.alertLbl.isHidden = false
        }
    }
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        self.delegate?.cancelBtnPressed()
        self.dismiss(animated: true)
    }
}

extension SaveDialogBoxVC: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.alertLbl.isHidden = true
    }
}
