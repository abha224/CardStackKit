//
//  ViewController.swift
//  SampleCardSwiperApp
//
//  Created by Abha on 17/09/23.
//

import UIKit

class SampleViewController: UIViewController, CardStackDelegate, CardStackDatasource {

    @IBOutlet private var cardStack: CardStack!

    override func viewDidLoad() {
        super.viewDidLoad()

        cardStack.delegate = self
        cardStack.datasource = self
        cardStack.isStackingEnabled = true
        cardStack.stackedCardsCount = 3
        cardStack.roundCorners([.topLeft, .topRight], radius: 20)
        // register cardcell for storyboard use
        cardStack.register(nib: UINib(nibName: "SampleCell", bundle: nil), forCellWithReuseIdentifier: "SampleCell")
    }

    @objc func nextScroll(_ sender: UITapGestureRecognizer) {
        if let currentIndex = cardStack.focussedCardIndex {
            _ = cardStack.scrollToCard(at: currentIndex + 1, animated: true)
        }
    }

    func cardForItemAt(cardStackView: CardStackView, cardForItemAt index: Int) -> CardCell {
        if let cardCell = cardStackView.dequeueReusableCell(withReuseIdentifier: "SampleCell", for: index) as? SampleCardCell {
            cardCell.bottomView.isUserInteractionEnabled = true
            cardCell.bottomView.roundCorners([.topLeft, .topRight], radius: 20)
            cardCell.bottomView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(self.nextScroll(_:))))
            cardCell.topView.backgroundColor = cardCell.setBackgroundColor()
            cardCell.topView.isHidden = true
            return cardCell
        }
        return CardCell()
    }

    func numberOfCards(cardStackView: CardStackView) -> Int {
        return 3
    }
    
    func didEndScroll(cardStackView: CardStackView) {
        if let currentIndex = cardStack.focussedCardIndex {
            if let cell = cardStackView.cellForItem(at: IndexPath.init(item: currentIndex - 1, section: 0)) as? SampleCardCell {
                cell.backgroundColor = cell.topView.backgroundColor
                cell.topView.isHidden = false
                cell.bottomView.roundCorners([.topLeft, .topRight], radius: 20)
            }
        }
    }

    func didTapCard(cardStackView: CardStackView, index: Int) {
        if cardStack.focussedCardIndex != nil {
            _ = cardStack.scrollToCard(at: index, animated: true)
            if let cell = cardStackView.cellForItem(at: IndexPath.init(item: index, section: 0)) as? SampleCardCell {
                cell.topView.isHidden = true
                cell.bottomView.roundCorners([.topLeft, .topRight], radius: 20)
                cell.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            }
        }
    }
}

extension UIView {
    func roundCorners(_ corners:UIRectCorner, radius: CGFloat) {
    let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
    let mask = CAShapeLayer()
    mask.path = path.cgPath
    self.layer.mask = mask
  }
}
