//
//  ScoreCardVC.swift
//  Shirusu
//
//  Created by Sai Balaji on 17/09/24.
//

import UIKit

protocol ScoreCardDelegate: AnyObject{
    func restartBtnPressed()
}
class ScoreCardVC: UIViewController {
    weak var delegate: ScoreCardDelegate?
    @IBOutlet weak var scoreLbl: UILabel!
    @IBOutlet weak var highScoreLbl: UILabel!
    var currentScore = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.highScoreLbl.text = "High Score: \(UserDefaults.standard.integer(forKey: "HIGH_SCORE"))"
        self.scoreLbl.text = "Score: \(currentScore)"
        
    }

    
    
    @IBAction func restartBtnPressed(_ sender: Any) {
        self.dismiss(animated: true)
        self.delegate?.restartBtnPressed()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
