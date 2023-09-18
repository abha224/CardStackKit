//
//  CardSwiperDelegate.swift
//
//  Created by Abha on 17/09/23.
//

import Foundation
import UIKit

/// Used for delegating `CardSwiper` actions.
@objc public protocol CardSwiperDelegate: AnyObject {

    @objc optional func didTapCard(cardSwiperView: CardSwiperView, index: Int)
    @objc optional func didEndScroll(cardSwiperView: CardSwiperView)
    @objc optional func sizeForItem(cardSwiperView: CardSwiperView, index: Int) -> CGSize
}

