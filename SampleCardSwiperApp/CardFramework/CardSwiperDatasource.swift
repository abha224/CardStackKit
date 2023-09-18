//
//  CardSwiperDatasource.swift
//
//  Created by Abha on 17/09/23.
//

import Foundation

/// Used for providing data to the `CardSwiper`.
public protocol CardSwiperDatasource: AnyObject {
    
    func numberOfCards(cardSwiperView: CardSwiperView) -> Int
    func cardForItemAt(cardSwiperView: CardSwiperView, cardForItemAt index: Int) -> CardCell
}

