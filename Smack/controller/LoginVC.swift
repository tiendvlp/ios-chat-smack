import UIKit

struct array_abc : Decodable {
    var arr : [Float]
}

class LoginVC: ViewController {
    
    let TAG = "LOGINVC"
    
    @IBOutlet weak var btnLogin : UIButton!
    @IBOutlet weak var btnRegister : UIButton!
    @IBOutlet weak var edtUserEmail : UITextField!
    @IBOutlet weak var edtUserPassword : UITextField!
    
    @IBOutlet weak var uiViewLoading: UIView!
    @IBOutlet weak var spnLoading: UIActivityIndicatorView!
    override func viewDidLoad() {
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        isLoading(isLoading: false)
    }
    
    @IBAction func btnRegisterClickedListener(_ sender: Any) {
        performSegue(withIdentifier: GOTO_CREATE_ACCOUNT, sender: nil)
    }
    
    @IBAction func onBtnDissmissClickedListener(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnLoginClickedListener (_sender : Any) {
        isLoading(isLoading: true)
        
        guard let userEmail : String = edtUserEmail.text, edtUserEmail.text != "" else {
            isLoading(isLoading: false)
            print("\(TAG) UserName is empty")
            return
        }
        
        guard let userPassword : String = edtUserPassword.text, edtUserPassword.text != "" else {
            isLoading(isLoading: false)
            print("\(self.TAG) UserPassword is empty")
            return
        }
        
        
        AuthService.instance.loginUser(email: userEmail, password: userPassword, completion: {
            (isSuccess) in
              self.isLoading(isLoading: false)
            if (isSuccess) {
                AuthService.instance.getUserByEmail(email: userEmail, completion: {
                    (isSuccess, user) in
                    if isSuccess {
                        print("\(self.TAG) lay user thanh cong \(user!._id)   \(user!.name)")
                        UserDataService.instance.setUserData(id: user!._id, avatarColor: user!.avatarColor, name: user!.name, email: user!.email, avatarName: user!.avatarName)
                        NotificationCenter.default.post(name: Notification.Name(UserDataChangedListener), object: nil)
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        print("lay user that bai)")
                    }
                })
            
            }
        })
    }
    
    private func isLoading (isLoading : Bool) {
            uiViewLoading.isHidden = !isLoading
            spnLoading.isHidden = !isLoading
        if isLoading {
            spnLoading.startAnimating()
        } else {
            spnLoading.stopAnimating()
        }
    }
}
