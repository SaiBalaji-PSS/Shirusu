//
//  CardViewCell.swift
//  Shirusu
//
//  Created by Sai Balaji on 14/09/24.
//

import Foundation
import Shuffle_iOS
import UIKit

protocol CardViewDelegate: AnyObject{
    func didPressCard()
}
class CardViewCell: SwipeCard{
    private var topLabel = UILabel()
    private var middleLabel = UILabel()
    private var bottomLabel = UILabel()
    private var isFlipped = false
    weak var delegate: CardViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setupGestureRecognizer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureUI()
        setupGestureRecognizer()
    }
    func configureUI(){
        topLabel = self.createLabels(text: "TOP TEXT TOP TEXT TOP TEXT TOP TEXT")
        topLabel.font = UIFont.systemFont(ofSize: 45)
        middleLabel = self.createLabels(text: "MIDDLE LABEL")
        middleLabel.font = UIFont.boldSystemFont(ofSize: 60)
        bottomLabel = self.createLabels(text: "BOTTOM TEXT")
        bottomLabel.font = UIFont.systemFont(ofSize: 25)

        let stackView = UIStackView(arrangedSubviews: [topLabel,middleLabel,bottomLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leftAnchor.constraint(equalTo: leftAnchor,constant: 8).isActive = true
        stackView.rightAnchor.constraint(equalTo: rightAnchor,constant: -8).isActive = true
        stackView.topAnchor.constraint(equalTo: topAnchor,constant: 20).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        self.backgroundColor = UIColor.white
        self.layer.borderColor = UIColor.darkGray.cgColor
        self.layer.borderWidth = 2
    }
    
    func setupGestureRecognizer(){
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cardTapped)))
    }
    
    @objc func cardTapped(){
        self.isFlipped.toggle()
        let transitionStyle: UIView.AnimationOptions = isFlipped ? .transitionFlipFromLeft : .transitionFlipFromRight
        UIView.transition(with: self, duration: 0.5,options: transitionStyle) {
            if self.isFlipped{
             
                
                self.topLabel.alpha = 1
                self.bottomLabel.alpha = 1
                self.middleLabel.alpha = 1
            }
            else{
                self.topLabel.alpha = 0
                self.bottomLabel.alpha = 0
                self.middleLabel.alpha = 1
                if self.middleLabel.isHidden{
                    self.topLabel.alpha = 1
                }
            }
        }
        self.delegate?.didPressCard()
    }
    
    func updateCard(word: FlashCardWordModel,fontSize: Int){
        self.topLabel.font = UIFont.systemFont(ofSize: CGFloat(fontSize), weight: .medium)
        self.middleLabel.font = UIFont.systemFont(ofSize: CGFloat(fontSize), weight: .bold)
        //self.bottomLabel.font = UIFont.systemFont(ofSize: CGFloat(fontSize), weight: .medium)
        self.topLabel.text = word.kana
        
        self.middleLabel.text = word.kanji
        if word.kanji.isEmpty{
            self.middleLabel.isHidden = true
            self.topLabel.alpha = 1
        }
        else{
            self.middleLabel.isHidden = false
            self.topLabel.alpha = 0
        }
       
        
        self.bottomLabel.text = word.defination + "\n" + word.partsOfSpeech
        self.bottomLabel.alpha = 0
    }
    
    func createLabels(text: String) -> UILabel{
        let lbl = UILabel()
        lbl.text = text
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        return lbl
    }
}
