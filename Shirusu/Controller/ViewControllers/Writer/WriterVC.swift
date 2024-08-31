//
//  WriterVC.swift
//  Shirusu
//
//  Created by Sai Balaji on 31/08/24.
//

import UIKit


class WriterVC: UIViewController {

    @IBOutlet weak var textEditor: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.configureTextView()
    }


    func configureTextView(){
        textEditor.backgroundColor = #colorLiteral(red: 0.9238191843, green: 0.9207934141, blue: 0.6188468337, alpha: 1)
        textEditor.textColor = UIColor.black
        textEditor.delegate = self
        
    }

}

extension WriterVC: UITextViewDelegate{
    func textViewDidChangeSelection(_ textView: UITextView) {
        if let selectedRange = textView.selectedTextRange{
            if let selectedText = textView.text(in: selectedRange), selectedText.isEmpty == false{
                print(selectedText)
            }
        }
    }
}
