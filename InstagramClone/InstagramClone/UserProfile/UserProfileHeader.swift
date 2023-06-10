

import Foundation
import UIKit
import FirebaseFirestore
import SDWebImage

class UserProfileHeader : UICollectionViewCell {
    
    var validUser : User? {
        didSet{
            guard let url = URL(string: validUser?.profilePhotoURL ?? "") else {return}
            self.imgProfilePhoto.sd_setImage(with: url,completed: nil)
            labelUsername.text = validUser?.userName
        }
    }
    let btnEditProfile : UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Edit Profile", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        btn.layer.borderColor = UIColor.lightGray.cgColor
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 5
        return btn
    }()
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
