import UIKit
import SWRevealViewController
class ChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    let TAG : String = "CHATVC"
    @IBOutlet weak var btnShowChannel: UIButton!
    
    @IBOutlet weak var tbvChatMessage: UITableView!

    
    @IBOutlet weak var edtMessage: UITextView!
    @IBOutlet weak var btnSendMessage: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        tbvChatMessage.dataSource = self
        tbvChatMessage.delegate = self
        
        tbvChatMessage.estimatedRowHeight =  290
        tbvChatMessage.rowHeight = UITableView.automaticDimension
        
        view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        if (AuthService.instance.isLoggedIn) {
            AuthService.instance.getUserByEmail(email: AuthService.instance.userEmail, completion: {
                (isSuccess, user) in
                if isSuccess {
                    print("\(self.TAG) lay user thanh cong \(user!._id)  \(user!.name)")
                    UserDataService.instance.setUserData(id: user!._id, avatarColor: user!.avatarColor, name: user!.name, email: user!.email, avatarName: user!.avatarName)
                        NotificationCenter.default.post(name: Notification.Name(UserDataChangedListener), object: nil)
                    self.onSetUpDone()
                } else {
                    print("lay user that bai)")
                }
            })
        } else {
            NotificationCenter.default.post(name: Notification.Name(UserDataChangedListener), object: nil)
            onSetUpDone()
        }
    
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = MessageService.instance.messages?.count {
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "chatmessagecell") as? ChatMessageTableViewCell {
            let newMessage = MessageService.instance.messages![indexPath.row]
            cell.setUpView(userName: newMessage.userName, userAvatar: newMessage.userAvatar, message: newMessage.chatMessage, date: newMessage.date)
            return cell
        }
        return ChatMessageTableViewCell()
    }
    
    @IBAction func onBtnSendChatMessageOnClickedListener(_ sender: Any) {
            
    }
    
    func onSetUpDone () {
        btnShowChannel.addTarget(self.revealViewController(),
                                 action: SWRevealViewController.getRevealToggle(),
                                 for: .touchUpInside)
        
      
    }
    
}
