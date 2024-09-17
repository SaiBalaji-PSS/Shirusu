//
//  FlashCardVC.swift
//  Shirusu
//
//  Created by Sai Balaji on 10/09/24.
//

import UIKit

class SavedWordsListVC: BaseVC {
    @IBOutlet weak var tableView: UITableView!
    private var showTickMark = false
    private var savedWords = [FlashCardWordModel]()
    private var selectedWordList = [FlashCardWordModel]()
    override  func loadView() {
        super.loadView()
        self.setUpStatusBarColor()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getAllSavedWords()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.configureUI()
       
    }


    
    func configureUI(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "WordSearchCell", bundle: nil), forCellReuseIdentifier: "WordSearchCell")
    }
    func getAllSavedWords(){
        
        if let savedWords = RealmManager.shared.readDataFromRealm(modelType: FlashCardWordModel.self){
            self.savedWords = Array(savedWords)
            self.selectedWordList.removeAll()
            self.tableView.reloadData()
        }
        
        
    }
    
    
    @IBAction func selectWordsBtnPressed(_ sender: Any) {
        self.showTickMark.toggle()
        self.tableView.reloadData()
    }
    @IBAction func reviewButtonPressed(_ sender: Any) {
        let vc = CardReviewVC(nibName: "CardReviewVC", bundle: nil)
        vc.modalPresentationStyle = .fullScreen
        vc.savedWords = self.selectedWordList.isEmpty ? self.savedWords : self.selectedWordList
        self.present(vc, animated: true)
        //print(self.selectedWordList.count)
    }
    
}

extension SavedWordsListVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.savedWords.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "WordSearchCell", for: indexPath) as? WordSearchCell{
//            cell.updateCell(word: WordSearchModel(kanji: self.savedWords[indexPath.row].kanji, kana: self.savedWords[indexPath.row].kana, meaning: self.savedWords[indexPath.row].defination, partOfSpeech: self.savedWords[indexPath.row].partsOfSpeech))
            cell.updateCellSavedWordsList(word: self.savedWords[indexPath.row])
            cell.delegate = self
            cell.index = indexPath
            cell.tickImageView.isHidden = !self.showTickMark
            return cell
        }
        return UITableViewCell()
        
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            RealmManager.shared.deleteDataFromRealm(object: self.savedWords[indexPath.row]) { error  in
                if let error{
                    self.showErrorAlert(title: "Error", message: error.localizedDescription, positiveBtnTitle: "OK")
                }
                else{
                    self.getAllSavedWords()
                }
            }
        }
    }
}


extension SavedWordsListVC: WordCellDelegate{
    func tickBtnPressed(isCellSelected: Bool, at indexPath: IndexPath) {
        self.savedWords[indexPath.row].isSelected = isCellSelected
     
        if isCellSelected{
            self.selectedWordList.append(self.savedWords[indexPath.row])
        }
        else{
            if let index = self.selectedWordList.firstIndex(of: self.savedWords[indexPath.row]){
                self.selectedWordList.remove(at: index)
            }
        }
        self.tableView.reloadData()
      
    }
}
