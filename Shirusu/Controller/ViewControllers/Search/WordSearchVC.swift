//
//  WordSearchVC.swift
//  Shirusu
//
//  Created by Sai Balaji on 07/09/24.
//

import UIKit

class WordSearchVC: UIViewController {
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var tableView: UITableView!
    private var wordList = [WordSearchModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.configureUI()
        
    }
    
    func configureUI(){
        self.searchBar.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CELL")
    }
    
    func getWordMeaning(searchTerm: String){
        DatabaseService.shared.getWordList(searchTerm: searchTerm) { result , error  in
            DispatchQueue.main.async {
                if let error{
                    print(error)
                }
                if let result{
                    self.wordList = result
                    self.tableView.reloadData()
                    
                }
            }
           
        }
    }

    

}

extension WordSearchVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.wordList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL", for: indexPath)
        cell.textLabel?.text = "\(self.wordList[indexPath.row].kanji)"
        return cell
    }
}
extension WordSearchVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let word = textField.text, word.isEmpty == false{
            self.getWordMeaning(searchTerm: word)
        }
       
        return true
    }
    
}
