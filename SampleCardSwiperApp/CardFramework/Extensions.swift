//
//  Extensions.swift
//  cardStack
//
//  Created by Abha on 17/09/23.
//

import Foundation
import UIKit

/// Indicates the direction of a cardcell swipe.
@objc public enum SwipeDirection: Int {
    case Left
    case Right
    case None
}

public enum PanDirection: Int {
    case Up
    case Down
    case Left
    case Right
    case None

    /// Returns true is the PanDirection is horizontal.
    public var isX: Bool { return self == .Left || self == .Right }
    /// Returns true if the PanDirection is vertical.
    public var isY: Bool { return self == .Up || self == .Down }
}

internal extension UIPanGestureRecognizer {

    /**
     This calculated var stores the direction of the gesture received by the `UIPanGestureRecognizer`.
     */
    var direction: PanDirection? {
        let velocity = self.velocity(in: view)
        let vertical = abs(velocity.y) > abs(velocity.x)
        switch (vertical, velocity.x, velocity.y) {
        case (true, _, let y) where y < 0: return .Up
        case (true, _, let y) where y > 0: return .Down
        case (false, let x, _) where x > 0: return .Right
        case (false, let x, _) where x < 0: return .Left
        default: return .None
        }
    }
}

extension StackCard {
    /// Takes an index as Int and converts it to an IndexPath with row: index and section: 0.
    internal func convertIndexToIndexPath(for index: Int) -> IndexPath {
        return IndexPath(row: index, section: 0)
    }
}

