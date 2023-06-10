

import UIKit
import Photos
class PhotoChooseController : UICollectionViewController {
    let cellID = "cellID"
    let headerID = "headerID"
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        addButtons()
        collectionView.register(PhotoChooseCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.register(PhotoChooseHeader .self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerID)
        getPhotos()
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        chosenPhoto = photos[indexPath.row]
        collectionView.reloadData()
    }
    
    var assets = [PHAsset]()
    var chosenPhoto : UIImage?
    var photos = [UIImage]()
    fileprivate func getOptionsOfPhotos() -> PHFetchOptions{
        let getOptions = PHFetchOptions()
        getOptions.fetchLimit = 40
        let sortOptions = NSSortDescriptor(key: "creationDate", ascending: false)
        getOptions.sortDescriptors = [sortOptions]
        return getOptions
    }
    fileprivate func getPhotos(){
      
        let photos = PHAsset.fetchAssets(with: .image, options: getOptionsOfPhotos())
        
        DispatchQueue.global(qos: .background).async {
            photos.enumerateObjects { asset, number, stopPoint in
                
                //asset; photo informations
                //number ; number of photo(from 0 to 9)
                
                let imageManager = PHImageManager.default()
                let sizePhoto = CGSize(width: 200 , height: 200)
                let options = PHImageRequestOptions()
                options.isSynchronous = true
                imageManager.requestImage(for: asset, targetSize: sizePhoto, contentMode: .aspectFit, options: options) { (image, imageInfo) in
                    if let photo = image {
                        self.assets.append(asset)
                        self.photos.append(photo)
                        
                        if self.chosenPhoto == nil {
                            self.chosenPhoto = image
                        }
                        
                    }
                    if number == photos.count - 1 {
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                    }
                }
            }
        }
       
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width, height: width)
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerID, for: indexPath) as! PhotoChooseHeader
        
        
        if let chosenPhoto = chosenPhoto {
            if let index = self.photos.firstIndex(of: chosenPhoto) {
                let chosenAsset = self.assets[index]
                let photoManager = PHImageManager.default()
                let size = CGSize(width: 600, height: 600)
                photoManager.requestImage(for: chosenAsset, targetSize: size, contentMode: .default, options: nil) { (photo,info) in
                    header.imgHeader.image = photo
                }
            }
        }
        
        
        return header
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! PhotoChooseCell
        cell.imgPhoto.image = photos[indexPath.row]
        return cell
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    fileprivate func addButtons(){

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(btnCancelPressed))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(btnNextPressed))
    }
    @objc func btnNextPressed(){
        print("next")
    }
    @objc func btnCancelPressed(){
        dismiss(animated: true)
    }
}
extension UINavigationController {
    open override var childForStatusBarHidden: UIViewController? {
        return self.topViewController
    }
}
extension PhotoChooseController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 3) / 4
        return CGSize(width: width, height: width )
    }
}
