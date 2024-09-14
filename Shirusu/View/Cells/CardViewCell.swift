//
//  CardViewCell.swift
//  Shirusu
//
//  Created by Sai Balaji on 14/09/24.
//

import Foundation
import Shuffle_iOS
import UIKit

class CardViewCell: SwipeCard{
    private var topLabel = UILabel()
    private var middleLabel = UILabel()
    private var bottomLabel = UILabel()
    private var isFlipped = false
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
        middleLabel = self.createLabels(text: "MIDDLE LABEL")
        bottomLabel = self.createLabels(text: "BOTTOM TEXT")
        let stackView = UIStackView(arrangedSubviews: [topLabel,middleLabel,bottomLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
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
                self.topLabel.alpha = 0
                self.bottomLabel.alpha = 0
                self.middleLabel.alpha = 1
            }
            else{
                self.topLabel.alpha = 1
                self.bottomLabel.alpha = 1
                self.middleLabel.alpha = 1
            }
        }
    }
    
    
    func createLabels(text: String) -> UILabel{
        let lbl = UILabel()
        lbl.text = text
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        return lbl
    }
}
