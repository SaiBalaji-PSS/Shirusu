//
//  FlashCardVC.swift
//  Shirusu
//
//  Created by Sai Balaji on 10/09/24.
//

import UIKit

class FlashCardVC: BaseVC {
    @IBOutlet weak var tableView: UITableView!
    private var savedWords = [FlashCardWordModel]()
    
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
            self.tableView.reloadData()
        }
        
        
    }
    
    
    @IBAction func selectWordsBtnPressed(_ sender: Any) {
    }
    @IBAction func reviewButtonPressed(_ sender: Any) {
    }
    
}

extension FlashCardVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.savedWords.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "WordSearchCell", for: indexPath) as? WordSearchCell{
            cell.updateCell(word: WordSearchModel(kanji: self.savedWords[indexPath.row].kanji, kana: self.savedWords[indexPath.row].kana, meaning: self.savedWords[indexPath.row].defination, partOfSpeech: self.savedWords[indexPath.row].partsOfSpeech))
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
