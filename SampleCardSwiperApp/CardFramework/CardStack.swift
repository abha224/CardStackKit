//
//  CardStack.swift
//
//  Created by Abha on 17/09/23.
//

import Foundation
import UIKit


/**
 The StackCard is a subclass of `UIView` that has a `CardStackView` embedded.
 To use this, you need to implement the `StackCardDatasource`.
 If you want to handle actions like cards being swiped away, implement the `StackCardDelegate`.
 */
public class CardStack: UIView {

    public weak var delegate: CardStackDelegate?
    public weak var datasource: CardStackDatasource?
    
    /// The collectionView where all the magic happens.
    public var cardStackView: CardStackView!
    /// The currently focussed card index.
    public var focussedCardIndex: Int? {
        let center = self.convert(self.cardStackView.center, to: self.cardStackView)
        if let indexPath = self.cardStackView.indexPathForItem(at: center) {
            return indexPath.row
        }
        return nil
    }
    
    /// We use this tapGestureRecognizer for the tap recognizer.
    fileprivate var tapGestureRecognizer: UITapGestureRecognizer!
    /// Stores a `CGRect` with the area that is swipeable to the user.
    fileprivate var swipeAbleArea: CGRect?
    /// The `CardCell` that the user can (and is) moving.
    fileprivate var swipedCard: CardCell!

    /// The inset (spacing) at the top for the cards. Default is 160.
    @IBInspectable public var topInset: CGFloat = 160 {
        didSet {
            setCardSwiperInsets()
        }
    }
    
    /// The inset (spacing) at each side of the cards. Default is 0.
    @IBInspectable public var sideInset: CGFloat = 0 {
        didSet {
            setCardSwiperInsets()
        }
    }
    
    /// Sets how much of the next card should be visible. Default is 0.
    @IBInspectable public var visibleNextCardHeight: CGFloat = 0 {
        didSet {
            setCardSwiperInsets()
        }
    }
    
    /// Vertical spacing between the focussed card and the bottom (next) card. Default is 40.
    @IBInspectable public var cardSpacing: CGFloat = 0 {
        willSet {
            flowLayout.minimumLineSpacing = newValue
        }
        didSet {
            setCardSwiperInsets()
        }
    }
    
    /// The transform animation that is shown on the top card when scrolling through the cards. Default is 0.05.
    @IBInspectable public var firstItemTransform: CGFloat = 0.05 {
        willSet {
            flowLayout.firstItemTransform = newValue
        }
    }
    
    /// Allows you to enable/disable the stacking effect. Default is `true`.
    @IBInspectable public var isStackingEnabled: Bool = true {
        willSet {
            flowLayout.isStackingEnabled = newValue
        }
    }
    
    /// Allows you to set the view to Stack at the Top or at the Bottom. Default is `true`.
    @IBInspectable public var isStackOnBottom: Bool = true {
        willSet {
            flowLayout.isStackOnBottom = newValue
        }
    }
    
    /// Sets how many cards of the stack are visible in the background. Default is 1.
    @IBInspectable public var stackedCardsCount: Int = 1 {
        willSet {
            flowLayout.stackedCardsCount = newValue
        }
    }

    /// The flowlayout used in the collectionView.
    fileprivate lazy var flowLayout: CardFlowLayout = {
        let flowLayout = CardFlowLayout()
        flowLayout.firstItemTransform = firstItemTransform
        flowLayout.minimumLineSpacing = cardSpacing
        flowLayout.isPagingEnabled = true
        return flowLayout
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        self.cardStackView.delegate = self
    }

    private func commonInit() {
        setupCardStackView()
        setupConstraints()
        setCardSwiperInsets()
        setupGestureRecognizer()
    }

}

extension CardStack: UIGestureRecognizerDelegate {

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    fileprivate func setupGestureRecognizer() {
        tapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(handleTap))
        tapGestureRecognizer.delegate = self
        cardStackView.addGestureRecognizer(tapGestureRecognizer)
        cardStackView.panGestureRecognizer.maximumNumberOfTouches = 1
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeAction(swipe:)))
        leftSwipe.direction = UISwipeGestureRecognizer.Direction.left
        cardStackView.addGestureRecognizer(leftSwipe)
        
    }

    @objc fileprivate func swipeAction(swipe: UISwipeGestureRecognizer) {
        swipe.cancelsTouchesInView = false
    }
    
    @objc fileprivate func handleTap(sender: UITapGestureRecognizer) {
        if let delegate = delegate {
            if let wasTapped = delegate.didTapCard {
                /// The taplocation relative to the collectionView.
                let locationInCollectionView = sender.location(in: cardStackView)

                if let tappedCardIndex = cardStackView.indexPathForItem(at: locationInCollectionView) {
                    wasTapped(cardStackView, tappedCardIndex.row)
                }
            }
        }
    }
}

extension CardStack: UICollectionViewDelegate, UICollectionViewDataSource {

    public func scrollToCard(at index: Int, animated: Bool) -> Bool {
        guard
            let cellHeight = flowLayout.cellHeight,
            index >= 0,
            swipedCard == nil,
            index < cardStackView.numberOfItems(inSection: 0)
            else { return false }
        let y = CGFloat(index) * (cellHeight + flowLayout.minimumLineSpacing) - topInset
        let point = CGPoint(x: cardStackView.contentOffset.x, y: y)
        cardStackView.setContentOffset(point, animated: animated)
        return true
    }

    public func register(nib: UINib?, forCellWithReuseIdentifier identifier: String) {
        self.cardStackView.register(nib, forCellWithReuseIdentifier: identifier)
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource?.numberOfCards(cardStackView: cardStackView) ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // check card number
        if let card = datasource?.cardForItemAt(cardStackView: cardStackView, cardForItemAt: indexPath.row) {
            return card
        }
        return CardCell()
    }

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            delegate?.didEndScroll?(cardStackView: cardStackView)
        }
    }

    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        delegate?.didEndScroll?(cardStackView: cardStackView)
    }
}

// Setup for CardCell
extension CardStack: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = calculateItemSize(for: indexPath.row)

        // set cellHeight in the custom flowlayout, we use this for paging calculations.
        flowLayout.cellHeight = itemSize.height

        if swipeAbleArea == nil {
            // Calculate and set the swipeAbleArea. We use this to determine wheter the cell can be swiped to the sides or not.
            let swipeAbleAreaOriginY = collectionView.frame.origin.y + collectionView.contentInset.top
            self.swipeAbleArea = CGRect(x: 0, y: swipeAbleAreaOriginY, width: self.frame.width, height: itemSize.height)
        }
        return itemSize
    }

    fileprivate func calculateItemSize(for index: Int) -> CGSize {
        let cellWidth: CGFloat!
        let cellHeight: CGFloat!
        let xInsets = sideInset * 2
        let yInsets = cardSpacing + visibleNextCardHeight + topInset

        // get size from delegate if the sizeForItem function is called.
        if let customSize = delegate?.sizeForItem?(cardStackView: cardStackView, index: index) {
            // set custom sizes and make sure sizes are not negative, if they are, don't subtract the insets.
            cellWidth = customSize.width - (customSize.width - xInsets > 0 ? xInsets : 0)
            cellHeight = customSize.height - (customSize.height - yInsets > 0 ? yInsets : 0)
        } else {
            cellWidth = cardStackView.frame.size.width - xInsets
            cellHeight = cardStackView.frame.size.height - yInsets
        }
        return CGSize(width: cellWidth, height: cellHeight)
    }

    fileprivate func setupCardStackView() {
        cardStackView = CardStackView(frame: self.frame, collectionViewLayout: flowLayout)
        cardStackView.decelerationRate = UIScrollView.DecelerationRate.fast
        cardStackView.backgroundColor = UIColor.clear
        cardStackView.showsVerticalScrollIndicator = false
        cardStackView.dataSource = self
        self.addSubview(cardStackView)
    }

    fileprivate func setupConstraints() {
        cardStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.cardStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.cardStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.cardStackView.topAnchor.constraint(equalTo: self.topAnchor),
            self.cardStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }

    fileprivate func setCardSwiperInsets() {
        let bottomInset = visibleNextCardHeight + flowLayout.minimumLineSpacing
        cardStackView.contentInset = UIEdgeInsets(top: topInset, left: sideInset, bottom: bottomInset, right: sideInset)
    }
}

