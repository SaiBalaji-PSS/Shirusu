//
//  SheetViewVC.swift
//  Shirusu
//
//  Created by Sai Balaji on 08/09/24.
//

import UIKit

class SheetViewVC: BaseVC {

    @IBOutlet weak var fileNameLbl: UILabel!
    @IBOutlet weak var textView: UITextView!
    var content: String?
    var fileName: String?
    
    override func loadView() {
        super.loadView()
        setUpStatusBarColor()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.configureUI()
        
    }

    
    func configureUI(){
        if let content{
            self.textView.text = content
        }
        if let fileName{
            self.fileNameLbl.text = fileName
        }
    }

    @IBAction func backBtnPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    
    

}
