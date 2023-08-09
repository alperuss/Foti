
import Foundation
import UIKit
import Firebase
import FirebaseFirestore

class UserProfileController :  UICollectionViewController {
    let listPostCellID = "listPostCellID"
    var userID : String?
    var gridView = true
    let postCellID = "postCellID"
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        collectionView.backgroundColor = .white
       getUser()
        collectionView.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerID")
        collectionView.register(UserPostPhotoCell.self, forCellWithReuseIdentifier: postCellID)
        collectionView.register(MainPostCell.self, forCellWithReuseIdentifier: listPostCellID)
        
        btnLogOutCreate()
        
    }
    var posts = [Post]()
    fileprivate func getPostFS(){
//          guard let validUserID = Auth.auth().currentUser?.uid else {return}
        guard let validUserID = self.validUser?.userID else {return}
       
 
        Firestore.firestore().collection("Posts").document(validUserID).collection("Photo_Posts").order(by: "PostDate", descending: false)
            .addSnapshotListener { (querySnapshot, error) in
                if let error = error {
                    print("Error when getting posts : ",error)
                    return
                }
                querySnapshot?.documentChanges.forEach({ changes in
                    if changes.type == .added {
                        let postData = changes.document.data()
                        let post = Post(user: self.validUser! ,dictionaryData: postData)
                        self.posts.append(post)
                    }
                })
                //All posts transfer to posts array
                self.posts.reverse()
                self.collectionView.reloadData()
            }
    }
    fileprivate func btnLogOutCreate(){
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Settings")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(logOut))
        
    }
    
    @objc func logOut(){
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let actionLogOut = UIAlertAction(title: "Log Out", style: .destructive){(_) in
            
            guard let _ = Auth.auth().currentUser?.uid else {return}
            do{
                try Auth.auth().signOut()
                
                let signInController = SignInController()
                let navController = UINavigationController(rootViewController: signInController)
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true)
            }catch let logOutError {
                print("Error when log out" , logOutError)
            }
            }
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel,handler: nil)
        alertController.addAction(actionLogOut)
        alertController.addAction(actionCancel)
        present(alertController, animated: true,completion: nil)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if gridView {
            let width = (view.frame.width - 5 ) / 3
            return CGSize(width: width, height: width)
        } else{
            return CGSize(width: view.frame.width, height: view.frame.width+210)

        }
        
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let postCell = collectionView.dequeueReusableCell(withReuseIdentifier: postCellID, for: indexPath) as! UserPostPhotoCell
        if gridView {
            postCell.post = posts[indexPath.row]
            return postCell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: listPostCellID, for: indexPath) as! MainPostCell
            cell.post = posts[indexPath.row]
            return cell
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerID", for: indexPath) as! UserProfileHeader
        header.validUser = validUser
        header.delegate = self
        
        return header
    }
    
    var validUser : User?
    fileprivate func getUser(){
//        guard let validUserID = Auth.auth().currentUser?.uid else {return}
        let validUserID = userID ?? Auth.auth().currentUser?.uid ?? ""
        Firestore.firestore().collection("Users").document(validUserID).getDocument { (snapshot,error) in
            if let error = error{
                print("User data cant reached : ",error)
                return
            }
            guard let userData = snapshot?.data() else {return}
            //let userName = userData["Username "] as? String
            self.validUser = User(userData: userData)
            self.getPostFS()
            self.navigationItem.title = self.validUser?.userName
          
        }
    }
}

extension UserProfileController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
}
extension UserProfileController : UserProfileHeaderDelegate {
    func changeGridView() {
        gridView = true
        collectionView.reloadData()
    }
    func changeListView() {
        gridView = false
        collectionView.reloadData()
    }
}
