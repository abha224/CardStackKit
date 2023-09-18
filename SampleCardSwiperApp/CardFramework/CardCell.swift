//
//  CardCell.swift
//
//  Created by Abha on 17/09/23.
//

import UIKit

/// This code defines a reusable CardCell class for creating swipeable cards within a collection view.
@objc open class CardCell: UICollectionViewCell {

    open override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        self.layer.zPosition = CGFloat(layoutAttributes.zIndex)
    }
}
