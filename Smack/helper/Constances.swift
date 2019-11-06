import Foundation

typealias completionHandler = (_ isSuccess : Bool) -> ()
typealias completionGetUserHandler = (_ isSuccess : Bool,  _ user : FindUserByEmailRequest?) -> ()

let URL_BASE = "https://mintinchatapp.herokuapp.com/"
let URL_FIND_All_CHANNEL = "\(URL_BASE)v1/channel"
let URL_REGISTER = "\(URL_BASE)v1/account/register"
let URL_LOGIN = "\(URL_BASE)v1/account/login"
let URL_ADDUSER = "\(URL_BASE)v1/user/add"
let URL_FINDUSER_BYID = "\(URL_BASE)v1/user/byEmail/"
let URL_FIND_ALL_MESSAGE = "\(URL_BASE)v1/message/byChannel/"

let TOKEN_KEY = "token"
let LOGGED_IN_KEY = "loggedIn"
let USER_EMAIL = "userEmail"

// notification name
let UserDataChangedListener = "UserDataHasChanged"

let OnChannelSelectedListener = NSNotification.Name(rawValue: "UserSelectChannel")

let OnChannelCreatedListener = NSNotification.Name(rawValue: "UserCreateChannel")

let OnChannelResetedListener = NSNotification.Name(rawValue: "ChannelWasReseted")


