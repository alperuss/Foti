

import UIKit

class MainPostCell : UICollectionViewCell {
    var post : Post? {
        didSet{
            guard let url = post?.postImageURL
                ,let imageURL = URL(string: url) else {return}
            imgPostPhoto.sd_setImage(with: imageURL)
            lblUserName.text = post?.user.userName
            
            guard let pUrl = post?.user.profilePhotoURL,
                  let profileImageURL = URL(string: pUrl) else {return}
            imgUserProfilePhoto.sd_setImage(with: profileImageURL)
            attrPostMessage()
        }
    }
    fileprivate func attrPostMessage() {
        guard let post = self.post else {return}
        let attrText = NSMutableAttributedString(string:"\(post.user.userName) ",attributes: [.font : UIFont.boldSystemFont(ofSize: 14)])
        attrText.append(NSAttributedString(string: post.message ?? "No Data",attributes: [.font : UIFont.systemFont(ofSize: 14)]))
        attrText.append(NSAttributedString(string: "\n\n",attributes: [.font : UIFont.systemFont(ofSize: 14)]))
        let postDate = post.postDate.dateValue()
        
        attrText.append(NSAttributedString(string: postDate.timeBefore(),attributes: [.font : UIFont.systemFont(ofSize: 14), .foregroundColor : UIColor.gray]))
        lblPostMessage.attributedText = attrText
    }
    let lblPostMessage : UILabel = {
        let lbl = UILabel()
       
        
        lbl.numberOfLines = 0
        return lbl
    }()
    let btnBookmark : UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "Saved")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return btn
    }()
    let btnLike : UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "Like_Not_Selected")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return btn
    }()
    let btnSend : UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "Send")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return btn
    }()
    let btnComment : UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "Comment")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return btn
    }()
    let btnOptions : UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("•••", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        return btn
    }()
    let imgUserProfilePhoto : UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.backgroundColor = .blue
        return img
    }()
    let lblUserName : UILabel = {
        let lbl = UILabel()
        lbl.text = "Username "
        lbl.font = UIFont.boldSystemFont(ofSize: 15)
        return lbl
    }()
    let imgPostPhoto : UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        return img
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imgUserProfilePhoto)
        addSubview(lblUserName)
        addSubview(imgPostPhoto)
        addSubview(btnOptions)
        
        imgUserProfilePhoto.anchor(top: topAnchor, bottom: imgPostPhoto.topAnchor, leading: leadingAnchor, trailing: nil, paddingTop: 8, paddingBottom: -3, paddingLeft: 8, paddingRight: 0, width: 40, height: 40)
        imgUserProfilePhoto.layer.cornerRadius = 40/2
        btnOptions.anchor(top: topAnchor, bottom: imgPostPhoto.topAnchor, leading: nil, trailing: trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 45, height: 0)
        
        lblUserName.anchor(top: topAnchor, bottom: imgPostPhoto.topAnchor, leading: imgUserProfilePhoto.trailingAnchor, trailing: btnOptions.leadingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 8, paddingRight: 0, width: 0, height: 0)
        
        
        imgPostPhoto.anchor(top: imgUserProfilePhoto.bottomAnchor, bottom: nil, leading: leadingAnchor, trailing: trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        _ = imgPostPhoto.heightAnchor.constraint(equalTo: widthAnchor , multiplier: 1).isActive = true
        interactionButtons()
        
    }
    fileprivate func interactionButtons(){
        let stackView = UIStackView(arrangedSubviews: [btnLike,btnComment,btnSend])
        stackView.distribution = .fillEqually
        addSubview(stackView)
        addSubview(btnBookmark)
        addSubview(lblPostMessage)
        
        stackView.anchor(top: imgPostPhoto.bottomAnchor, bottom: nil, leading: leadingAnchor, trailing: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 8, paddingRight: 0, width: 120, height: 50)
        btnBookmark.anchor(top: imgPostPhoto.bottomAnchor, bottom: nil, leading: nil, trailing: trailingAnchor, paddingTop: 0, paddingBottom:  0, paddingLeft: 0, paddingRight: 0, width: 40, height: 50)
        lblPostMessage.anchor(top: btnLike.bottomAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 8, paddingRight: -8, width: 0, height: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
