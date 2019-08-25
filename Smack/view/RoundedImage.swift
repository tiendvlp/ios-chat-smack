import UIKit

@IBDesignable
class RoundedImage: UIImageView {
    
    override func awakeFromNib() {
        setUpView()
    }
    
    override func prepareForInterfaceBuilder() {
        setUpView()
    }
    
    func setUpView () {
        self.layer.cornerRadius = self.bounds.size.width / 2
        self.clipsToBounds =  true
    }
}
