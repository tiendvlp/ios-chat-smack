import Foundation
import Alamofire

class MessageService {
    let TAG = "MESSAGESERVICE"
    static let instance : MessageService = MessageService()
    var channels : [Channel] = []
    var messages : [Message] = []
    var selectedChannel : Channel? = nil
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(MessageService.onUserDataChanged), name: NSNotification.Name(rawValue: UserDataChangedListener), object: nil)
    }
   
    
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
    
    @objc
    func onUserDataChanged () {
        if AuthService.instance.isLoggedIn {
            
        } else {
            channels.removeAll()
            messages.removeAll()
            selectedChannel = nil
        }
    }
    
    func findAllMessageInSpecificChannel (channelId : String, completion : @escaping completionHandler) {
        let header : Dictionary<String, String> = [
            "Authorization" : "Bearer \(AuthService.instance.authToken)"]
        
        
        Alamofire.request("\(URL_FIND_ALL_MESSAGE)\(channelId)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON(completionHandler: {
            respond in
            
            if (respond.result.error == nil) {
                self.messages.removeAll()
                do {
                    let request : [Message] = try JSONDecoder().decode([Message].self, from: respond.data!)
                    self.messages.append(contentsOf: request)
                    completion(true)
                    print("lay tin nhan thanh cong")
                }
                catch let err {
                    
                    print("lay tin nhan that bai \(err)")
                    completion(false)
                    print(err)
                }
            } else {

                print("lay tin nhan that bai \(respond.error)")
                completion(false)
                print(respond.error as Any)
            }
        })
        
    }

}
