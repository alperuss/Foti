
import UIKit

class SearchUserCell : UICollectionViewCell {
    var user : User? {
        didSet {
            lblUserName.text = user?.userName
            if let url = URL(string: user?.profilePhotoURL ?? "") {
                imgUserProfile.sd_setImage(with: url)
            }
        }
    }
    
    let lblUserName : UILabel = {
        let lbl = UILabel()
        lbl.text = "Username"
        lbl.font = UIFont.boldSystemFont(ofSize: 15)
        return lbl
    }()
    
    let imgUserProfile : UIImageView = {
       let img = UIImageView()
        img.backgroundColor = .yellow
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        return img
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(imgUserProfile)
        addSubview(lblUserName)
        imgUserProfile.layer.cornerRadius = 55 / 2
        imgUserProfile.anchor(top: nil, bottom: nil, leading: leadingAnchor, trailing: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 10, paddingRight: 0, width: 55, height: 55)
        imgUserProfile.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        lblUserName.anchor(top: topAnchor, bottom: bottomAnchor, leading: imgUserProfile.trailingAnchor, trailing: trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 10, paddingRight: 0, width: 0, height: 0)
        
        let braceView = UIView()
        braceView.backgroundColor = UIColor(white: 0, alpha: 0.45)
        addSubview(braceView)
        braceView.anchor(top: nil, bottom: bottomAnchor, leading: lblUserName.leadingAnchor, trailing: trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0.45)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
