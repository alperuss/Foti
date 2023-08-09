//
//  CommentController.swift
//  InstagramClone
//
//  Created by Alper Us on 2023-06-17.
//

import UIKit
import Firebase
class CommentController : UICollectionViewController {
    var chosenPost : Post?
    let commentCellID = "CommentCellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Comments"

        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -80, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: -80, right: 0)
        collectionView.register(CommentCell.self, forCellWithReuseIdentifier: commentCellID)
        getComments()
        
        
    }
    
    var comments = [Comment]()
    fileprivate func getComments(){
        guard let postID = self.chosenPost?.id else {return}
        Firestore.firestore().collection("Comments").document(postID).collection("Adding_Comments")
            .addSnapshotListener { snapshot, error in
                if let error = error{
                    print("Error when getting comments", error.localizedDescription)
                    return
                }
                snapshot?.documentChanges.forEach({ documentChange in
                    let dictionaryData = documentChange.document.data()
                    
                    guard let userID = dictionaryData["UserID"] as? String else {return}
                    Firestore.createUser(userID: userID) { user in
                        let comment = Comment(user: user,dictionaryData: dictionaryData)
                        self.comments.append(comment)
                        self.collectionView.reloadData()
                    }
                    
                })
            }
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: commentCellID, for: indexPath) as! CommentCell
        cell.comment = comments[indexPath.row]
        return cell
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    lazy var containerView : UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.frame = CGRect(x: 0, y: 0, width: 150 , height: 80)
        
        let btnSendComment = UIButton(type: .system)
        btnSendComment.setTitle("Send", for: .normal)
        btnSendComment.setTitleColor(.black, for: .normal)
        btnSendComment.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        btnSendComment.addTarget(self, action: #selector(btnSendCommentPressed), for: .touchUpInside)
        
        containerView.addSubview(btnSendComment)
        btnSendComment.anchor(top:  containerView.safeAreaLayoutGuide.topAnchor, bottom: containerView.safeAreaLayoutGuide.bottomAnchor, leading: nil, trailing: containerView.safeAreaLayoutGuide.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 15, paddingRight: -15, width: 80, height: 0)
        
        
        containerView.addSubview(txtComment)
        txtComment.anchor(top: containerView.safeAreaLayoutGuide.topAnchor, bottom: containerView.safeAreaLayoutGuide.bottomAnchor, leading: containerView.safeAreaLayoutGuide.leadingAnchor, trailing: btnSendComment.leadingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        
        let braceView = UIView()
        braceView.backgroundColor = UIColor.rgbConverter(red: 230, green: 230, blue: 230)
        containerView.addSubview(braceView)
        braceView.anchor(top: containerView.topAnchor, bottom: nil, leading: containerView.leadingAnchor, trailing: containerView.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0.7)
        return containerView
        
    }()
    
    let txtComment : UITextField = {
        let txt = UITextField()
        txt.placeholder = "Write a comment..."
        return txt
    }()
    @objc fileprivate func btnSendCommentPressed(){
        if let comment = txtComment.text, comment.isEmpty{
            return
        }
        
        guard let validUserID = Auth.auth().currentUser?.uid else {return}
        let postID = self.chosenPost?.id ?? ""
        let addingValue = ["commentMessage":txtComment.text ?? "",
                           "Comment_Date": Date.timeIntervalSinceReferenceDate,
                           "UserID" : validUserID] as [String : Any]
        
        Firestore.firestore().collection("Comments").document(postID).collection("Adding_Comments")
            .document().setData(addingValue) { (error) in
                if let error = error {
                    print("Error when adding comment : ",error.localizedDescription)
                    return
                }
                print("Comment successfully added")
                self.txtComment.text = ""
            }
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return containerView
        }
    }
    override var canBecomeFirstResponder: Bool{
        return true
    }
}
extension CommentController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 60)
        let temporaryCell = CommentCell(frame: frame)
        temporaryCell.comment = comments[indexPath.row]
        temporaryCell.layoutIfNeeded()
        
        
        let targetSize = CGSize(width: view.frame.width, height: 9999)
        
        
        let estimatedSize = temporaryCell.systemLayoutSizeFitting(targetSize)
        
        let height = max(60, estimatedSize.height)
        return CGSize(width: view.frame.width, height: height)
        
    }
}
