//
//  SheetsVC.swift
//  Shirusu
//
//  Created by Sai Balaji on 31/08/24.
//

import UIKit

class SheetsVC: BaseVC {

    @IBOutlet weak var tableView: UITableView!
    private var fileList = [SavedFileModel]()
    
    override func loadView() {
        super.loadView()
        self.setUpStatusBarColor()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.configureUI()
        
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getAllSavedFiles()
    }

    
    func configureUI(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CELL")
    }
    func getAllSavedFiles(){
        FileManagerService.shared.readAllSavedFiles { files , error  in
            if let error{
                print(error)
            }
            if let files{
                self.fileList = files.map({ url  in
                    return SavedFileModel(fileName: url.lastPathComponent, filePath: url)
                })
                self.tableView.reloadData()
            }
        }
    }
    
}


extension SheetsVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fileList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL", for: indexPath)
        cell.textLabel?.text = self.fileList[indexPath.row].fileName
        return cell
    }
}
