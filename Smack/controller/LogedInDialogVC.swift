import UIKit

class LogedInDialogVC: UIViewController {
    @IBOutlet weak var btnClose: UIButton!
    
    
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var viewBgMain: UIView!
    @IBOutlet weak var lblUserEmail: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var imgUserAvatar: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewBgMain.layer.cornerRadius = 14
        
        if (AuthService.instance.isLoggedIn) {
            lblUserName.text = UserDataService.instance.name
            lblUserEmail.text = UserDataService.instance.email
            imgUserAvatar.image = UIImage(named: UserDataService.instance.avatarName)
            imgUserAvatar.backgroundColor = UserDataService.instance.fromAvatarColorInString_toAvatarColorInUIColor()
        }
        
        let tapRecognizer = UITapGestureRecognizer (target: self, action: #selector(LogedInDialogVC.dismissVC))
        viewBg.addGestureRecognizer(tapRecognizer)
        
    }
    
    @objc func dismissVC () {
        dismiss(animated: true, completion: nil)
    }
  
    @IBAction func onBtnCloseClickedListener(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func onBtnLogoutClickedListener(_ sender: Any) {
            UserDataService.instance.logout()
            NotificationCenter.default.post(name: Notification.Name(UserDataChangedListener), object: nil)
            dismiss(animated: true, completion: nil)
    }
    

}
