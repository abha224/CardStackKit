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
}

