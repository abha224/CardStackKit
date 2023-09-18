//
//  CardSwiperDelegate.swift
//  cardStack
//
//  Created by Abha on 17/09/23.
//

// done

import Foundation
import UIKit

/// This delegate is used for delegating `StackCard` actions.
@objc public protocol CardSwiperDelegate: AnyObject {

    @objc optional func didTapCard(stackCardView: StackCardView, index: Int)
    @objc optional func didEndScroll(stackCardView: StackCardView)
    
    
    @objc optional func sizeForItem(stackCardView: StackCardView, index: Int) -> CGSize
//    @objc optional func didCancelSwipe(card: CardCell, index: Int)
    @objc optional func didHoldCard(stackCardView: StackCardView, index: Int, state: UITapGestureRecognizer.State)
    
    @objc optional func didDragCard(card: CardCell, index: Int, swipeDirection: SwipeDirection)
    @objc optional func didScroll(stackCardView: StackCardView)
    @objc optional func didSwipeCardAway(card: CardCell, index: Int, swipeDirection: SwipeDirection)
    @objc optional func willSwipeCardAway(card: CardCell, index: Int, swipeDirection: SwipeDirection)


}

