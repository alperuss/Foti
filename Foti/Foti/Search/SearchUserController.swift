

import UIKit
import Firebase
import FirebaseStorage
import FirebaseFirestore

class SearchUserController : UICollectionViewController, UISearchBarDelegate{
    
    lazy var searchBar : UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Enter username.... "
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.rgbConverter(red: 230, green: 230, blue: 230)
        sb.delegate = self
        return sb
    }()
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredUsers = users
        }
        else {
            self.filteredUsers = self.users.filter({ user in
                return user.userName.contains(searchText.lowercased())
            })
        }
        
        self.collectionView.reloadData()
    }
    let cellID = "cellID"
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        navigationController?.navigationBar.addSubview(searchBar)
        let navBar = navigationController?.navigationBar
        
        searchBar.anchor(top: navBar?.topAnchor, bottom: navBar?.bottomAnchor, leading: navBar?.leadingAnchor, trailing: navBar?.trailingAnchor, paddingTop:  0, paddingBottom: 0, paddingLeft: 10, paddingRight: -10, width: 0, height: 0)
        collectionView.register(SearchUserCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .onDrag
        getUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searchBar.isHidden = false
    }
    
    var filteredUsers = [User]()
    var users = [User]()
    fileprivate func getUsers(){
        Firestore.firestore().collection("Users").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error when get users \(error.localizedDescription)")
            }
            querySnapshot?.documentChanges.forEach({ change in
                if change.type == .added {
                    let user = User(userData: change.document.data())
                    if user.userID != Auth.auth().currentUser?.uid {
                        self.users.append(user)
                    }
                    
                }
            })
            self.users.sort { (k1, k2) -> Bool in
                return k1.userName.compare(k2.userName) == .orderedAscending
            }
            self.filteredUsers = self.users
            self.collectionView.reloadData()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! SearchUserCell
        
        cell.user = filteredUsers[indexPath.row]
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        searchBar.isHidden = true
        searchBar.resignFirstResponder()

        let user = filteredUsers[indexPath.row]
        print(user.userName)
       let userProfileController = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
        userProfileController.userID = user.userID
       navigationController?.pushViewController(userProfileController, animated: true)
        
    }
}
extension SearchUserController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 70)
    }
}
