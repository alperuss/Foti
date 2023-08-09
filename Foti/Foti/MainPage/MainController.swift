

import UIKit
import Firebase
import FirebaseFirestore
class MainController : UICollectionViewController {
    let cellID = "cellID"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshPosts), name: SharePhotoController.updateNotification, object: nil )
        
        collectionView.backgroundColor = .white
        collectionView.register(MainPostCell.self, forCellWithReuseIdentifier: cellID)
        editNavigationBar()
        getUser()
        getFollowedUserValue()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshPosts), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    @objc func refreshPosts(){
        posts.removeAll()
        collectionView.reloadData()
        getFollowedUserValue()
        getUser()
    }
    
    fileprivate func getFollowedUserValue(){
        guard let uID = Auth.auth().currentUser?.uid else {return}
        Firestore.firestore().collection("Follows").document(uID).addSnapshotListener { (documentSnapshot, error) in
            if let error = error {
                print("Error when getting posts", error.localizedDescription)
                return
            }
            guard let postDictionaryData = documentSnapshot?.data() else {return}
            postDictionaryData.forEach { (key,value) in
                Firestore.createUser(userID: key) { (user) in
                    self.getPosts(user: user)
                }
            }
        }
    }
    
    var posts = [Post]()
    fileprivate func getPosts(user : User){
        
        Firestore.firestore().collection("Posts").document(user.userID).collection("Photo_Posts").order(by: "PostDate", descending: false)
            .addSnapshotListener { querySnapshot, error in
                self.collectionView.refreshControl?.endRefreshing()
                if let error = error {
                    print("Error when getting posts", error.localizedDescription)
                    return
                }
                querySnapshot?.documentChanges.forEach({ changes in
                    if changes.type == .added {
                        let postData = changes.document.data()
                        var post = Post(user: user,dictionaryData: postData)
                        post.id = changes.document.documentID
                        
                        guard let validUserID = Auth.auth().currentUser?.uid else { return }
                        
                        guard let postID = post.id else { return }
                        
                        Firestore.firestore().collection("Likes").document(postID).getDocument { snapShot, error in
                            if let error = error {
                                print("Error when get like data", error.localizedDescription)
                                return
                            }
                            let likeData = snapShot?.data()
                            if let likeValue = likeData?[validUserID] as? Int , likeValue == 1 {
                                post.liked = true
                            }
                            else{
                                post.liked = false
                            }
                            self.posts.append(post)
                            self.posts.reverse()
                            self.posts.sort { (p1, p2) -> Bool in
                                return p1.postDate.dateValue().compare(p2.postDate.dateValue()) == .orderedDescending
                            }
                            self.collectionView.reloadData()
                        }
                        
                        
                    }
                })
               
            }
    }
    fileprivate func editNavigationBar(){
//        navigationItem.titleView = UIImageView(image: UIImage(named: "Logo_Instagram2"))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Camera")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(cameraManage))
    }
    @objc func cameraManage(){
        let cameraController = CameraController()
        cameraController.modalPresentationStyle = .fullScreen
        present(cameraController, animated: true)
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! MainPostCell
        cell.post = posts[indexPath.row]
        cell.delegate = self
        return cell
    }
    var validUser : User?
    fileprivate func getUser(userID : String = ""){
        
        guard let validUser = Auth.auth().currentUser?.uid else {return}
        let uID = userID == "" ? validUser : userID
        Firestore.firestore().collection("Users").document(uID).getDocument { snapshot, error in
            if let error = error {
                print("Error when getting User info",error)
                return
            }
            guard let userData = snapshot?.data() else {return}
            self.validUser = User(userData: userData)
            guard let user = self.validUser else {return}
            self.getPosts(user: user)
        }
    }
}
    extension MainController : UICollectionViewDelegateFlowLayout {
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            var height : CGFloat = 55
            height += view.frame.width
            height += 50
            height += 70
            return CGSize(width: view.frame.width, height: height )
        }
    }

extension MainController : MainPostCellDelegate {
    func postLiked(cell: MainPostCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        var post = self.posts[indexPath.row]
        
        guard let postID = post.id else { return }
        
        guard let validUserID = Auth.auth().currentUser?.uid else { return }
        
        let addValue = [validUserID : post.liked == true ? 0 : 1]
        
        Firestore.firestore().collection("Likes").document(postID).getDocument { (snapshot, error) in
            
            if let error = error {
                print("Error when get like data : \(error.localizedDescription)")
                return
            }
            
            if snapshot?.exists == true {
                Firestore.firestore().collection("Likes").document(postID).updateData(addValue) { (error) in
                    if let error = error {
                        print("Like update fail : ",error.localizedDescription)
                        return
                    }
                    
                    print("Liked Post")
                    post.liked = !post.liked
                    self.posts[indexPath.row] = post
                    self.collectionView.reloadItems(at: [indexPath])
                }
            } else {
                Firestore.firestore().collection("Likes").document(postID).setData(addValue) { (error) in
                    if let error = error {
                        print("Like data save fail : \(error.localizedDescription)")
                        return
                    }
                    print("Like Successfully")
                    post.liked = !post.liked
                    self.posts[indexPath.row] = post
                    self.collectionView.reloadItems(at: [indexPath])
                }
            }
        }
        
    }
    func pressedComment(post : Post) {
        print(post.message)
        let commentController = CommentController(collectionViewLayout: UICollectionViewFlowLayout())
        commentController.chosenPost = post
        navigationController?.pushViewController(commentController, animated: true)
    }
}
