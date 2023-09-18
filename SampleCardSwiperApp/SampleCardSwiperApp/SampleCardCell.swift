import Foundation
import UIKit

class SampleCardCell: CardCell {
    
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var buttomTitleView: UIView!
    
    /**
     We use this function to calculate and set a  backgroundcolor for the card.
     */
    public func setBackgroundColor() -> UIColor {
        return UIColor(white: 0.0, alpha: 1.0)
    }

    override func prepareForReuse() {
        super.prepareForReuse()

    }

    override func layoutSubviews() {
        let corners = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 20, height: 20))
        let shape = CAShapeLayer.init()
        shape.path = corners.cgPath
        self.layer.mask = shape
        super.layoutSubviews()
    }
}
