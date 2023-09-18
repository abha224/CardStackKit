//
//  CardSwiperDelegate.swift
//
//  Created by Abha on 17/09/23.
//

import Foundation
import UIKit

/// Used for delegating `StackCard` actions.
@objc public protocol CardSwiperDelegate: AnyObject {

    @objc optional func didTapCard(stackCardView: CardSwiperView, index: Int)
    @objc optional func didEndScroll(stackCardView: CardSwiperView)
    @objc optional func sizeForItem(stackCardView: CardSwiperView, index: Int) -> CGSize
}

