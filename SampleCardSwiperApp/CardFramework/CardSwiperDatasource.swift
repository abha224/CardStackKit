//
//  CardSwiperDatasource.swift
//
//  Created by Abha on 17/09/23.
//

import Foundation

/// Used for providing data to the `StackCard`.
public protocol CardSwiperDatasource: AnyObject {
    func numberOfCards(stackCardView: CardSwiperView) -> Int
    func cardForItemAt(stackCardView: CardSwiperView, cardForItemAt index: Int) -> CardCell
}

