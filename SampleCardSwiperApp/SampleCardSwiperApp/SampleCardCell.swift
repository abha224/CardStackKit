import Foundation
import UIKit

class SampleCardCell: CardCell {
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var buttomTitleView: UIView!
    
    public func setBackgroundColor() -> UIColor {
        return UIColor.darkGray
    }

    override func prepareForReuse() {
        super.prepareForReuse()

    }

    override func layoutSubviews() {
        let corners = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 20, height: 20))
        let shape = CAShapeLayer.init()
        shape.path = corners.cgPath
        self.layer.mask = shape
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.systemBackground.cgColor
        super.layoutSubviews()
    }
}
