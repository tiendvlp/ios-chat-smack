import UIKit

class ChannelCollectionViewCell: UITableViewCell {
    
    @IBOutlet weak var name : UILabel!
    
    override func awakeFromNib() {
        
    }
    
    func setupView (channelName name : String) {
        self.name.text = ("# \(name)")
    }
    
    func setState (isSelected : Bool) {
        if isSelected {
            self.backgroundColor = UIColor(white: 1, alpha: 0.3)
        } else {
            self.backgroundColor = UIColor.clear
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        setState(isSelected: selected)
    }
    
}
