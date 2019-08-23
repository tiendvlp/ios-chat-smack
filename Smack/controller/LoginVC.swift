import UIKit

class LoginVC: ViewController {
    
    let TAG = "LOGINVC"
    
    @IBOutlet weak var btnLogin : UIButton!
    @IBOutlet weak var btnRegister : UIButton!
    @IBOutlet weak var edtUserEmail : UITextField!
    @IBOutlet weak var edtUserPassword : UITextField!
    
    override func viewDidLoad() {
       
    }
    @IBAction func btnRegisterClickedListener(_ sender: Any) {
        performSegue(withIdentifier: GOTO_CREATE_ACCOUNT, sender: nil)
    }
    
    @IBAction func onBtnDissmissClickedListener(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnLoginClickedListener (_sender : Any) {
        
        guard let userEmail : String = edtUserEmail.text, edtUserEmail.text != "" else {
            print("\(TAG) UserName is empty")
            return
        }
        
        guard let userPassword : String = edtUserPassword.text, edtUserPassword.text != "" else {
            print("\(self.TAG) UserPassword is empty")
            return
        }
        
        
        AuthService.instance.loginUser(email: userEmail, password: userPassword, completion: {
            (isSuccess) in
            
        })
    }
}
