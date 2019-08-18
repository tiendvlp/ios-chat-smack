import UIKit

class LoginVC: ViewController {

    override func viewDidLoad() {
        
    }
    @IBAction func btnRegisterClickedListener(_ sender: Any) {
        performSegue(withIdentifier: GOTO_CREATE_ACCOUNT, sender: nil)
    }
    
    @IBAction func onBtnDissmissClickedListener(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
