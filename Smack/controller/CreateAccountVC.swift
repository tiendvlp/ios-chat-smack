import UIKit

class CreateAccountVC: UIViewController {
    
    private let TAG = "CREATEACCOUNTVC"

    @IBOutlet weak var edtUserName: UITextField!
    
    @IBOutlet weak var uiviewLoading: UIView!
    @IBOutlet weak var edtEmail: UITextField!
    
    @IBOutlet weak var edtPassword: UITextField!
    
    @IBOutlet weak var imgAvatar: UIImageView!
    
    @IBOutlet weak var spnCreateAccount: UIActivityIndicatorView!
    var avatarColor_RGBFormat_inString = ""
    private var avatarBgColor : UIColor = UIColor.lightGray
    
    override func viewDidLoad() {
        self.hideKeyboardWhenTappedAround()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        isLoading(isLoading: false)
        
        if UserDataService.instance.avatarName != "" {
            imgAvatar.image = UIImage(named: UserDataService.instance.avatarName)
        }
    }
    
    @IBAction func onBtnDismissClickedListener(_ sender: Any) {
        performSegue(withIdentifier: UNWINDTO_CHANNEL, sender: nil)
    }
    
    @IBAction func onBtnChooseAvatarClickedListener(_ sender: Any) {
        performSegue(withIdentifier: GOTO_AVATARPICKER, sender: nil)
    }
    
    @IBAction func onBtnGenerateBgColorClickedListener(_ sender: Any) {
        let rColor : CGFloat = CGFloat(arc4random_uniform(255))/255
        let gColor : CGFloat = CGFloat(arc4random_uniform(255))/255
        let bColor : CGFloat = CGFloat(arc4random_uniform(255))/255
        let alpha : CGFloat =  1
        
        avatarBgColor = UIColor(red: rColor, green: gColor, blue: bColor, alpha: alpha)
        
        avatarColor_RGBFormat_inString = "[\(rColor),\(gColor),\(bColor),\(alpha)]"
        
        UIView.animate(withDuration: 0.1, animations: {
            self.imgAvatar.backgroundColor = self.avatarBgColor
        })
    }
    
  
    @IBAction func onBtnCreateAccountClickedListener(_ sender: Any) {
        
        
        guard let userEmail : String = edtEmail.text, edtUserName.text != "" else {
            print("UserName is empty")
            return
        }
        
        guard let userPassword : String = edtPassword.text, edtPassword.text != "" else {
            print("UserPassword is empty")
            return
        }
        
        guard let userName : String = edtUserName.text, edtUserName.text != "" else {
            print("UserName is nil")
            return
        }
        
        guard let avatarName : String = UserDataService.instance.avatarName, UserDataService.instance.avatarName != "" else {
            print("User avatar is nil")
            return
        }
        
        if avatarColor_RGBFormat_inString == "" {
            print("\(TAG) avatar background color is empty")
            return
        }
        
        spnCreateAccount.isHidden = false
        uiviewLoading.isHidden = false
        spnCreateAccount.startAnimating()
        AuthService.instance.registerUser(email: userEmail, password: userPassword, completion: {
            (isSuccess) in
           
            if isSuccess {
                
                    print("\(self.TAG) đăng ký thành công")
                    AuthService.instance.loginUser(email: userEmail, password: userPassword, completion: {
                        (isSuccess) in
                        
                        if isSuccess {
                        
                        print("\(self.TAG) đăng nhập thành công")
                        
                        AuthService.instance.createUser(userName: userName, avatarColor: self.avatarColor_RGBFormat_inString, avatarName: avatarName, email: userEmail , completion: {
                            (isSuccess) in
                            
                            if isSuccess {
                        NotificationCenter.default.post(name: Notification.Name(UserDataChangedListener), object: nil)
                            print("\(self.TAG) tạo user thành công")
                            AuthService.instance.isLoggedIn = true
                            self.performSegue(withIdentifier: UNWINDTO_CHANNEL, sender: nil)
                            }
                            self.isLoading(isLoading: false)
                        
                        })
                            
                        } else {
                            self.isLoading(isLoading: false)
                        }
            
                })
                
            } else {

                print("\(self.TAG) đăng ký thất bại")
               self.isLoading(isLoading: false)
            }
          
        })
    }
    
    //private func findUserByEmail (email : String, completion : ())
    
    private func isLoading (isLoading : Bool) {
        self.spnCreateAccount.isHidden = !isLoading
        self.uiviewLoading.isHidden = !isLoading
        if isLoading {
            self.spnCreateAccount.startAnimating()
        } else {
            
            self.spnCreateAccount.stopAnimating()
        }
    }
    
    
}
