//
//  Extension+Firestore.swift
//  InstagramClone
//
//  Created by Alper Us on 2023-06-16.
//

import Firebase
import FirebaseFirestore

extension Firestore {
    static func createUser(userID : String = "", completion : @escaping (User) -> ()) {
        
        var uID = ""
        if userID == "" {
            guard let validUserID = Auth.auth().currentUser?.uid else { return }
            uID = validUserID
        } else {
            uID = userID
        }
        
        Firestore.firestore().collection("Users").document(uID).getDocument { (snapshot, error) in
            if let error = error {
                print("Cant get users info : ",error.localizedDescription)
                return
            }
            guard let userData = snapshot?.data() else { return }
            let user = User(userData: userData)
            completion(user)
        }
    }
    
}
