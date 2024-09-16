//
//  CardReviewVC.swift
//  Shirusu
//
//  Created by Sai Balaji on 14/09/24.
//

import UIKit
import Shuffle_iOS

class CardReviewVC: UIViewController {
    
    @IBOutlet weak var navBar: UIView!
    private var savedWords = [FlashCardWordModel]()
    private var cardStack = SwipeCardStack()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.addSubview(cardStack)
        self.navBar.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        cardStack.translatesAutoresizingMaskIntoConstraints = false
        cardStack.topAnchor.constraint(equalTo: navBar.bottomAnchor).isActive = true
        cardStack.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        cardStack.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        cardStack.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        cardStack.delegate = self
        cardStack.dataSource = self
        self.getSavedWords()
    }
    
    
    
    func getSavedWords(){
        if let words = RealmManager.shared.readDataFromRealm(modelType: FlashCardWordModel.self){
            self.savedWords = Array(words)
            DispatchQueue.main.async {
                self.cardStack.reloadData()
            }
        }
    
    }


    
}

extension CardReviewVC: SwipeCardStackDelegate, SwipeCardStackDataSource{
    func cardStack(_ cardStack: Shuffle_iOS.SwipeCardStack, cardForIndexAt index: Int) -> Shuffle_iOS.SwipeCard {
        let cardCell = CardViewCell()
        cardCell.updateCard(word: self.savedWords[index])
        return cardCell
    }
    
    func numberOfCards(in cardStack: Shuffle_iOS.SwipeCardStack) -> Int {
        return self.savedWords.count
    }
    
    
}
