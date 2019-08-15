import UIKit

@IBDesignable
class GradientView: UIView {

    @IBInspectable var topColor : CGColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1) {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable var bottomColor : CGColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1) {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    override func layoutSubviews() {
        let gradient = CAGradientLayer ()
        gradient.colors = [topColor, bottomColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint (x:1, y:1)
        gradient.frame = self.bounds
        self.layer.insertSublayer(gradient, at: 0)
    }
    

}
