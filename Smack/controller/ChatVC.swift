import UIKit
import SWRevealViewController

class ChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    let TAG : String = "CHATVC"
    @IBOutlet weak var btnShowChannel: UIButton!
    
    @IBOutlet weak var txtTypingPeople: UILabel!
    @IBOutlet weak var tbvChatMessage: UITableView!

    @IBOutlet weak var txtChannelName: UILabel!
    
    @IBOutlet weak var edtMessage: UITextField!
    @IBOutlet weak var btnSendMessage: UIButton!
    
    @IBOutlet weak var lvMessages : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.bindToKeyboard()
        
        isTyping = false
        btnSendMessage.isHidden = true
        
        let tabRecognizer = UITapGestureRecognizer(target: self, action: #selector(ChatVC.onUserTapOnViewSelf))
        view.addGestureRecognizer(tabRecognizer)
        tbvChatMessage.dataSource = self
        tbvChatMessage.delegate = self
    
        lvMessages.dataSource = self
        lvMessages.delegate = self
        
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
                        MessageService.instance.findAllChannels(completionHandler: {
                            isSuccess in
                            NotificationCenter.default.post(name: Notification.Name(UserDataChangedListener), object: nil)
                            self.onSetUpDone()
                        })

                } else {
                    print("lay user that bai)")
                }
            })
        } else {
            NotificationCenter.default.post(name: Notification.Name(UserDataChangedListener), object: nil)
            onSetUpDone()
        }
        if AuthService.instance.isLoggedIn {
            txtChannelName.text = "Smack"
        } else {
            txtChannelName.text = "Please login"
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.onUserSelectChannel(_:)), name: OnChannelSelectedListener, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.userDataDidChanged(_:)), name: NSNotification.Name(rawValue: UserDataChangedListener), object: nil)
        
        
    }
    
    @objc func onUserTapOnViewSelf () {
        view.endEditing(true)
    }
    
    
    @objc func onUserSelectChannel (_ notifi : Notification) {
        txtChannelName.text = "#\(MessageService.instance.selectedChannel!.name)"
        getMessages()
    }
    
    @objc func userDataDidChanged (_ notifi : Notification) {
        if AuthService.instance.isLoggedIn {
            SocketService.instance.socket.connect()
            if let channel = MessageService.instance.selectedChannel {
                txtChannelName.text = channel.name
            } else {
                txtChannelName.text = "Smack"
            }
            
            SocketService.instance.getMessage(handler: {
                result in
                if result {
                    self.lvMessages.reloadData()
                    self.scrollToBottom()
                }
            })
            
            typingPeopleUpdate()
            
            onLoginGetMessages()
        } else {
            SocketService.instance.socket.disconnect()
            txtChannelName.text = "Please Login"
            lvMessages.reloadData()
        }
    }
    
    private func typingPeopleUpdate () {
        SocketService.instance.getTypingPeople({
                   (typingPeople) in
                   
                   guard let channelId = MessageService.instance.selectedChannel?._id else {return}
                   
                   var names  = ""
                   var numOfTyper = 0
                   
        print("dumam \(typingPeople.count)" )
                    
                   for (typingPeople, channel) in typingPeople {
                       if (typingPeople != UserDataService.instance.name     && channel == channelId) {
                           if names == "" {
                               names = typingPeople
                           } else {
                               names = "\(names), \(typingPeople)"
                           }
                           
                           numOfTyper += 1
                       }
                   }
                   
                   if numOfTyper > 0 && AuthService.instance.isLoggedIn {
                       var verb = "is"
                       
                       if numOfTyper > 1 {
                           verb = "are"
                       }
                       
                       self.txtTypingPeople.text = "\(names) \(verb) typing"
                       
                       print("typing \(names)")
                   } else {
                    self.txtTypingPeople.text = ""
        }
               })
    }
    
    private func scrollToBottom () {
        let index = MessageService.instance.messages.count - 1
        if (MessageService.instance.messages.count > 0) {
            lvMessages.scrollToRow(at: IndexPath(row: index, section: 0), at: .bottom, animated: false)
        }
    }
    
    private var isTyping : Bool = false
    
    @IBAction func onEdtMessageChanged(_ sender: Any) {
        guard let channelId = MessageService.instance.selectedChannel?._id else {return}
        if edtMessage.text! == "" {
            isTyping = false
            print("stopType")
            SocketService.instance.socket.emit("stopType", UserDataService.instance.name, channelId)
            btnSendMessage.isHidden = true
        } else {
            if !isTyping {
                btnSendMessage.isHidden = false
            }
            SocketService.instance.socket.emit("startType", UserDataService.instance.name, channelId)
            isTyping = true
        }
    }
    
    func onLoginGetMessages () {
        MessageService.instance.findAllChannels { (success) in
            if success {
                if MessageService.instance.channels.count > 0 {
                    MessageService.instance.selectedChannel =  MessageService.instance.channels[0] as Channel
                    self.getMessages()
                    self.txtChannelName.text = MessageService.instance.selectedChannel?.name
                } else {
                    self.txtChannelName.text = "No channel"
                }
            } else {
                self.txtChannelName.text = "No channel"
            }
        }
    }
    
    func getMessages () {
        guard let channelId = MessageService.instance.selectedChannel?._id else {return}
        if channelId.isEmpty {return}
            
        MessageService.instance.findAllMessageInSpecificChannel(channelId: channelId, completion: {
            result in
            print("get message success")
            print("get Message \(MessageService.instance.messages.count as Any)")
            self.lvMessages.reloadData()
            self.scrollToBottom()
        })
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return MessageService.instance.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "chatmessagecell") as? ChatMessageTableViewCell {
            let newMessage = MessageService.instance.messages[indexPath.row]
            
            cell.setUpView(userName: newMessage.userName, userAvatar: newMessage.userAvatar,avatarColor: newMessage.userAvatarColor, message: newMessage.messageBody, date: newMessage.timeStamp)
            return cell
        }
        return ChatMessageTableViewCell()
    }
    
    @IBAction func onBtnSendChatMessageOnClickedListener(_ sender: Any) {
        if AuthService.instance.isLoggedIn {
            guard let selectedChannel = MessageService.instance.selectedChannel else {return}
            guard let messageBody = edtMessage.text else {return}
            
            if messageBody.isEmpty {
                return
            }
            
            SocketService.instance.sendNewMessage(userId: UserDataService.instance.id, messageBody: messageBody, channelId: (selectedChannel._id), completion: {
                result in
                if (result) {
                    self.edtMessage.text = ""
                    
                }
            })

                print("stopType")
            SocketService.instance.socket.emit("stopType", UserDataService.instance.name, selectedChannel._id)
        }
    }
    
    func onSetUpDone () {
        btnShowChannel.addTarget(self.revealViewController(),
                                 action: SWRevealViewController.getRevealToggle(),
                                 for: .touchUpInside)
        
      
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
    }
    
}
