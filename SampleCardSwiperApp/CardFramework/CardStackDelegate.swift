//
//  CardSwiperDelegate.swift
//
//  Created by Abha on 17/09/23.
//

import Foundation
import UIKit

/// Used for delegating `CardSwiper` actions.
@objc public protocol CardStackDelegate: AnyObject {

    @objc optional func didTapCard(cardStackView: CardStackView, index: Int)
    @objc optional func didEndScroll(cardStackView: CardStackView)
    @objc optional func sizeForItem(cardStackView: CardStackView, index: Int) -> CGSize
}

