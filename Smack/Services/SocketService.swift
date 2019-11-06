import Foundation
import SocketIO

class SocketService {
    static let instance : SocketService = SocketService()
    
    private let manager = SocketManager(socketURL: URL(string: URL_BASE)!, config: [.log(true), .compress])
    
     let socket : SocketIOClient
    
    init() {
        self.socket = manager.defaultSocket
    }
    
    func connect () {
        self.socket.connect()
    }
    
    func disconnect () {
        self.socket.disconnect()
    }
    
    func addChannel (Channelname name : String, ChannelDescription description : String, completion : @escaping completionHandler) {
        socket.emit("newChannel", name, description)
        completion(true)
    }
    
    func getChannel (completion : @escaping completionHandler) {
        
        // sự kiện mỗi khi có một channel mới được tạo ra.
        socket.on("channelCreated" , callback: {
            (dataArray, ack) in
        
            guard let channelName : String = dataArray[0] as? String else {return}
            guard let channelDesc = dataArray[1] as? String else {return}
            guard let channelId = dataArray[2] as? String else {return}
            
            let newChannel = Channel(_id: channelId, description: channelName, name: channelDesc)
            
            MessageService.instance.channels.append(newChannel)
            
            NotificationCenter.default.post(Notification(name: OnChannelCreatedListener))
            completion(true)
            
        })
        
     
    }
    
    func sendNewMessage (userId : String, messageBody : String, channelId : String, completion : @escaping completionHandler){
        let user = UserDataService.instance
        socket.emit("newMessage", messageBody, userId, channelId, user.name, user.avatarName, user.avatarColor)
        completion(true)
    }
    
    func getMessage (handler : @escaping completionHandler) {
        socket.on("messageCreated") {
            (dataArray, ack) in
            guard let messageBody = dataArray[0] as? String else {return}
            guard let channelId = dataArray[2] as? String else {return}
            guard let userName = dataArray[3] as? String else {return}
            guard let userAvatar = dataArray[4] as? String else {return}
            guard let userAvatarColor = dataArray[5] as? String else {return}
            guard let id = dataArray[6] as? String else {return}
            guard let timeStamp = dataArray[7] as? String else {return}
            
            if channelId == MessageService.instance.selectedChannel?._id {
                let newMessage = Message(_id: id, messageBody: messageBody, userName: userName, channelId: channelId, userAvatar: userAvatar, userAvatarColor: userAvatarColor, __v: 0, timeStamp: timeStamp)
                MessageService.instance.messages.append(newMessage)
               handler(true)
            } else {
                handler(false)
            }
        }
    }
    
    func getTypingPeople (_ handler : @escaping (_ typingPeople : [String : String]) -> Void) {
        socket.on("userTypingUpdate") {
            (dataArray, ack) in
            guard let typingPeople = dataArray[0] as? [String : String] else {return}
            
            handler(typingPeople)
            
        }
    }
}
