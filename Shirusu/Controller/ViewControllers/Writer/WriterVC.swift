//
//  WriterVC.swift
//  Shirusu
//
//  Created by Sai Balaji on 31/08/24.
//

import UIKit
import EasyTipView

class WriterVC: BaseVC {
    //MARK: - PROPERTIES
    

    @IBOutlet weak var jishoBtn: UIButton!
    @IBOutlet weak var bottomContraint: NSLayoutConstraint!
    @IBOutlet weak var textEditor: CustomTextField!
    private var tipView: EasyTipView?
    private var clipboardService = ClipBoardService()
    private var selectedWord: String?
    private var documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.text])
    private var isSelectModeEnalbed = false
    private var flashCardWord: FlashCardWordModel?
    //MARK: - LIFECYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.configureTextView()
        self.setupTipViewPreference()
        DatabaseService.shared.loadDB()
        self.setUpStatusBarColor()
        self.setupKeyboardObservers()
        self.jishoBtn.isHidden = true
        
    }
    
    func setupKeyboardObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    
    @objc func keyboardWillShow(_ notification: Notification) {
        // Get the userInfo dictionary from the notification
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }

        let keyboardHeight = keyboardFrame.height
        print("Keyboard height: \(keyboardHeight)")
             self.bottomContraint.constant = -(keyboardHeight - 50)
        
        
    }
    @objc func keyboardWillHide(_ notification: Notification) {
        // Reset any layout changes or content insets here if needed
        self.bottomContraint.constant = 0.0
    }
    
    

    @IBAction func newSheetBtnPressed(_ sender: Any) {

        self.textEditor.text = ""
        self.view.endEditing(true)
        self.isSelectModeEnalbed = false 
        //show toast
    }
    
    @IBAction func addToListBtnPressed(_ sender: Any) {
        print(self.selectedWord)
        print(flashCardWord)
        if let flashCardWord{
            RealmManager.shared.saveDataToRealm(word: flashCardWord) { error  in
                if let error{
                    self.showErrorAlert(title: "Error", message: error.localizedDescription, positiveBtnTitle: "Ok")
                }
            }
        }
       
    }
    //    @IBAction func redoBtnPressed(_ sender: Any) {
//        if let canRedo = textEditor.undoManager?.canRedo{
//            if canRedo{
//                textEditor.undoManager?.redo()
//            }
//        }
//    }
    
    @IBAction func jishoBtnPressed(_ sender: Any) {
        if let selectedWord{
            let jishoVC = JishoVC(nibName: "JishoVC", bundle: nil)
            jishoVC.delegate = self
            jishoVC.modalPresentationStyle = .fullScreen
            jishoVC.word = selectedWord
            self.tipView?.dismiss()
            self.present(jishoVC, animated: true)
        }
     
    }
    
    @IBAction func saveBtnPressed(_ sender: Any) {
        self.tipView?.dismiss()
        let saveVC = SaveDialogBoxVC(nibName: "SaveDialogBoxVC", bundle: nil)
        saveVC.modalPresentationStyle = .overCurrentContext
        saveVC.modalTransitionStyle = .crossDissolve
        saveVC.delegate = self
        self.present(saveVC, animated: true)
    }
    
    @IBAction func searchBtnPressed(_ sender: Any) {
        let searchVC = WordSearchVC(nibName: "WordSearchVC", bundle: nil)
        searchVC.delegate = self
        searchVC.modalTransitionStyle = .flipHorizontal
        searchVC.modalPresentationStyle = .fullScreen
        self.present(searchVC, animated: true)
    }
    
    
    @IBAction func selectModeBtnPressed(_ sender: UIButton) {
        
        if isSelectModeEnalbed == false{
            self.jishoBtn.isHidden = false
            print("IS SELECTION MODE ENABLED \(isSelectModeEnalbed)")
            self.view.endEditing(true)
            self.textEditor.isEditable = false
            self.textEditor.isSelectable = true
            self.isSelectModeEnalbed = true
        }
        else{
           // self.textEditor.resignFirstResponder()
            self.jishoBtn.isHidden = true
            print("IS SELECTION MODE ENABLED \(isSelectModeEnalbed)")
            self.tipView?.dismiss()
            print("DISMISSED")
            //self.selectedWord = nil
            self.textEditor.isEditable = true
            self.textEditor.isSelectable = true
            self.isSelectModeEnalbed = false
        }

       
       // self.bottomContraint.constant = - (UIScreen.main.bounds.size.height / 2.0)
        
    }
    
    @IBAction func fileOpenBtnPressed(_ sender: Any) {
        self.tipView?.dismiss()
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .fullScreen
        documentPicker.allowsMultipleSelection = false
        self.present(documentPicker, animated: true)
    }
    
    
    //Configure the textEditor, create and addd UIToolbar with custom options as text editor accessory view
    func configureTextView(){
        textEditor.textColor = UIColor.black
        textEditor.delegate = self
        textEditor.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 0)

        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 60))
       
        let flexibleSpace = UIBarButtonItem(systemItem: .flexibleSpace)
        toolBar.items = [self.createToolBarItem(imageName: "doc.on.doc", tag: 0),flexibleSpace,self.createToolBarItem(imageName: "doc.on.clipboard", tag: 1),flexibleSpace,self.createToolBarItem(imageName: "scissors", tag: 2),flexibleSpace,self.createToolBarItem(imageName: "keyboard.chevron.compact.down", tag: 3)]
        toolBar.sizeToFit()
        textEditor.inputAccessoryView = toolBar
        self.tabBarController?.delegate = self
        
    }
    //Set up global preference for Easy Tip View
    func setupTipViewPreference(){

        var prefrence = EasyTipView.Preferences()
        prefrence.drawing.foregroundColor = UIColor.white
        prefrence.drawing.backgroundColor = #colorLiteral(red: 0.737254902, green: 0, blue: 0.1764705882, alpha: 1)
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
        let convertedRect = self.textEditor.convert(selectedTextRect, to: self.textEditor.superview)
        let tempView = UIView(frame: CGRect(x: convertedRect.midX, y: convertedRect.maxY + 5, width: 1, height: 1))
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
    
    func readTheContentOfTextFile(fileURL: URL){
        do{
            let content = try Data(contentsOf: fileURL)
            self.textEditor.text = String(data: content, encoding: .utf8)
        }
        catch{
            print(error)
            self.showErrorAlert(title: "Error", message: error.localizedDescription, positiveBtnTitle: "Ok")
        }
    }
    //Shows the tip view with the meaning from the database, hides the tip view when no text is selected
    func getWordMeaning(word: String,textRect: CGRect){
        if word.containsKanji(){
            DatabaseService.shared.getKanjiWordMeaning(word: word) { result , error, flashCardWord  in
                DispatchQueue.main.async {
                    if error == nil, let result, let flashCardWord{
                        self.flashCardWord = flashCardWord
               
                            self.showTipView(text: result, selectedTextRect: textRect)
                        
                     
                    }
                    else{
                        self.tipView?.dismiss()
                        self.selectedWord = nil
                        
                    }
                }
              
            }
        }
        else if word.containsHiragana() || word.containsKatakana(){
            DatabaseService.shared.getKanaWordMeaning(word: word) { result , error, flashCardWord  in
                DispatchQueue.main.async {
                    if error == nil, let result, let flashCardWord{
                        self.flashCardWord = flashCardWord
                        
                        self.showTipView(text: result, selectedTextRect: textRect)
                        
                        
                    }
                    else{
                        self.tipView?.dismiss()
                        self.selectedWord = nil
                    }
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
            if isSelectModeEnalbed{
                if let selectedText = textView.text(in: selectedRange), selectedText.isEmpty == false{
                    print(selectedText)
                    let selectedTextRect = textView.firstRect(for: selectedRange)
                    self.selectedWord = selectedText
                    print("SELCTED TEXT IS \(self.selectedWord)")
                    self.getWordMeaning(word: selectedText, textRect: selectedTextRect)
                    
                    
                }
                else{
                    self.selectedWord = nil
                    self.tipView?.dismiss()
                }
            }
        }
    }
    
}

extension WriterVC: WordSearchVCDelegate{
    func didSelectWord(selectedWord: WordSearchModel) {
        self.textEditor.text.append("\(selectedWord.kanji)")
    }
}



extension WriterVC: SaveDialogBoxDelegate{
    func saveBtnPressed(fileName: String?) {
        print(fileName)
        if let fileName, let content = textEditor.text, content.isEmpty == false{
            FileManagerService.shared.saveFile(fileName: fileName, content: content) { error  in
                if let error{
                    self.showErrorAlert(title: "Error", message: error.localizedDescription, positiveBtnTitle: "Ok")
                    
                }
            }
        }
       
    }
    func cancelBtnPressed() {
        
    }
}

extension WriterVC: UIDocumentPickerDelegate{
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if let selectedFileURL = urls.first{
            self.readTheContentOfTextFile(fileURL: selectedFileURL)
        }
    }
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        self.dismiss(animated: true)
    }
}




extension WriterVC: JishoVCDelegate{
    func didPressBackButton() {
        self.selectedWord = nil
        self.tipView?.dismiss()
    }
}


//To hide the tipview when switching the taps
extension WriterVC: UITabBarControllerDelegate{
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        self.tipView?.isHidden = true
        
    }
}
