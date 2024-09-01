//
//  WriterVC.swift
//  Shirusu
//
//  Created by Sai Balaji on 31/08/24.
//

import UIKit
import EasyTipView

class WriterVC: UIViewController {

    @IBOutlet weak var bottomMenuView: UIView!
    @IBOutlet weak var textEditor: CustomTextField!
    private var tipView: EasyTipView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.configureTextView()
        self.setupTipViewPreference()
    }


    func configureTextView(){
        textEditor.backgroundColor = #colorLiteral(red: 0.9238191843, green: 0.9207934141, blue: 0.6188468337, alpha: 1)
        textEditor.textColor = UIColor.black
        textEditor.delegate = self
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 60))
       
        let flexibleSpace = UIBarButtonItem(systemItem: .flexibleSpace)
        toolBar.items = [self.createToolBarItem(imageName: "doc.on.doc", tag: 0),flexibleSpace,self.createToolBarItem(imageName: "doc.on.clipboard", tag: 1),flexibleSpace,self.createToolBarItem(imageName: "scissors", tag: 2),flexibleSpace,self.createToolBarItem(imageName: "keyboard.chevron.compact.down", tag: 3)]
        toolBar.sizeToFit()
        textEditor.inputAccessoryView = toolBar
        
    }
    func setupTipViewPreference(){
        var prefrence = EasyTipView.Preferences()
        prefrence.drawing.foregroundColor = UIColor.white
        prefrence.drawing.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        prefrence.drawing.arrowPosition = .top
        EasyTipView.globalPreferences = prefrence
    }
    
    func createToolBarItem(imageName: String,tag: Int) -> UIBarButtonItem{
        let barItem = UIBarButtonItem(image: UIImage(systemName: imageName), style: .plain, target: self, action: #selector(toolBarItemPressed(_:)))
        barItem.tag = tag
        return barItem
    }
    
    func showTipView(text: String,selectedTextRect: CGRect){
        tipView?.dismiss()
        tipView = EasyTipView(text: text)
        let tempView = UIView(frame: CGRect(x: selectedTextRect.midX, y: selectedTextRect.maxY + 120, width: 1, height: 1))
        tempView.backgroundColor = UIColor.clear
        self.textEditor.superview?.addSubview(tempView)
        tipView?.show(forView: tempView)
        
        
    }
    
    @objc func toolBarItemPressed(_ sender: UIBarButtonItem){
        let itemTag = sender.tag
        switch itemTag{
            case 0:
                print("Copy")
                break
            case 1:
                print("Paste")
                break
            case 2:
                print("Cut")
                break
            case 3:
            self.view.endEditing(true)
                break
           default:
                break
        }
    }
}




extension WriterVC: UITextViewDelegate{
    func textViewDidChangeSelection(_ textView: UITextView) {
        if let selectedRange = textView.selectedTextRange{
            if let selectedText = textView.text(in: selectedRange), selectedText.isEmpty == false{
                print(selectedText)
                let selectedTextRect = textView.firstRect(for: selectedRange)
                self.showTipView(text: selectedText, selectedTextRect: selectedTextRect)
            }
            else{
                self.tipView?.dismiss()
            }
        }
    }
    
}
