//
//  CardStackView.swift
//  cardStack
//
//  Created by Abha on 17/09/23.
//

import Foundation
import UIKit

public class CardStackView: UICollectionView {
    
    public func dequeueReusableCell(withReuseIdentifier identifier: String, for index: Int) -> UICollectionViewCell {
        return self.dequeueReusableCell(withReuseIdentifier: identifier, for: IndexPath(row: index, section: 0))
    }
    
}
