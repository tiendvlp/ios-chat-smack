import Foundation

typealias completionHandler = (_ isSuccess : Bool) -> ()

let URL_BASE = "https://mintinchatapp.herokuapp.com/"
let URL_REGISTER = "\(URL_BASE)v1/account/register"
let URL_LOGIN = "\(URL_BASE)v1/account/login"
let URL_ADDUSER = "\(URL_BASE)v1/user/add"

let TOKEN_KEY = "token"
let LOGGED_IN_KEY = "loggedIn"
let USER_EMAIL = "userEmail"
