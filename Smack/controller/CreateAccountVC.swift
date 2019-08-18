import UIKit

class CreateAccountVC: UIViewController {

    override func viewDidLoad() {
        
    }
    @IBAction func onBtnDismissClickedListener(_ sender: Any) {
        performSegue(withIdentifier: UNWINDTO_CHANNEL, sender: nil)
    }
    
}
