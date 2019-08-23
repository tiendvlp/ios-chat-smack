import Foundation

class UserDataService {
    
    public static let instance : UserDataService = UserDataService()
    
    public private(set) var name : String = ""
    public private(set) var id : String = ""
    public private(set) var avatarName : String = ""
    public private(set) var email : String = ""
    public private(set) var avatarColor : String = ""
    
    func setUserData (id : String, avatarColor: String, name: String, email: String, avatarName: String) {
        self.id = id
        self.avatarName = avatarName
        self.avatarColor = avatarColor
        self.email = email
        self.name = name
    }
    
}
