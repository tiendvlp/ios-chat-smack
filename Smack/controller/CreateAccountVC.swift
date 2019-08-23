import UIKit

class CreateAccountVC: UIViewController {
    
    private let TAG = "CREATEACCOUNTVC"

    @IBOutlet weak var edtUserName: UITextField!
    
    @IBOutlet weak var edtEmail: UITextField!
    
    @IBOutlet weak var edtPassword: UITextField!
    
    @IBOutlet weak var imgAvatar: UIImageView!
    
    var avatarColor_default = "[0.5, 0.5, 0.5, 1]"
    var avatarName_default = "avatarDefault"
    
    override func viewDidLoad() {
        
        
    }
    
    @IBAction func onBtnDismissClickedListener(_ sender: Any) {
        performSegue(withIdentifier: UNWINDTO_CHANNEL, sender: nil)
    }
    
    @IBAction func onBtnChooseAvatarClickedListener(_ sender: Any) {
    }
    
    @IBAction func onBtnGenerateBgColorClickedListener(_ sender: Any) {
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
        
        
        AuthService.instance.registerUser(email: userEmail, password: userPassword, completion: {
            (isSuccess) in
            if (isSuccess) {
                    AuthService.instance.loginUser(email: userEmail, password: userPassword, completion: {
                        (isSuccss) in
                        AuthService.instance.createUser(userName: userName, avatarColor: self.avatarColor_default, avatarName: self.avatarName_default, email: userEmail , completion: {
                            (isSuccess) in
                    })
                    print("\(self.TAG) tạo user thành công")
                })
                print("\(self.TAG) đăng ký thành công")
                
            } else {
                print("\(self.TAG) đăng ký thất bại")
            }
        })
    }
}
