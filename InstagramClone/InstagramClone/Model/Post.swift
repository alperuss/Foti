//
//  Post.swift
//  InstagramClone
//
//  Created by Alper Us on 2023-06-11.
//

import Firebase
import FirebaseFirestore
struct Post {
    var id : String?
    let user : User
    let postImageURL : String?
    let imageWidth  : Double?
    let imageHeight : Double?
    let userID  : String?
    let message : String?
    let postDate : Timestamp
    
    init(user : User ,dictionaryData : [String : Any]) {
        self.user = user
        self.postImageURL = dictionaryData["PostImageURL"] as? String
        self.imageWidth = dictionaryData["ImageWidth"] as? Double
        self.imageHeight = dictionaryData["ImageHeight"] as? Double
        self.userID = dictionaryData["UserID"] as? String
        self.message = dictionaryData["Message"] as? String
        self.postDate = dictionaryData["PostDate"] as? Timestamp ?? Timestamp(date: Date())
        
    }
}

