//
//  CardReviewVC.swift
//  Shirusu
//
//  Created by Sai Balaji on 14/09/24.
//

import UIKit
import Shuffle_iOS

class CardReviewVC: BaseVC {
    
    @IBOutlet weak var navBar: UIView!
    var savedWords = [FlashCardWordModel]()
    private var cardStack = SwipeCardStack()
    private var currentScore = 0
    private var cardFlipCount = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.configureUI()
        
       
    }
    
    
    @IBAction func backBtnPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func configureUI(){
        self.view.addSubview(cardStack)

        cardStack.translatesAutoresizingMaskIntoConstraints = false
        cardStack.topAnchor.constraint(equalTo: navBar.bottomAnchor).isActive = true
        cardStack.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        cardStack.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        cardStack.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        cardStack.delegate = self
        cardStack.dataSource = self
        self.setUpStatusBarColor()
    }
    
    func handleGameOver(){
        let highScore = UserDefaults.standard.integer(forKey: "HIGH_SCORE")
        currentScore = currentScore - cardFlipCount
        if currentScore < 0{
            currentScore = 0
        }
        if currentScore > highScore{
           UserDefaults.standard.setValue(currentScore, forKey: "HIGH_SCORE")
           print(currentScore)
        }
        let scoreCardVC = ScoreCardVC(nibName: "ScoreCardVC", bundle: nil)
        scoreCardVC.modalPresentationStyle = .overCurrentContext
        scoreCardVC.modalTransitionStyle = .coverVertical
        scoreCardVC.currentScore = self.currentScore
        scoreCardVC.delegate = self
        self.present(scoreCardVC, animated: true)
    }


    
}

extension CardReviewVC: SwipeCardStackDelegate, SwipeCardStackDataSource{
    func cardStack(_ cardStack: Shuffle_iOS.SwipeCardStack, cardForIndexAt index: Int) -> Shuffle_iOS.SwipeCard {
        let cardCell = CardViewCell()
        cardCell.delegate = self
        cardCell.updateCard(word: self.savedWords[index])
        return cardCell
    }
    
    func numberOfCards(in cardStack: Shuffle_iOS.SwipeCardStack) -> Int {
        return self.savedWords.count
    }
    
    func cardStack(_ cardStack: SwipeCardStack, didSwipeCardAt index: Int, with direction: SwipeDirection) {
        
        if direction == .left{
            self.currentScore = currentScore - 1
            if self.currentScore < 0{
                self.currentScore = 0
            }
        }
        else if direction == .right{
            self.currentScore = currentScore + 1
        }
    }
    func didSwipeAllCards(_ cardStack: SwipeCardStack) {
        
        
        //Show score card
        self.handleGameOver()
        
    }
    
}


extension CardReviewVC: ScoreCardDelegate{
    func restartBtnPressed() {
        self.currentScore = 0
        self.cardFlipCount = 0
        self.cardStack.reloadData()
    }
}


extension CardReviewVC: CardViewDelegate{
    func didPressCard() {
        self.cardFlipCount = self.cardFlipCount + 1
    }
}
