//
//  CardSwiper.swift
//  cardStack
//
//  Created by Abha on 17/09/23.
//

import Foundation
import UIKit


/**
 The StackCard is a subclass of `UIView` that has a `CardSwiperView` embedded.
 To use this, you need to implement the `StackCardDatasource`.
 If you want to handle actions like cards being swiped away, implement the `StackCardDelegate`.
 */
public class CardSwiper: UIView {

    public weak var delegate: CardSwiperDelegate?
    public weak var datasource: CardSwiperDatasource?
    
    /// The collectionView where all the magic happens.
    public var cardSwiperView: CardSwiperView!
    /// Indicates if side swiping on cards is enabled. Default is `true`.
    public var isSideSwipingEnabled: Bool = true
    /// The currently focussed card index.
    public var focussedCardIndex: Int? {
        let center = self.convert(self.cardSwiperView.center, to: self.cardSwiperView)
        if let indexPath = self.cardSwiperView.indexPathForItem(at: center) {
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
        self.cardSwiperView.delegate = self
    }

    private func commonInit() {
        setupCardSwiperView()
        setupConstraints()
        setCardSwiperInsets()
        setupGestureRecognizer()
    }

}

extension CardSwiper: UIGestureRecognizerDelegate {

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    fileprivate func setupGestureRecognizer() {
        tapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(handleTap))
        tapGestureRecognizer.delegate = self
        cardSwiperView.addGestureRecognizer(tapGestureRecognizer)
        cardSwiperView.panGestureRecognizer.maximumNumberOfTouches = 1
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeAction(swipe:)))
        leftSwipe.direction = UISwipeGestureRecognizer.Direction.left
        cardSwiperView.addGestureRecognizer(leftSwipe)
        
    }

    @objc fileprivate func swipeAction(swipe: UISwipeGestureRecognizer) {
        swipe.cancelsTouchesInView = false
    }
    
    @objc fileprivate func handleTap(sender: UITapGestureRecognizer) {
        if let delegate = delegate {
            if let wasTapped = delegate.didTapCard {
                /// The taplocation relative to the collectionView.
                let locationInCollectionView = sender.location(in: cardSwiperView)

                if let tappedCardIndex = cardSwiperView.indexPathForItem(at: locationInCollectionView) {
                    wasTapped(cardSwiperView, tappedCardIndex.row)
                }
            }
        }
    }
}

extension CardSwiper: UICollectionViewDelegate, UICollectionViewDataSource {

    public func scrollToCard(at index: Int, animated: Bool) -> Bool {
        guard
            let cellHeight = flowLayout.cellHeight,
            index >= 0,
            swipedCard == nil,
            index < cardSwiperView.numberOfItems(inSection: 0)
            else { return false }
        let y = CGFloat(index) * (cellHeight + flowLayout.minimumLineSpacing) - topInset
        let point = CGPoint(x: cardSwiperView.contentOffset.x, y: y)
        cardSwiperView.setContentOffset(point, animated: animated)
        return true
    }

    public func register(nib: UINib?, forCellWithReuseIdentifier identifier: String) {
        self.cardSwiperView.register(nib, forCellWithReuseIdentifier: identifier)
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource?.numberOfCards(cardSwiperView: cardSwiperView) ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // check card number
        if let card = datasource?.cardForItemAt(cardSwiperView: cardSwiperView, cardForItemAt: indexPath.row) {
            return card
        }
        return CardCell()
    }

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            delegate?.didEndScroll?(cardSwiperView: cardSwiperView)
        }
    }

    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        delegate?.didEndScroll?(cardSwiperView: cardSwiperView)
    }
}

// Setup for CardCell
extension CardSwiper: UICollectionViewDelegateFlowLayout {
    
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
        if let customSize = delegate?.sizeForItem?(cardSwiperView: cardSwiperView, index: index) {
            // set custom sizes and make sure sizes are not negative, if they are, don't subtract the insets.
            cellWidth = customSize.width - (customSize.width - xInsets > 0 ? xInsets : 0)
            cellHeight = customSize.height - (customSize.height - yInsets > 0 ? yInsets : 0)
        } else {
            cellWidth = cardSwiperView.frame.size.width - xInsets
            cellHeight = cardSwiperView.frame.size.height - yInsets
        }
        return CGSize(width: cellWidth, height: cellHeight)
    }

    fileprivate func setupCardSwiperView() {
        cardSwiperView = CardSwiperView(frame: self.frame, collectionViewLayout: flowLayout)
        cardSwiperView.decelerationRate = UIScrollView.DecelerationRate.fast
        cardSwiperView.backgroundColor = UIColor.clear
        cardSwiperView.showsVerticalScrollIndicator = false
        cardSwiperView.dataSource = self
        self.addSubview(cardSwiperView)
    }

    fileprivate func setupConstraints() {
        cardSwiperView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.cardSwiperView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.cardSwiperView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.cardSwiperView.topAnchor.constraint(equalTo: self.topAnchor),
            self.cardSwiperView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }

    fileprivate func setCardSwiperInsets() {
        let bottomInset = visibleNextCardHeight + flowLayout.minimumLineSpacing
        cardSwiperView.contentInset = UIEdgeInsets(top: topInset, left: sideInset, bottom: bottomInset, right: sideInset)
    }
}

