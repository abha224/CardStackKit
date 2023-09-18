//
//  CardSwiperDatasource.swift
//  cardStack
//
//  Created by Abha on 17/09/23.
//

// done

import Foundation

/// This datasource is used for providing data to the `StackCard`.
public protocol StackCardDatasource: AnyObject {

    func numberOfCards(stackCardView: StackCardView) -> Int
    func cardForItemAt(stackCardView: StackCardView, cardForItemAt index: Int) -> CardCell
}

