//
//  ViewController.swift
//  SampleCardSwiperApp
//
//  Created by Abha on 17/09/23.
//

import UIKit

class SampleViewController: UIViewController, CardSwiperDelegate, StackCardDatasource {

    @IBOutlet private var cardSwiper: StackCard!

    override func viewDidLoad() {
        super.viewDidLoad()

        cardSwiper.delegate = self
        cardSwiper.datasource = self
        cardSwiper.isSideSwipingEnabled = true
        cardSwiper.isStackingEnabled = true
        cardSwiper.stackedCardsCount = 3
        cardSwiper.roundCorners([.topLeft, .topRight], radius: 20)
        // register cardcell for storyboard use
        cardSwiper.register(nib: UINib(nibName: "SampleCell", bundle: nil), forCellWithReuseIdentifier: "SampleCell")
    }

    @objc func nextScroll(_ sender: UITapGestureRecognizer) {
        if let currentIndex = cardSwiper.focussedCardIndex {
            _ = cardSwiper.scrollToCard(at: currentIndex + 1, animated: true)
        }
    }

    func cardForItemAt(stackCardView: StackCardView, cardForItemAt index: Int) -> CardCell {

        if let cardCell = stackCardView.dequeueReusableCell(withReuseIdentifier: "SampleCell", for: index) as? SampleCardCell {
            cardCell.bottomView.isUserInteractionEnabled = true
            cardCell.bottomView.roundCorners([.topLeft, .topRight], radius: 20)
            cardCell.bottomView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(self.nextScroll(_:))))
            cardCell.topView.backgroundColor = cardCell.setBackgroundColor()
            cardCell.topView.isHidden = true
            return cardCell
        }
        return CardCell()
    }

    func numberOfCards(stackCardView: StackCardView) -> Int {
        return 3
    }
    
    func didEndScroll(stackCardView: StackCardView) {
        //used
        if let currentIndex = cardSwiper.focussedCardIndex {
            if let cell = stackCardView.cellForItem(at: IndexPath.init(item: currentIndex - 1, section: 0)) as? SampleCardCell {
                cell.backgroundColor = cell.topView.backgroundColor
                cell.topView.isHidden = false
                cell.bottomView.roundCorners([.topLeft, .topRight], radius: 20)
            }
        }
        
//        print(cardSwiper.gesture)
    }

    func didTapCard(stackCardView: StackCardView, index: Int) {
        // used internal
        if cardSwiper.focussedCardIndex != nil {
            _ = cardSwiper.scrollToCard(at: index, animated: true)
            if let cell = stackCardView.cellForItem(at: IndexPath.init(item: index, section: 0)) as? SampleCardCell {
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
