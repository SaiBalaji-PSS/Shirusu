//
//  WordSearchCell.swift
//  Shirusu
//
//  Created by Sai Balaji on 07/09/24.
//

import UIKit

class WordSearchCell: UITableViewCell {

    @IBOutlet weak var topLbl: UILabel!
    @IBOutlet weak var bottomLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCell(word: WordSearchModel){
        self.topLbl.text = "Kanji: \(word.kanji)  Kana: \(word.kana)"
        self.bottomLbl.text = "Meaning: \(word.meaning) \n Parts Of Speech: \(word.partOfSpeech)"
    }
    
}
