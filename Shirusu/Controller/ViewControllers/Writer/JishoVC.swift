//
//  JishoVC.swift
//  Shirusu
//
//  Created by Sai Balaji on 04/09/24.
//

import UIKit
import WebKit

class JishoVC: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    private let BASE_URL = "https://jisho.org/search/"
    var word: String?
    
    override func loadView() {
        super.loadView()
        guard let word else{return }
        let FINAL_URL = BASE_URL + word
        print(FINAL_URL)
        self.webView.load(URLRequest(url: URL(string: FINAL_URL)!))
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       
    }

    @IBAction func backBtnPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
}
