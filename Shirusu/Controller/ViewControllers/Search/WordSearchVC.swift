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
class WordSearchVC: UIViewController {
    weak var delegate: WordSearchVCDelegate?
    let dropDown = DropDown()
    @IBOutlet weak var customSearchBar: CustomSearchTextField!
    
   
    @IBOutlet weak var dropDownView: UIView!
    @IBOutlet weak var dropDownLbl: UILabel!
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var tableView: UITableView!
    private var wordList = [WordSearchModel]()
    private var wordTypes = ["Noun","Godan","Ichidan","Adjective","Pronoun","Auxillary verb"]
    private var selectedWordType: String = "Noun"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.configureUI()
        
    }
    
    func configureUI(){
//        self.searchBar.delegate = self
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
          }
        
    }
    
    
    
    
//    func getWordMeaning(searchTerm: String){
//        DatabaseService.shared.getWordList(searchTerm: searchTerm) { result , error  in
//            DispatchQueue.main.async {
//                if let error{
//                    print(error)
//                }
//                if let result{
//                    self.wordList = result
//                    self.tableView.reloadData()
//                    
//                }
//            }
//           
//        }
//    }
    
    func getWordMeaningWithPartsOfSpeech(searchTerm: String,partsOfSpeech: String){
        DatabaseService.shared.getWordWithPartsOfSpeech(searchTerm: searchTerm, partsOfSpeech: partsOfSpeech) { result , error  in
            if let error{
                print(error)
            }
            if let result{
                self.wordList = result
                self.tableView.reloadData()
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
        if let word = textField.text, word.isEmpty == false{
            self.getWordMeaningWithPartsOfSpeech(searchTerm: word.trimmingCharacters(in: .whitespacesAndNewlines), partsOfSpeech: self.selectedWordType.lowercased())
        }
       
        return true
    }
    
}

extension WordSearchVC: CustomSearchTextFieldDelegate{
    func didPressSearchButton(text: String?) {
        if var searchText = text, searchText.isEmpty == false{
            //self.getWordMeaning(searchTerm: searchText.trimmingCharacters(in: .whitespacesAndNewlines))
            if self.selectedWordType.contains("Godan") || self.selectedWordType.contains("Ichidan"){
                searchText = "to" + " " + searchText
            }
            self.getWordMeaningWithPartsOfSpeech(searchTerm: searchText, partsOfSpeech: self.selectedWordType.lowercased())
            self.view.endEditing(true)
        }
    }
    
    
}
