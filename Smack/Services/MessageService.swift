import Foundation
import Alamofire

class MessageService {
    let TAG = "MESSAGESERVICE"
    static let instance : MessageService = MessageService()
    var channels : [Channel]?
    var messages : [Messages]? = [
        Messages(userName: "Minhtien", userAvatar: "light12", chatMessage: "tieajsbjahd ashjdbsdhsd shbhsbd shdbshbd shdbshbd sdhbshdb shdbhsbd shdbshbd hsdhsd shdbhsbd shdbshdb shbdhsbd shdbshbd shbdhsbd shdbshd hsdshd hsbdhsd n dang 912001", date: "19/09/2019")
    ]
    
    func findAllChannels (completionHandler : @escaping completionHandler) {
        print("run \(AuthService.instance.authToken)")
        let header : Dictionary<String, String> = [
            "Authorization" : "Bearer \(AuthService.instance.authToken)"]
        
        Alamofire.request(URL_FIND_All_CHANNEL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON(completionHandler: {
            (respond) in
            
            if respond.result.error == nil {
                do {
                    let channelResquested = try JSONDecoder().decode([Channel].self, from: respond.data!)
                    self.channels = channelResquested
                    print({"\(self.TAG) getChannel successfully"})
                    completionHandler(true)
                } catch let err {
                    completionHandler(false)
                    print("\(self.TAG) cast failed \(err as Any)")
                }
            } else {
                completionHandler(false)
                print("\(self.TAG) send request failed \(respond.result.error as Any)")
            }
        })
        
        
    }
}
