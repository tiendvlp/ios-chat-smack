import UIKit

class ChannelVC: UIViewController, UITableViewDelegate, UITableViewDataSource {


    let TAG : String = "CHANNELVC"
    
    @IBOutlet weak var lvChannel: UITableView!
    @IBOutlet weak var btnLogIn: UIButton!
    
    @IBOutlet weak var imgUserAvatar: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        processUserDataChanged()
        lvChannel.dataSource = self
        lvChannel.delegate  = self
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelVC.onUserDataChanged), name: NSNotification.Name(UserDataChangedListener), object: nil)
        self.revealViewController()?.rearViewRevealWidth = view.frame.size.width - 40
    
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelVC.onUserCreateChannelListener), name: OnChannelCreatedListener, object: nil)
        
        SocketService.instance.getChannel(completion: {
            isSuccess in
            self.lvChannel.reloadData()
        })
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
      
    }
    
    @IBAction func onBtnAddChannelClickedListener(_ sender: Any) {
        if (AuthService.instance.isLoggedIn) {
            let addChannelVC = AddChannelVC()
            addChannelVC.modalPresentationStyle = .custom
            self.present(addChannelVC, animated : true, completion: nil)
        }
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CHANNEL_COLLECTION_CELL_IDENTIFIER, for: indexPath) as? ChannelCollectionViewCell {
            cell.setupView(channelName: MessageService.instance.channels[indexPath.row].name ?? "")
            return cell
        }
        let cell = ChannelCollectionViewCell()
        cell.setupView(channelName: MessageService.instance.channels[indexPath.row].name ?? "")
        return cell
    }
    

    @objc
    func onUserDataChanged (_ notification : Notification) {
        processUserDataChanged()
    }
    
    private func processUserDataChanged () {
        
        if AuthService.instance.isLoggedIn {
            print("\(UserDataService.instance.name)")
            btnLogIn.setTitle(UserDataService.instance.name, for: .normal)
            imgUserAvatar.backgroundColor = UserDataService.instance.fromAvatarColorInString_toAvatarColorInUIColor()
            imgUserAvatar.image = UIImage(named: UserDataService.instance.avatarName)
            
            MessageService.instance.findAllChannels(completionHandler: {
                result in
                if (result) {
                    self.lvChannel.reloadData()
                }
            })
        } else {
            btnLogIn.setTitle("Login", for: .normal)
            imgUserAvatar.backgroundColor = UIColor.lightGray
            imgUserAvatar.image = UIImage(named: "profileDefault")
            self.lvChannel.reloadData()
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let channel = MessageService.instance.channels[indexPath.row]
        MessageService.instance.selectedChannel = channel
        NotificationCenter.default.post(name: OnChannelSelectedListener, object: nil)
        self.revealViewController()?.revealToggle(nil)
    }
    
    @objc func onUserCreateChannelListener (_ notification : NSNotification) {
        lvChannel.reloadData()
    }
    
    
    
    @IBAction func btnLoginOnClickedListener(_ sender: Any) {
        
        if (AuthService.instance.isLoggedIn) {
            let logedInDialog = LogedInDialogVC()
            logedInDialog.modalPresentationStyle = .custom
            self.present(logedInDialog, animated : true, completion: nil)
        } else {
            performSegue(withIdentifier: GOTO_LOGIN, sender: nil)
        }
    }
    
    @IBAction func prepareForUnwind (segue : UIStoryboardSegue) {
        
    }
    
}
