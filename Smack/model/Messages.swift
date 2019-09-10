import Foundation

class Messages {
    var userName : String = ""
    var userAvatar : String = ""
    var chatMessage : String = ""
    var date : String = ""
    
    init(userName : String, userAvatar : String, chatMessage : String, date : String) {
        self.userName = userName
        self.userAvatar = userAvatar
        self.chatMessage = chatMessage
        self.date = date
    }
}
