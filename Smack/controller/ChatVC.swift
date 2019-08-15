import UIKit
import SWRevealViewController
class ChatVC: UIViewController {

    @IBOutlet weak var btnShowChannel: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnShowChannel.addTarget(self.revealViewController(),
                                 action: SWRevealViewController.getRevealToggle(),
                                 for: .touchUpInside)
        
        view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
    }
    
}
