//
//  CardCell.swift
//  cardStack
//
//  Created by Abha on 17/09/23.
//

// This code defines a reusable CardCell class for creating swipeable cards within a collection view. It includes methods for animating the card's movement, handling user interactions, and notifying a delegate about various card-related events.

import UIKit

/**
 The CardCell that the user can swipe away. Based on `UICollectionViewCell`.
 
 The cells will be recycled by the `StackCard`,
 so don't forget to override `prepareForReuse` when needed.
 */
@objc open class CardCell: UICollectionViewCell {

    open override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        self.layer.zPosition = CGFloat(layoutAttributes.zIndex)
    }

    open override func prepareForReuse() {
        super.prepareForReuse()
        self.isHidden = false
    }
}
