

import Foundation
import UIKit
import Firebase

class MainTabBarController : UITabBarController{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let signInController = SignInController()
                let navController = UINavigationController(rootViewController: signInController)
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true)
            }
            return
        }
        
       createView()
    }
    func createView() {
        
        let mainNavController = createNavController(notSelectedIcon: UIImage(imageLiteralResourceName: "Main_Screen_Not_Selected"), selectedIcon: UIImage(imageLiteralResourceName: "Main_Screen_Selected"),rootViewController: MainController(collectionViewLayout: UICollectionViewFlowLayout()))
        let searchNavController = createNavController(notSelectedIcon: UIImage(imageLiteralResourceName: "Search_Not_Selected"), selectedIcon: UIImage(imageLiteralResourceName: "Search_Selected"),rootViewController: SearchUserController(collectionViewLayout: UICollectionViewFlowLayout()))
        let addNavController = createNavController(notSelectedIcon: UIImage(imageLiteralResourceName: "Add_Not_Selected"), selectedIcon: UIImage(imageLiteralResourceName: "Add_Not_Selected"))
//        let likeNavController = createNavController(notSelectedIcon: UIImage(imageLiteralResourceName: "Like_Not_Selected"), selectedIcon: UIImage(imageLiteralResourceName: "Like_Selected"))
//        let likeNavController = createNavController(notSelectedIcon: UIImage(imageLiteralResourceName: "Main_Screen_Not_Selected"), selectedIcon: UIImage(imageLiteralResourceName: "Main_Screen_Selected"),rootViewController: MainController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        
        let layout = UICollectionViewFlowLayout()
        let userProfileController = UserProfileController(collectionViewLayout: layout )
        let userProfileNavController = UINavigationController(rootViewController: userProfileController)
        userProfileNavController.tabBarItem.image = UIImage(named: "Profile")
        userProfileNavController.tabBarItem.selectedImage = UIImage(named: "Profile_Selected")
        tabBar.tintColor = .black
        viewControllers = [mainNavController,searchNavController,addNavController ,userProfileNavController]
        
        guard let items = tabBar.items else {return}
        
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        }
    }
    
    fileprivate func createNavController(notSelectedIcon : UIImage,selectedIcon : UIImage,rootViewController : UIViewController = UIViewController())-> UINavigationController{
        let rootController = rootViewController
        let navController = UINavigationController(rootViewController: rootController)
        navController.tabBarItem.image = notSelectedIcon
        navController.tabBarItem.selectedImage = selectedIcon
        return navController
        
    }
    
}
extension MainTabBarController : UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let index = viewControllers?.firstIndex(of: viewController) else {return true}
            if index == 2 {
                let layout = UICollectionViewFlowLayout()
                let photoChooseController = PhotoChooseController(collectionViewLayout: layout)
                let navController = UINavigationController(rootViewController: photoChooseController)
                navController.modalPresentationStyle = .fullScreen
                present(navController, animated: true)
                return false
            }

        return true
    }
}
