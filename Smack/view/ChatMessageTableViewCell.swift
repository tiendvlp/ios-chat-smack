import UIKit

class ChatMessageTableViewCell: UITableViewCell {
    @IBOutlet weak var imgAvatar : UIImageView!
    @IBOutlet weak var txtUserName : UILabel!
    @IBOutlet weak var txtChatMessage : UILabel!
    @IBOutlet weak var txtDate : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpView (userName : String, userAvatar : String,avatarColor: String, message : String, date : String) {
        imgAvatar.backgroundColor = UserDataService.instance.fromAvatarColorInString_toAvatarColorInUIColor(colorInString: avatarColor)
        imgAvatar.image = UIImage(named: userAvatar)
        txtChatMessage.text = message
        txtDate.text = date
        txtUserName.text = userName
    }

}
