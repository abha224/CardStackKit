//
//  CardStackDatasource.swift
//
//  Created by Abha on 17/09/23.
//

import Foundation

/// Used for providing data to the `CardSwiper`.
public protocol CardStackDatasource: AnyObject {
    
    func numberOfCards(cardStackView: CardStackView) -> Int
    func cardForItemAt(cardStackView: CardStackView, cardForItemAt index: Int) -> CardCell
}

