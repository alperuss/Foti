

import UIKit
import Firebase
import FirebaseFirestore
class MainController : UICollectionViewController {
    let cellID = "cellID"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        collectionView.register(MainPostCell.self, forCellWithReuseIdentifier: cellID)
        editNavigationBar()
        getUser()
    }
    var posts = [Post]()
    fileprivate func getPosts(){
        posts.removeAll()
        guard let validUserID = Auth.auth().currentUser?.uid else {return}
        guard let validUser = validUser else {return}
        Firestore.firestore().collection("Posts").document(validUserID).collection("Photo_Posts").order(by: "PostDate", descending: false)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error when getting posts", error.localizedDescription)
                    return
                }
                querySnapshot?.documentChanges.forEach({ changes in
                    if changes.type == .added {
                        let postData = changes.document.data()
                        let post = Post(user: validUser,dictionaryData: postData)
                        self.posts.append(post)
                    }
                })
                self.posts.reverse()
                self.collectionView.reloadData()
            }
    }
    fileprivate func editNavigationBar(){
        navigationItem.titleView = UIImageView(image: UIImage(named: "Logo_Instagram2"))
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! MainPostCell
        cell.post = posts[indexPath.row]
        return cell
    }
    var validUser : User?
    fileprivate func getUser(){
        guard let validUser = Auth.auth().currentUser?.uid else {return}
        Firestore.firestore().collection("Users").document(validUser).getDocument { snapshot, error in
            if let error = error {
                print("Error when getting User info",error)
                return
            }
            guard let userData = snapshot?.data() else {return}
            self.validUser = User(userData: userData)
            self.getPosts()
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

