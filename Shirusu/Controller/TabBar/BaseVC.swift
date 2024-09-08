//
//  BaseVC.swift
//  Shirusu
//
//  Created by Sai Balaji on 07/09/24.
//

import UIKit

class BaseVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    
    func setUpStatusBarColor(){
        
        let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
        statusBarView.backgroundColor = #colorLiteral(red: 0.737254902, green: 0, blue: 0.1764705882, alpha: 1)
        view.addSubview(statusBarView)
        
    }
    
    
    func showErrorAlert(title: String,message: String,positiveBtnTitle: String){
        let avc = UIAlertController(title: title, message: message, preferredStyle: .alert)
        avc.addAction(UIAlertAction(title: positiveBtnTitle, style: .default))
        self.present(avc, animated: true)
        
    }
    
}
