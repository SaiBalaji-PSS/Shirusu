//
//  JishoVC.swift
//  Shirusu
//
//  Created by Sai Balaji on 04/09/24.
//

import UIKit
import WebKit

class JishoVC: UIViewController {

    @IBOutlet weak var loadingProgressBar: UIProgressView!
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
        self.webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress),options: .new, context: nil)
       
    }

    @IBAction func backBtnPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func forwardBtnPressed(_ sender: Any) {
        if self.webView.canGoForward{
            self.webView.goForward()
        }
    }
    
    
    @IBAction func backwardBtnPressed(_ sender: Any) {
        if self.webView.canGoBack{
            self.webView.goBack()
            
        }
    }
    
    override  func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress"{
            loadingProgressBar.progress = Float(webView.estimatedProgress)
        }
    }
    
}
