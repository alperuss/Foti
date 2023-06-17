//
//  SharePhotoController.swift
//  InstagramClone
//
//  Created by Alper Us on 2023-06-11.
//

import UIKit
import JGProgressHUD
import Firebase
import FirebaseStorage
import FirebaseFirestore

class SharePhotoController : UIViewController {
    var chosenPhoto : UIImage?{
        didSet{
            self.imgPost.image = chosenPhoto
        }
    }
    let txtMessage : UITextView = {
        let txt = UITextView()
        txt.font = UIFont.systemFont(ofSize: 15)
        return txt
    }()
    let imgPost : UIImageView = {
        let img = UIImageView()
        img.backgroundColor = .blue
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        return img

    }()
    override var prefersStatusBarHidden: Bool{
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgbConverter(red: 100, green: 100, blue: 100)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(btnSharePressed))
        createMessageField()
    }
    fileprivate func createMessageField(){
        let postView = UIView()
        postView.backgroundColor = .white
        
        view.addSubview(postView)
        postView.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 120)
       
        view.addSubview(imgPost)
        imgPost.anchor(top: postView.topAnchor, bottom: postView.bottomAnchor, leading: postView.leadingAnchor, trailing: nil, paddingTop: 8, paddingBottom: -8, paddingLeft: 8, paddingRight: 0, width: 85, height: 0)
        
        view.addSubview(txtMessage)
        txtMessage.anchor(top: postView.topAnchor, bottom: postView.bottomAnchor, leading: imgPost.trailingAnchor, trailing: postView.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 5, paddingRight: 0, width: 0, height: 0)
    }
    @objc func btnSharePressed() {
        navigationItem.rightBarButtonItem?.isEnabled = false
        let hud = JGProgressHUD(style: .light)
        hud.textLabel.text = "Post Uploading"
        hud.show(in: self.view)
        
        let photoName = UUID().uuidString
        guard let postPhoto = chosenPhoto else {return}
        let photoData = postPhoto.jpegData(compressionQuality: 0.8) ?? Data()
        
        let ref = Storage.storage().reference(withPath: "/Posts/\(photoName)")
        
        ref.putData(photoData,metadata: nil) { (_,error) in
            if let error = error {
                self.navigationItem.rightBarButtonItem?.isEnabled = true

                print("Photo not saved",error)
                hud.textLabel.text = "Photo not uploaded"
                hud.dismiss(afterDelay: 2)
                return
            }
            print("Post successfully uploaded")
            ref.downloadURL { url, error in
                hud.textLabel.text = "Post Uploaded..."
                hud.dismiss(afterDelay: 2)
                if let error = error {
                    self.navigationItem.rightBarButtonItem?.isEnabled = false

                    print("Could not get url address : ",error)
                    return
                }
                print("Uploaded Photo URL Address : \(url?.absoluteString)")
                
                if let url = url {
                    self.savePostFS(imageURL: url.absoluteString)
                    
                }
                
            }
        }
    }
    static let updateNotification = Notification.Name("UpdatePosts")
    fileprivate func savePostFS(imageURL : String){
        guard let postPhoto = chosenPhoto else {return}
        guard let message = txtMessage.text,
              message.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 else {return}
        
        guard let validUserID = Auth.auth().currentUser?.uid else {return}
        let addData = ["UserID" : validUserID,
                       "PostImageURL" : imageURL,
                       "Message" : message,
                       "ImageWidth" : postPhoto.size.width,
                       "ImageHeight" : postPhoto.size.height,
                       "PostDate" : Timestamp(date: Date())] as [String : Any]
        
        var ref : DocumentReference? = nil
        ref = Firestore.firestore().collection("Posts").document(validUserID).collection("Photo_Posts")
            .addDocument(data: addData,completion: { error in
            if let error = error{
                self.navigationItem.rightBarButtonItem?.isEnabled = false
                print("Error occurred while saving share : ",error)
                
                return
            }
            print("Share successfully saved and Post Document ID : \(ref?.documentID)")
            self.dismiss(animated: true)
                
                NotificationCenter.default.post(name: SharePhotoController.updateNotification, object: nil)
        })
    }
    
}
