
import Foundation
import UIKit
import Firebase
import FirebaseFirestore

class UserProfileController :  UICollectionViewController {
    
    let postCellID = "postCellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        getUser()
        collectionView.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerID")
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: postCellID)
        
        btnLogOutCreate()
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
        let width = (view.frame.width - 5 ) / 3
        return CGSize(width: width, height: width)
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let postCell = collectionView.dequeueReusableCell(withReuseIdentifier: postCellID, for: indexPath)
        postCell.backgroundColor = .blue
        return postCell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerID", for: indexPath) as! UserProfileHeader
        header.validUser = validUser
        
        return header
    }
    
    var validUser : User?
    fileprivate func getUser(){
        guard let signedUserId = Auth.auth().currentUser?.uid else {return}
        Firestore.firestore().collection("Users").document(signedUserId).getDocument { (snapshot,error) in
            if let error = error{
                print("User data cant reached : ",error)
                return
            }
            guard let userData = snapshot?.data() else {return}
            //let userName = userData["Username "] as? String
            self.validUser = User(userData: userData)
            self.collectionView.reloadData()
            self.navigationItem.title = self.validUser?.userName
          
        }
    }
}

extension UserProfileController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
}
