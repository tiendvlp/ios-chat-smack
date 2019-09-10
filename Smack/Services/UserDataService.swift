import Foundation
import UIKit
class UserDataService {
    
    public let TAG = "USERDATASERVICE"
    
    public static let instance : UserDataService = UserDataService()
    
    public private(set) var name : String = ""
    public private(set) var id : String = ""
    public var avatarName : String! = "profileDefault"
    public private(set) var email : String = ""
    public private(set) var avatarColor : String! = "[211,211,211,1]"
    
    func setUserData (id : String, avatarColor: String, name: String, email: String, avatarName: String) {
        self.id = id
        self.avatarName = avatarName
        self.avatarColor = avatarColor
        self.email = email
        self.name = name
    }
    
    func fromAvatarColorInString_toAvatarColorInUIColor () -> UIColor {
        if avatarColor == "" {
            return UIColor.lightGray
        }
        
       
        do {
            let avatarColorAsJsonArray = "{\"colorArray\" : \(self.avatarColor!)}"
            
            let avatarColor : AvatarColor = try JSONDecoder().decode(AvatarColor.self, from: avatarColorAsJsonArray.data(using: .utf8)!)
            let red = CGFloat(avatarColor.colorArray[0])
            let green = CGFloat(avatarColor.colorArray[1])
            let blue = CGFloat(avatarColor.colorArray[2])
            let alpha = CGFloat(avatarColor.colorArray[3])
            
            return UIColor(red: red, green: green, blue: blue, alpha: alpha)
        } catch let err {
            print("\(TAG) failed to convert AvataColor from String to UIColor \(err)")
            return UIColor.lightGray
        }
    }
    
    func logout () {
        avatarName = ""
        name = ""
        avatarColor = ""
        email = ""
        id = ""
        AuthService.instance.authToken = ""
        AuthService.instance.userEmail = ""
        MessageService.instance.channels!.removeAll()
        AuthService.instance.isLoggedIn = false
    }
}

struct AvatarColor : Decodable {
    var colorArray : [Float]
}
