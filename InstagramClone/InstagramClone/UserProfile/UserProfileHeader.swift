

import Foundation
import UIKit
import Firebase
import FirebaseFirestore
import SDWebImage

class UserProfileHeader : UICollectionViewCell {
    
    var validUser : User? {
        didSet{
            followButton()
            guard let url = URL(string: validUser?.profilePhotoURL ?? "") else {return}
            imgProfilePhoto.sd_setImage(with: url,completed: nil)
            labelUsername.text = validUser?.userName
        }
    }
    fileprivate func followButton() {
        guard let accountUserID = Auth.auth().currentUser?.uid else {return}
        guard let validUserID = validUser?.userID else {return}
        
        if accountUserID != validUserID {
            Firestore.firestore().collection("Follows").document(accountUserID).getDocument{ (snapShot, error) in
                if let error = error {
                    print("Follow data doesn't get :", error.localizedDescription)
                    return
                }
                guard let followDatas = snapShot?.data() else {return}
                
                if let data = followDatas[validUserID] {
                    let follow = data as! Int
                    print(follow)
                    if follow == 1 {
                        self.btnEditProfile.setTitle("Unfollow", for: .normal)
                    }
                }
                else {
                    self.btnEditProfile.setTitle("Follow", for: .normal)
                    self.btnEditProfile.backgroundColor = UIColor.rgbConverter(red: 100, green: 75, blue: 235)
                    self.btnEditProfile.setTitleColor(.white, for: .normal)
                    self.btnEditProfile.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
                    self.btnEditProfile.layer.borderWidth = 1
                }
            }
        }
        else {
            self.btnEditProfile.setTitle("Edit Profile", for: .normal)
        }
    }
    lazy var btnEditProfile : UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        btn.layer.borderColor = UIColor.lightGray.cgColor
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 5
        btn.addTarget(self, action: #selector(btnProfile_Follow_Edit), for: .touchUpInside)
        return btn
    }()
    @objc fileprivate func btnProfile_Follow_Edit() {
        guard let accountUserID = Auth.auth().currentUser?.uid else {return}
        guard let validUserID = validUser?.userID else {return}
        
        
        
        if btnEditProfile.titleLabel?.text == "Unfollow" {
            Firestore.firestore().collection("Follows").document(accountUserID).updateData([validUserID : FieldValue.delete()]) { (error) in
                if let error = error {
                    print("Error when unfollow: \(error.localizedDescription)")
                    return
                }
                
                print("\(self.validUser?.userName ?? "") unfollowed")
                self.btnEditProfile.backgroundColor = UIColor.rgbConverter(red: 20, green: 155, blue: 240)
                self.btnEditProfile.setTitleColor(.white, for: .normal)
                self.btnEditProfile.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
                self.btnEditProfile.layer.borderWidth = 1
                self.btnEditProfile.setTitle("Follow", for: .normal)
            }
            return
        }
        let addValue = [validUserID : 1]
        
        
        Firestore.firestore().collection("Follows").document(accountUserID).getDocument{ (snapShot, error) in
            if let error = error {
                print("Follow data doesn't get :", error.localizedDescription)
                return
            }
        
            if snapShot?.exists == true {
                Firestore.firestore().collection("Follows").document(accountUserID).updateData(addValue){
                    error in
                    if let error = error {
                        print("Follow data doesn't update :", error.localizedDescription)
                        return
                    }
                    print("Follow Successful")
                    self.btnEditProfile.setTitle("Unfollow", for: .normal)
                    self.btnEditProfile.setTitleColor(.black, for: .normal)
                    self.btnEditProfile.backgroundColor = .white
                    self.btnEditProfile.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
                    self.btnEditProfile.layer.borderColor = UIColor.lightGray.cgColor
                    self.btnEditProfile.layer.borderWidth = 1
                    self.btnEditProfile.layer.cornerRadius = 5
                }
            }
            else{
                Firestore.firestore().collection("Follows").document(accountUserID).setData(addValue){
                    error in
                    if let error = error {
                        print("Follow data doesn't save :", error.localizedDescription)
                        return
                    }
                    print("Follow Successful")
                }
            }
        }
    }
                                                                                        
    let labelPost : UILabel = {
        let label = UILabel()
        let attrText = NSMutableAttributedString(string: "10\n",attributes: [.font : UIFont.boldSystemFont(ofSize: 15)])
        attrText.append(NSAttributedString(string: "Posts", attributes: [
            .foregroundColor : UIColor.darkGray,
            .font : UIFont.systemFont(ofSize: 15)
        ]))
        label.attributedText = attrText
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    let labelFollower : UILabel = {
        let label = UILabel()
        let attrText = NSMutableAttributedString(string: "25\n",attributes: [.font : UIFont.boldSystemFont(ofSize: 15)])
        attrText.append(NSAttributedString(string: "Followers", attributes: [
            .foregroundColor : UIColor.darkGray,
            .font : UIFont.systemFont(ofSize: 15)
        ]))
        label.attributedText = attrText
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    let labelFollow : UILabel = {
        let label = UILabel()
        let attrText = NSMutableAttributedString(string: "20\n",attributes: [.font : UIFont.boldSystemFont(ofSize: 15)])
        attrText.append(NSAttributedString(string: "Follows", attributes: [
            .foregroundColor : UIColor.darkGray,
            .font : UIFont.systemFont(ofSize: 15)
        ]))
        label.attributedText = attrText
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    let labelUsername : UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    let btnGrid : UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "Grid"), for: .normal)
        return btn
    }()
    let btnList : UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "List"), for: .normal)
        btn.tintColor = UIColor(white: 0, alpha: 0.2)
        return btn
    }()
    let btnSaved : UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "Saved"), for: .normal)
        btn.tintColor = UIColor(white: 0, alpha: 0.2)

        return btn
    }()
    
    
    let imgProfilePhoto : UIImageView = {
        let img = UIImageView()
        img.backgroundColor = .yellow
        return img
    }()
    
 override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imgProfilePhoto)
        let photoLayout : CGFloat = 90
     
     imgProfilePhoto.anchor(top: topAnchor, bottom: nil, leading: self.leadingAnchor, trailing: nil, paddingTop: 15, paddingBottom: 0, paddingLeft: 15, paddingRight: 0, width: photoLayout, height: photoLayout)
     
     imgProfilePhoto.layer.cornerRadius = photoLayout / 2
     imgProfilePhoto.clipsToBounds = true
     
     toolBarCreate()
     addSubview(labelUsername)
     
     labelUsername.anchor(top: imgProfilePhoto.bottomAnchor, bottom: btnGrid.topAnchor, leading: leadingAnchor, trailing: trailingAnchor, paddingTop: 5, paddingBottom: 0, paddingLeft: 15, paddingRight: 15, width: 0, height: 0)
     
     userStatusInfo()
     
     addSubview(btnEditProfile)
     btnEditProfile.anchor(top: labelPost.bottomAnchor, bottom: nil, leading: labelPost.leadingAnchor, trailing:labelFollow.trailingAnchor  , paddingTop: 10, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 35)
    }
    fileprivate func userStatusInfo(){
        let stackView = UIStackView(arrangedSubviews: [labelPost,labelFollower,labelFollow])
        addSubview(stackView)
        stackView.distribution = .fillEqually
        stackView.anchor(top: topAnchor, bottom: nil, leading: imgProfilePhoto.trailingAnchor, trailing: trailingAnchor, paddingTop: 15, paddingBottom: 0, paddingLeft: 15, paddingRight: -15, width: 0, height: 50)
    }
    
    fileprivate func toolBarCreate(){
        
        let topBraceView = UIView()
        topBraceView.backgroundColor = UIColor.lightGray
        
        let bottomBraceView = UIView()
        bottomBraceView.backgroundColor = UIColor.lightGray
        
        let stackView = UIStackView(arrangedSubviews: [btnGrid,btnList,btnSaved])
        addSubview(stackView)
        addSubview(topBraceView)
        addSubview(bottomBraceView)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.anchor(top: nil, bottom: self.bottomAnchor, leading: self.leadingAnchor, trailing: self.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 60)
        topBraceView.anchor(top: stackView.topAnchor, bottom: nil, leading: leadingAnchor, trailing: trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0.5)
        bottomBraceView.anchor(top: stackView.bottomAnchor, bottom: nil, leading: leadingAnchor, trailing: trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0.5)
    }
    
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder) has not been implemented")
    }
    
    
    
}
