import Foundation
import Alamofire
import SwiftyJSON
class AuthService {
    
    let TAG = "AUTHSERVICE"
    
    static let instance : AuthService = AuthService()
    
    var currentUser : UserDefaults = UserDefaults.standard
    
    var isLoggedIn : Bool {
        get {
            return currentUser.bool(forKey: LOGGED_IN_KEY)
        }
        set {
            currentUser.set(newValue, forKey: LOGGED_IN_KEY)
        }
    }
    
    var authToken : String {
        get {
            return currentUser.value(forKey: TOKEN_KEY) as! String
        }
        set {
            currentUser.set(newValue, forKey: TOKEN_KEY)
        }
    }
    
    var userEmail : String {
        get {
            return currentUser.value(forKey: USER_EMAIL) as! String
        }
        set {
            currentUser.set(newValue, forKey: USER_EMAIL)
        }
    }
    
    func registerUser (email : String, password : String, completion : @escaping completionHandler) {
        print("\(self.TAG) registerUser is running")
        let lowerCaseEmail = email.lowercased()
        let header = [
            "Content-Type" : "application/json; charset=utf-8"
        ]
        let body : [String : Any] = [
            "email" : lowerCaseEmail,
            "password" : password
        ]
        
        Alamofire.request(URL_REGISTER, method: .post, parameters: body, encoding: JSONEncoding.default,
                          headers: header).responseString {
                            (respond) in
                            if respond.result.error != nil {
                                completion(false)
                                print("\(self.TAG) Đăng ký thất bại rồi: \(respond.error!)")
                            }
                            else if respond.value != "Successfully created new account" {
                                completion(false)
                               print("\(self.TAG) Đăng ký thất bại rồi: \(respond.value)")
                            } else {
                                completion(true)
                                print("\(self.TAG) Đăng ký thành công \(respond.value)")
                            }
                
                          }
    }
    
    func loginUser (email : String, password : String, completion : @escaping completionHandler) {
        
        print("\(TAG) loginUser is running")
        let lowerCaseEmail = email.lowercased()
        let header = [
            "Content-Type" : "application/json; charset=utf-8"
        ]
        let body : [String : Any] = [
            "email" : lowerCaseEmail,
            "password" : password
        ]
        
        Alamofire.request(URL_LOGIN, method: .post, parameters: body, encoding: JSONEncoding.default, headers: header).responseJSON {
            (respond) in
            
            if (respond.result.error == nil) {
                    do {
                        guard let data = respond.data else { print("\(self.TAG) json data is nil")
                            completion(false)
                            return }
                        let loginRequest = try JSONDecoder().decode(LoginRequest.self, from: data)
                        self.authToken = loginRequest.token
                        self.userEmail = loginRequest.user
                        self.isLoggedIn = true
                        
                        print("\(self.TAG) login success, Authtoken: \(loginRequest.token)")
                        completion(true)
                        
                    } catch let err {
                        print("\(self.TAG) user login parse failed with an error: \(err)")
                        completion(false)
                    }
                } else {
                print("\(self.TAG) user login has an error: \(respond.result.error)")
                completion(false)
            }
        }
    
    }
    
    func createUser (userName : String, avatarColor : String, avatarName : String, email : String, completion : @escaping completionHandler ) {
        
        print("\(TAG) createUser is running")
        let lowerCaseEmail = email.lowercased()
        
        let header : [String : String] = [
            "Authorization" : "Bearer \(self.authToken)",
            "Content-Type" : "application/json; charset=utf-8" ]
        let body : [String : String] = [
            "name" : userName,
            "email" : lowerCaseEmail,
            "avatarName" : avatarName,
            "avatarColor" : avatarColor ]
        
        Alamofire.request(URL_ADDUSER, method: .post, parameters: body, encoding: JSONEncoding.default, headers: header).responseJSON {
            (respond) in
            if respond.result.error == nil {
                guard let data = respond.data, respond.data != nil else {
                    print("\(self.TAG) createUser failed, respond.data is nil")
                    return
                }
                do {
                let request : CreateUserRequest = try JSONDecoder().decode(CreateUserRequest.self, from: data)
                    
                    UserDataService.instance.setUserData(id: request._id, avatarColor: request.avatarColor, name: request.name, email: request.email, avatarName: request.avatarName)
                    print("\(self.TAG) createUser success with id: \(request._id)")
                    completion(true)
                } catch let err {
                    debugPrint(err)
                }
                
            } else {
                completion(false)
                debugPrint(respond.result.error as Any)
            }
        }
    }
}


struct CreateUserRequest : Decodable {
    var __v : Int
    var avatarColor : String
    var avatarName : String
    var email : String
    var name : String
    var _id : String
}

struct LoginRequest : Decodable {
    var user : String
    var token : String
}
