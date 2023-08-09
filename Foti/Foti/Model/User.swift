

import Foundation

struct User {
    let userName : String
    let userID : String
    let profilePhotoURL : String
    init(userData : [String : Any]){
        self.userName = userData["Username"] as? String ?? ""
        self.userID = userData["UserID"] as? String ?? ""
        self.profilePhotoURL = userData["ProfilePhotoURL"] as? String ?? ""
    }
}
