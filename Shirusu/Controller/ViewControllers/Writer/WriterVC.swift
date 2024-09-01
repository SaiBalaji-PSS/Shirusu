//
//  WriterVC.swift
//  Shirusu
//
//  Created by Sai Balaji on 31/08/24.
//

import UIKit
import EasyTipView

class WriterVC: UIViewController {
    //MARK: - PROPERTIES
    
    @IBOutlet weak var translateTextView: UITextView!
    @IBOutlet weak var textEditor: CustomTextField!
    private var tipView: EasyTipView?
    private var clipboardService = ClipBoardService()
    
    //MARK: - LIFECYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.configureTextView()
        self.setupTipViewPreference()
        DatabaseService.shared.loadDB()
        
    }


    //Configure the textEditor, create and addd UIToolbar with custom options as text editor accessory view
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
    //Set up global preference for Easy Tip View
    func setupTipViewPreference(){
        var prefrence = EasyTipView.Preferences()
        prefrence.drawing.foregroundColor = UIColor.white
        prefrence.drawing.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        prefrence.drawing.arrowPosition = .top
        EasyTipView.globalPreferences = prefrence
    }
    
    //MARK: - HELPERS
    ///
    ///This function is used to create UIBarButtonItem for UIToolbar
    ///- Parameters:
    ///     - imageName: SF Symbol image name
    ///     - tag: An Int tag for the tool bar item
    /// - Returns: An UIBarButtonItem with on given SF Symbol image and tag
    /// - Authors: Sai Balaji K
    func createToolBarItem(imageName: String,tag: Int) -> UIBarButtonItem{
        let barItem = UIBarButtonItem(image: UIImage(systemName: imageName), style: .plain, target: self, action: #selector(toolBarItemPressed(_:)))
        barItem.tag = tag
        return barItem
    }
    ///
    ///This function is used to show the easy toop tip view below the rect of the selected text by creating a temporary view and adding the tip view inside the temp view
    ///- Parameters:
    ///     - text: A string for the Easy Tip View content
    ///     - selectedTextRect: A CGRect which represents the rectangular bounding box of the selected text
    /// - Returns: No return value
    /// - Authors: Sai Balaji K
    func showTipView(text: String,selectedTextRect: CGRect){
        tipView?.dismiss()
        tipView = EasyTipView(text: text)
        let tempView = UIView(frame: CGRect(x: selectedTextRect.midX, y: selectedTextRect.maxY + 5, width: 1, height: 1))
        tempView.backgroundColor = UIColor.clear
        self.textEditor.superview?.addSubview(tempView)
        tipView?.show(forView: tempView)
        tempView.removeFromSuperview()
        
        
    }
    ///
    ///This selector function is used to execute the tool bar menu item commands cut, copy, paste and hide keyboard when a tool bar item is pressed
    ///- Parameters:
    ///     - sender: The pressed UIBarButton Item  is the sender
    ///
    /// - Returns: No return value
    /// - Note: It calls the ClipBoardService class methods to perform cut, copy, paste and to get the text at selected rect.
    /// - Authors: Sai Balaji K
    @objc func toolBarItemPressed(_ sender: UIBarButtonItem){
        let itemTag = sender.tag
        switch itemTag{
            case 0:
                print("Copy")
            if let (selectedText,_) = self.clipboardService.getTextInsideTheSelectedRange(textView: self.textEditor){
                self.clipboardService.copyText(text: selectedText)
            }
                break
            case 1:
                print("Paste")
            self.clipboardService.pasteText { textToBePasted in
                if let (_,selectedRange) = self.clipboardService.getTextInsideTheSelectedRange(textView: self.textEditor){
                    if let textToBePasted, textToBePasted.isEmpty == false{
                        self.textEditor.replace(selectedRange, withText: textToBePasted)
                    }
                    
                }
                //If no text is selected then append the clip board text to end of the text editor
                else{
                    if let textToBePasted{
                        self.textEditor.text.append(textToBePasted)
                    }
                }
            }
                break
            case 2:
                print("Cut")
            if let (selectedText,selectedRange) = self.clipboardService.getTextInsideTheSelectedRange(textView: self.textEditor){
                self.clipboardService.cutText(text: selectedText) {
                    self.textEditor.replace(selectedRange, withText: "")
                }
            }
                break
            case 3:
            self.view.endEditing(true)
                break
           default:
                break
        }
    }
    //Shows the tip view with the meaning from the database, hides the tip view when no text is selected
    func getWordMeaning(word: String,textRect: CGRect){
        if word.containsKanji(){
            DatabaseService.shared.getKanjiWordMeaning(word: word) { result , error  in
                if error == nil, let result{
                    DispatchQueue.main.async {
                        self.showTipView(text: result, selectedTextRect: textRect)
                    }
                 
                }
                else{
                    self.tipView?.dismiss()
                }
            }
        }
        else if word.containsHiragana() || word.containsKatakana(){
            DatabaseService.shared.getKanaWordMeaning(word: word) { result , error  in
                if error == nil, let result{
                    DispatchQueue.main.async {
                        self.showTipView(text: result, selectedTextRect: textRect)
                    }
                 
                }
                else{
                    self.tipView?.dismiss()
                }
            }
        }
    }
}



//MARK: - UITextView Delegate Methods
extension WriterVC: UITextViewDelegate{
    //Get the meaning for the selected word from DB
    func textViewDidChangeSelection(_ textView: UITextView) {
        if let selectedRange = textView.selectedTextRange{
            if let selectedText = textView.text(in: selectedRange), selectedText.isEmpty == false{
                print(selectedText)
                let selectedTextRect = textView.firstRect(for: selectedRange)
                self.getWordMeaning(word: selectedText, textRect: selectedTextRect)
               
                
            }
            else{
                self.tipView?.dismiss()
            }
        }
    }
    
}
