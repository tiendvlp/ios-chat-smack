import UIKit

class AvatarCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgAvatar : UIImageView!
    
    override func awakeFromNib() {
        self.layer.backgroundColor = UIColor.darkGray.cgColor
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
    
    func setup (_ backgroundColor : AvatarBackground, _ index : Int) {
        var currentBg : String = "light"
        
        switch backgroundColor {
        case AvatarBackground.light:
            currentBg = "light"
            break
        case AvatarBackground.dark:
            currentBg = "dark"
            break
        }
        
        
        if let image = UIImage(named: "\(currentBg)\(index)") {
            self.imgAvatar.image = image
        }
        self.layer.backgroundColor = UIColor.darkGray.cgColor
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
    
}

enum AvatarBackground {
    case dark
    case light
}
