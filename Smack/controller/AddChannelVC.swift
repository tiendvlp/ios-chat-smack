
import UIKit

class AddChannelVC: UIViewController {
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtDescription: UITextField!
    
    @IBOutlet weak var viewBg : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
            print("hello")
        let tapRecognizer = UITapGestureRecognizer (target: self, action: #selector(AddChannelVC.onClickedOutside))
        viewBg.addGestureRecognizer(tapRecognizer)

    }


    @IBAction func onBtnCreateChannelClickedListener(_ sender: Any) {
   
    }
    
    
    @IBAction func onBtnClosedClickedListener(_ sender: Any) {
        print("hello")
        dismiss(animated: true, completion: nil)
    }
    
    @objc func onClickedOutside () {
        print("you have clicked outside")
    }
   
    @objc func dismissVC2() {
        print("hello")
        dismiss(animated: true, completion: nil)
    }
}
