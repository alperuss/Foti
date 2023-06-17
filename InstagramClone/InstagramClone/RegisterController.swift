
import UIKit
import Firebase
import JGProgressHUD
import FirebaseFirestore

class RegisterController: UIViewController {
    
    let btnAddPhoto : UIButton = {
        
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(imageLiteralResourceName: "Add_Photo").withRenderingMode(.alwaysOriginal), for: .normal)
        //btn.backgroundColor = .yellow
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        btn.addTarget(self, action: #selector(btnAddPhotoPressed), for: .touchUpInside)
        return btn
        
    }()
    
    @objc fileprivate func btnAddPhotoPressed(){
        let imgPickerController = UIImagePickerController()
        imgPickerController.delegate = self
        
        present(imgPickerController, animated: true, completion: nil)
    }
    
    
    let txtEmail : UITextField = {
        let txt = UITextField()
        txt.placeholder = "Enter your E-mail address"
        txt.backgroundColor = UIColor(white: 0, alpha: 0.05)
        txt.font = UIFont.systemFont(ofSize: 16)
        txt.borderStyle = .roundedRect
        
        txt.addTarget(self, action: #selector(dataChange), for: .editingChanged)
        return txt
    }()
    
    @objc fileprivate func dataChange(){
        let formIsValid = (txtEmail.text?.count ?? 0) > 0
        && (txtUserName.text?.count ?? 0) > 0
        && (txtPassword.text?.count ?? 0) > 0
        
        if formIsValid {
            btnSignUp.isEnabled = true
            btnSignUp.backgroundColor = UIColor.rgbConverter(red: 40, green: 100, blue: 245)
        }
        else
        {
            btnSignUp.isEnabled = false
            btnSignUp.backgroundColor = UIColor.rgbConverter(red: 150, green: 200, blue: 245)
        }
    }
    
    
    let txtUserName : UITextField = {
        let txt = UITextField()
        txt.placeholder = "Enter your Username"
        txt.backgroundColor = UIColor(white: 0, alpha: 0.05)
        txt.font = UIFont.systemFont(ofSize: 16)
        txt.borderStyle = .roundedRect
        
        txt.addTarget(self, action: #selector(dataChange), for: .editingChanged)
        return txt
    }()
    let txtPassword : UITextField = {
        let txt = UITextField()
        txt.placeholder = "Enter your Password"
        txt.backgroundColor = UIColor(white: 0, alpha: 0.05 )
        txt.isSecureTextEntry = true
        txt.font = UIFont.systemFont(ofSize: 16)
        txt.borderStyle = .roundedRect
        txt.addTarget(self, action: #selector(dataChange), for: .editingChanged)

        return txt
    }()
    let btnSignUp : UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Sign Up", for: .normal)
        btn.backgroundColor = UIColor.rgbConverter(red: 150, green: 200, blue: 245)
        btn.layer.cornerRadius = 6
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.setTitleColor(.white, for: .normal )
        btn.addTarget(self, action: #selector(btnSignUpPressed), for: .touchUpInside)
        btn.isEnabled = false
        return btn
    }()
    
    @objc fileprivate func btnSignUpPressed()  {
        
        guard let emailAddress = txtEmail.text else {return}
        guard let userName = txtUserName.text else {return}
        guard let password = txtPassword.text else {return}
        
        
        
        let hud = JGProgressHUD(style: .light)
        hud.textLabel.text = "Signing..."
        hud.show(in: self.view)

        Auth.auth().createUser(withEmail: emailAddress, password: password ) {(result,error) in
            if let error = error{
                print("user error when sign up",error)
                hud.dismiss(animated: true)
 
                return
            }
            
            guard let signedUserId = result?.user.uid else {return}

            let photoName = UUID().uuidString // random string value
            let ref =  Storage.storage().reference(withPath: "/ProfilePhotos/\(photoName)")
            let photoData = self.btnAddPhoto.imageView?.image?.jpegData(compressionQuality: 0.8) ?? Data()
            ref.putData(photoData,metadata: nil) {(_ , error) in
                if let error = error {
                    print("Photo not saved.", error)
                    return
                }
                print("Photo successfully saved.")
                
                ref.downloadURL { (url, error) in
                    if let error = error {
                        print("Photo URL not found : ", error)
                        return
                    }
                    print("Photo URL :\(url?.absoluteString ?? "No Link")")
                    
                    let addData = ["Username" : userName,
                                   "UserID" : signedUserId,
                                   "ProfilePhotoURL" : url?.absoluteString ?? ""]
                    
                    Firestore.firestore().collection("Users").document(signedUserId).setData(addData) { error in
                        if let error = error {
                            print("User data couldnt upload to firestore.", error)
                            return
                        }
                        print("User data successfully uploaded")
                        hud.dismiss(animated: true)
                        self.clearView()
                        let keyWindow = UIApplication.shared.connectedScenes.filter({$0.activationState == .foregroundActive})
                            .map({$0 as? UIWindowScene})
                            .compactMap({$0})
                            .first?.windows
                            .filter({$0.isKeyWindow}).first
                        guard let mainTabBarController = keyWindow?.rootViewController as? MainTabBarController else {return}
                        mainTabBarController.createView() // go userprofileControler
                        self.dismiss(animated: true)
                        
                    }
                }

            }
            
            print("Succesfully registered",result?.user.uid)
            
        }
        
    }
    
    fileprivate func clearView(){
        self.btnAddPhoto.setImage(UIImage(named: "Add_Photo"), for: .normal)
        self.btnAddPhoto.layer.borderColor = UIColor.clear.cgColor
        self.btnAddPhoto.layer.borderWidth = 0
        self.txtEmail.text = ""
        self.txtUserName.text = ""
        self.txtPassword.text = ""
        let successfulHud = JGProgressHUD(style: .light)
        successfulHud.textLabel.text = "Successfully signed up..."
        successfulHud.show(in: self.view)
        successfulHud.dismiss(afterDelay: 2)
    }
    
    let haveAccount : UIButton = {
        let btn = UIButton(type: .system)
        let attrTitle = NSMutableAttributedString(string: "Do you already have an account?",attributes: [
            .font : UIFont.systemFont(ofSize: 16),
            .foregroundColor : UIColor.lightGray])
        attrTitle.append(NSAttributedString(string: " Sign In",attributes: [
            .font : UIFont.boldSystemFont(ofSize: 16),
            .foregroundColor : UIColor.rgbConverter(red: 20, green: 155, blue: 235)]))
        
        btn.setAttributedTitle(attrTitle, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.addTarget(self, action: #selector(btnHaveAccountPressed), for: .touchUpInside)
        return btn
                                             
    }()
    @objc fileprivate func btnHaveAccountPressed(){
        navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(haveAccount)
        haveAccount.anchor(top: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 60)
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        
        view.addSubview(btnAddPhoto)
        // Do any additional setup after loading the view.
        btnAddPhoto.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: nil, trailing: nil, paddingTop: 40, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 150, height: 150)
        
        btnAddPhoto.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
        
        createEntry()
    }
    
    fileprivate func createEntry() {
        let stackView = UIStackView(arrangedSubviews: [txtEmail,txtUserName,txtPassword,btnSignUp])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        view.addSubview(stackView)
        
        
        stackView.anchor(top: btnAddPhoto.bottomAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, paddingTop: 40, paddingBottom: 0, paddingLeft: 45, paddingRight: -45,width: 0,height: 230)
    }


}

extension UIView {
    func anchor(top: NSLayoutYAxisAnchor?,
                bottom : NSLayoutYAxisAnchor?,
                leading : NSLayoutXAxisAnchor?,
                trailing : NSLayoutXAxisAnchor?,
                paddingTop : CGFloat,
                paddingBottom : CGFloat,
                paddingLeft : CGFloat,
                paddingRight : CGFloat,
                width : CGFloat,
                height : CGFloat){
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: paddingBottom).isActive = true
        }
        if let leading = leading {
            self.leadingAnchor.constraint(equalTo: leading, constant: paddingLeft).isActive = true
        }
        if let trailing = trailing {
            self.trailingAnchor.constraint(equalTo: trailing, constant: paddingRight).isActive = true
        }
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}

extension RegisterController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //didcancel
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true,completion: nil )
    }
    //didfinishpicking
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imagePick = info[.originalImage] as? UIImage
        self.btnAddPhoto.setImage(imagePick?.withRenderingMode(.alwaysOriginal), for: .normal)
        btnAddPhoto.layer.cornerRadius = btnAddPhoto.frame.width / 2 //(square to round)
        btnAddPhoto.layer.masksToBounds = true //cut frames
        btnAddPhoto.layer.borderColor = UIColor.darkGray.cgColor
        btnAddPhoto.layer.borderWidth = 3
        
        dismiss(animated: true, completion: nil)
    }
}
