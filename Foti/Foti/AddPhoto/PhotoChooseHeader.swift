//
//  PhotoChooseHeader.swift
//  InstagramClone
//
//  Created by Alper Us on 2023-06-10.
//

import UIKit
class PhotoChooseHeader : UICollectionViewCell {
    let imgHeader : UIImageView = {
       let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.backgroundColor = .purple
        return img
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imgHeader)
        imgHeader.anchor(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
