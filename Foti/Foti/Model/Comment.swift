//
//  Comment.swift
//  InstagramClone
//
//  Created by Alper Us on 2023-06-18.
//

import Foundation

struct Comment {
    let  user : User
    let commentMessage : String
    let userID : String
    init(user : User,dictionaryData : [String : Any]){
        self.user = user
        self.commentMessage = dictionaryData["commentMessage"] as? String ?? ""
        self.userID = dictionaryData["UserID"] as? String ?? ""
    }
}
