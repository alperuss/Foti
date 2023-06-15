//
//  UserPostPhotoCell.swift
//  InstagramClone
//
//  Created by Alper Us on 2023-06-11.
//

import UIKit

class UserPostPhotoCell : UICollectionViewCell {
    var post : Post? {
        didSet{
            if let url = URL(string: post?.postImageURL ?? "" ){
                imgPhotoPost.sd_setImage(with: url,completed: nil)
            }
            
        }
    }
    let imgPhotoPost : UIImageView = {
        let img = UIImageView()
        img.backgroundColor = .white
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        return img
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imgPhotoPost)
        imgPhotoPost.anchor(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
