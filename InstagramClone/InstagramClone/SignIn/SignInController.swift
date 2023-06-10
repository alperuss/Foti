

import UIKit
import Firebase
import JGProgressHUD
class SignInController : UIViewController {
    
       
        let txtEmail : UITextField = {
            let txt = UITextField()
            txt.placeholder = "Enter Email address..."
            txt.backgroundColor = UIColor (white: 0, alpha: 0.05)
            txt.borderStyle = .roundedRect
            txt.font = UIFont.systemFont(ofSize: 16)
            txt.addTarget(self, action: #selector (changeData), for: .editingChanged)
            return txt
        }()
        
        let txtPassword : UITextField = {
            let txt = UITextField()
            txt.placeholder = "Enter Password..."
            txt.isSecureTextEntry = true
            txt.backgroundColor = UIColor (white: 0, alpha: 0.05)
            txt.borderStyle = .roundedRect
            txt.font = UIFont.systemFont (ofSize: 16)
            txt.addTarget(self, action: #selector (changeData), for: .editingChanged)

            return txt
        }()
        
        let btnSignIn : UIButton = {
            let btn = UIButton(type: .system)
            btn.setTitle("Sign In", for: .normal)
            btn.backgroundColor = UIColor.rgbConverter(red: 150, green: 205, blue: 245)
            btn.layer.cornerRadius = 6
            btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            btn.setTitleColor(.white, for: .normal)
            btn.addTarget(self, action: #selector(btnSignInPressed), for: .touchUpInside)
            btn.isEnabled = false
            return btn
        }()
        let logoView : UIView = {
            let view = UIView()
            let imgLogo = UIImageView(image: UIImage(named: "Logo_Instagram") )
            imgLogo.contentMode = .scaleAspectFill
            view.addSubview(imgLogo)
            imgLogo.anchor(top: nil, bottom: nil, leading: nil, trailing: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 200, height: 65)
            imgLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            imgLogo.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            view.backgroundColor = UIColor.rgbConverter(red: 0, green: 120, blue: 175)
            return view
        }()
        
        
        let btnRegister : UIButton = {
            
            let btn = UIButton(type: .system)
            let attrTitle = NSMutableAttributedString(string: "Do not have an account yet?",attributes: [
                                                                .font : UIFont.systemFont(ofSize: 16),
                                                                .foregroundColor : UIColor.lightGray])
            attrTitle.append(NSAttributedString(string: " Register",attributes: [
                .font : UIFont.boldSystemFont(ofSize: 16),
                .foregroundColor : UIColor.rgbConverter(red: 20, green: 155, blue: 235)
             ]))
            btn.setAttributedTitle(attrTitle, for: .normal)
            btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            btn.addTarget(self, action: #selector(btnRegisterPressed), for: .touchUpInside)
            return btn
        }()
    @objc fileprivate func btnSignInPressed(){
        guard let emailAddress = txtEmail.text , let password = txtPassword.text else { return }
        
        let hud = JGProgressHUD(style: .light)
        hud.textLabel.text = "Signing in ..."
        hud.show(in: self.view)
        
        Auth.auth().signIn(withEmail: emailAddress, password: password) { (result , error) in
            if let error = error {
                print("Error when signing in ", error)
                hud.dismiss(animated: true)
                let errorHud = JGProgressHUD(style: .light)
                errorHud.textLabel.text = "Error :  \(error.localizedDescription)"
                errorHud.show(in: self.view)
                errorHud.dismiss(afterDelay: 2)
                return
            }
            print("User successfully signed in.", result?.user.uid)
            
            let keyWindow = UIApplication.shared.connectedScenes.filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first
            guard let mainTabBarController = keyWindow?.rootViewController as? MainTabBarController else {return}
            mainTabBarController.createView() // go userprofileControler
            self.dismiss(animated: true)
            hud.dismiss(animated: true)
            
            let successfulHud = JGProgressHUD(style: .light)
            successfulHud.textLabel.text = "Successful"
            successfulHud.show(in: self.view)
            successfulHud.dismiss(afterDelay: 1)
            
        }
        
    }
        @objc fileprivate func changeData() {
            let validForm = (txtEmail.text?.count ?? 0) > 0 && (txtPassword.text?.count ?? 0 ) > 0
            if validForm{
                btnSignIn.isEnabled = true
                btnSignIn.backgroundColor = UIColor.rgbConverter(red: 20, green: 155, blue: 235)
            }
            else{
                btnSignIn.isEnabled = false
                btnSignIn.backgroundColor = UIColor.rgbConverter(red: 150, green: 205, blue: 245)
            }
            
        }
        @objc fileprivate func btnRegisterPressed(){
            let registerController = RegisterController()
            navigationController?.pushViewController(registerController, animated: true)
        }
        override var preferredStatusBarStyle : UIStatusBarStyle {
            return .lightContent
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            
            
            view.addSubview(logoView)
            logoView.anchor(top: view.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 150)
            navigationController?.isNavigationBarHidden = true
            view.backgroundColor = .white
            
            view.addSubview(btnRegister)
            btnRegister.anchor(top: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 50)
            createSignInScreen()
        }
        fileprivate func createSignInScreen(){
            let stackView = UIStackView(arrangedSubviews: [txtEmail,txtPassword,btnSignIn])
            stackView.axis = .vertical
            stackView.spacing = 10
            stackView.distribution = .fillEqually
            view.addSubview(stackView)
            
            stackView.anchor(top: logoView.bottomAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, paddingTop: 40, paddingBottom: 0, paddingLeft: 40, paddingRight: -40, width: 0, height: 185)
        }

}
