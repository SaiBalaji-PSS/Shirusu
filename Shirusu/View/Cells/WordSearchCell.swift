//
//  WordSearchCell.swift
//  Shirusu
//
//  Created by Sai Balaji on 07/09/24.
//

import UIKit

protocol WordCellDelegate: AnyObject{
    func tickBtnPressed(isCellSelected: Bool,at indexPath: IndexPath)
}

class WordSearchCell: UITableViewCell {
    weak var delegate: WordCellDelegate?
    @IBOutlet weak var topLbl: UILabel!
    @IBOutlet weak var bottomLbl: UILabel!
    @IBOutlet weak var tickImageView: UIImageView!
    private var isCellSelected = false
    var index = IndexPath()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.tickImageView.isUserInteractionEnabled = true
        self.tickImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tickImageTapped)))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCell(word: WordSearchModel){
        self.topLbl.text = "Kanji: \(word.kanji)  Kana: \(word.kana)"
        self.bottomLbl.text = "Meaning: \(word.meaning) \n Parts Of Speech: \(word.partOfSpeech)"
        
        
    }
    
    func updateCellSavedWordsList(word: FlashCardWordModel){
        self.topLbl.text = "Kanji: \(word.kanji)  Kana: \(word.kana)"
        self.bottomLbl.text = "Meaning: \(word.defination) \n Parts Of Speech: \(word.partsOfSpeech)"
        self.isCellSelected = word.isSelected
        self.tickImageView.image = isCellSelected ? UIImage(systemName: "checkmark.circle") : UIImage(systemName: "circle")
    }
    
    @objc func tickImageTapped(){
        if isCellSelected{
            isCellSelected = false
        }
        else{
           isCellSelected = true
        }
    
        self.delegate?.tickBtnPressed(isCellSelected: self.isCellSelected,at: index)
    }
}
