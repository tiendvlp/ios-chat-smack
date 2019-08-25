import UIKit

class ChannelVC: UIViewController {
    @IBOutlet weak var btnLogIn: UIButton!
    
    @IBOutlet weak var imgUserAvatar: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.revealViewController()?.rearViewRevealWidth = view.frame.size.width - 40
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
       
        
        imgUserAvatar.backgroundColor = UserDataService.instance.fromAvatarColorInString_toAvatarColorInUIColor()
        imgUserAvatar.image = UIImage(named: UserDataService.instance.avatarName) 
    }
    
    @IBAction func btnLoginOnClickedListener(_ sender: Any) {
        performSegue(withIdentifier: GOTO_LOGIN, sender: nil)
    }
    
    @IBAction func prepareForUnwind (segue : UIStoryboardSegue) {
        
    }
    
}
