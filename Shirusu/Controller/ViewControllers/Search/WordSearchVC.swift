//
//  WordSearchVC.swift
//  Shirusu
//
//  Created by Sai Balaji on 07/09/24.
//

import UIKit
import DropDown

protocol WordSearchVCDelegate: AnyObject{
    func didSelectWord(selectedWord: WordSearchModel)
    
}
class WordSearchVC: BaseVC {
    weak var delegate: WordSearchVCDelegate?
    let dropDown = DropDown()
    @IBOutlet weak var customSearchBar: CustomSearchTextField!
    
   
    @IBOutlet weak var loaderImageView: UIImageView!
    @IBOutlet weak var dropDownView: UIView!
    @IBOutlet weak var dropDownLbl: UILabel!

    @IBOutlet weak var tableView: UITableView!
    private var wordList = [WordSearchModel]()
    private var wordTypes = ["Noun","Godan","Ichidan","Adjective","Pronoun"]
    private var selectedWordType: String = "Noun"
    
    override func loadView() {
        super.loadView()
        self.setUpStatusBarColor()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.configureUI()
        
    }
    
    func configureUI(){
//        self.searchBar.delegate = self
        self.loaderImageView.isHidden = true
        self.customSearchBar.searchTextField.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.customSearchBar.delegate = self
        self.tableView.register(UINib(nibName: "WordSearchCell", bundle: nil),forCellReuseIdentifier: "WordSearchCell")
        self.dropDownLbl.text = "Noun"
        dropDown.anchorView = dropDownView
        dropDown.dataSource = self.wordTypes
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.dropDownLbl.text = item
            self.selectedWordType = item
            self.tableView.isHidden = true
            self.loaderImageView.isHidden = false
            if var searchText = customSearchBar.searchTextField.text{
                
                //If the word is a japnaese word verb then there is no need to add "to"
                //If the word is an english word verb then add "to"
                if searchText.containsKanji() == false || searchText.containsHiragana() == false{
                    if self.selectedWordType.contains("Godan") || self.selectedWordType.contains("Ichidan") || self.selectedWordType.contains("Irregular"){
                        searchText = "to" + " " + searchText
                    }
                }
                self.getWordMeaningWithPartsOfSpeech(searchTerm: searchText, partsOfSpeech: self.selectedWordType.lowercased())
            }
       
          }
        
    }
    
    
    
    
    func getWordMeaningWithPartsOfSpeech(searchTerm: String,partsOfSpeech: String){
     
        DatabaseService.shared.getWordWithPartsOfSpeech(searchTerm: searchTerm, partsOfSpeech: partsOfSpeech) { result , error  in
            DispatchQueue.main.async {
                if let error{
                    print(error)
                    self.showErrorAlert(title: "Error", message: error.localizedDescription, positiveBtnTitle: "Ok")
                }
                if let result{
                    self.wordList = result
                    self.tableView.reloadData()
                }
                self.loaderImageView.isHidden = true
                self.tableView.isHidden = false
            }
            
        }
    }

    
   
    @IBAction func backBtnPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    @IBAction func dropDownBtnPressed(_ sender: Any) {
        self.dropDown.show()
    }
    
}

extension WordSearchVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.wordList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "WordSearchCell", for: indexPath) as? WordSearchCell{
            cell.updateCell(word: self.wordList[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.didSelectWord(selectedWord: self.wordList[indexPath.row])
        self.dismiss(animated: true)
    }
}
extension WordSearchVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if var word = textField.text, word.isEmpty == false{
            if self.selectedWordType.contains("Godan") || self.selectedWordType.contains("Ichidan") || self.selectedWordType.contains("Irregular"){
                word = "to" + " " + word
            }
            self.loaderImageView.isHidden = false
            self.getWordMeaningWithPartsOfSpeech(searchTerm: word, partsOfSpeech: self.selectedWordType.lowercased())
        }
        self.view.endEditing(true)
       
        return true
    }
    
}

extension WordSearchVC: CustomSearchTextFieldDelegate{
    func didPressSearchButton(text: String?) {
        if var searchText = text, searchText.isEmpty == false{
            self.loaderImageView.isHidden = false
            self.tableView.isHidden = true
            //self.getWordMeaning(searchTerm: searchText.trimmingCharacters(in: .whitespacesAndNewlines))
            if self.selectedWordType.contains("Godan") || self.selectedWordType.contains("Ichidan") || self.selectedWordType.contains("Irregular"){
                searchText = "to" + " " + searchText
            }
            self.loaderImageView.isHidden = false
            self.getWordMeaningWithPartsOfSpeech(searchTerm: searchText, partsOfSpeech: self.selectedWordType.lowercased())
            self.view.endEditing(true)
        }
    }
    
    
}
