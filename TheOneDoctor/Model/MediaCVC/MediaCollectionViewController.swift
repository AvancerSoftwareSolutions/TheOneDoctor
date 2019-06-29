//
//  MediaCollectionViewController.swift
//  TheOneDoctor
//
//  Created by MyMac on 10/06/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import UIKit
import Photos
import AVKit

private let reuseIdentifier = "mediaCell"
protocol sendMediaAssetsDelegate
{
    func sendMediaAssests(assets:[PHAsset])
}
class MediaCollectionViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    
    var photos: PHFetchResult<PHAsset>!
    var arrayOfPHAsset : [PHAsset] = []
    var assetCollection = PHAssetCollection()
    
    var mediaCell:MediaCollectionViewCell? = nil
    var customTitleView:CustomTitleView!
    
    @objc var albumTitleView: UIButton = {
        let btn =  UIButton(type: .system)
        btn.setTitleColor(UIColor.white, for: .normal)
        return btn
    }()
    var imageWidth:CGFloat = 0.0
    var doneBtn = UIBarButtonItem()
    var selectedAssets = [PHAsset]()
    var maxNumberOfSelections = 0
    var delegate:sendMediaAssetsDelegate?
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        print("count \(maxNumberOfSelections)")
        imageWidth = (self.collectionView.bounds.width - 10 ) / 3
        print(imageWidth)
        
        doneBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneBtnClick))
        self.navigationItem.rightBarButtonItem = doneBtn
        let cancelBtn = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelBtnClick))
        self.navigationItem.leftBarButtonItem = cancelBtn
        doneBtn.isEnabled = false
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressClick(_:)))
        longPressRecognizer.minimumPressDuration = 0.5
        collectionView?.addGestureRecognizer(longPressRecognizer)
        
        allMediaMethod()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        customTitleView = CustomTitleView(frame: CGRect(x: 0, y: 0, width: 150, height: 30))
        customTitleView.translatesAutoresizingMaskIntoConstraints = false
        customTitleView.titleLabel.text = "All Photos"
        customTitleView.dropDownBtnInst.imageView?.setImageColor(color: UIColor.white)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectAlbumsOptionsMethod))
        customTitleView.addGestureRecognizer(tapGesture)
        self.navigationItem.titleView = customTitleView
        
        
        
    }
    @objc func longPressClick(_ sender: UIGestureRecognizer)
    {
        if sender.state == .began {
//            sender.isEnabled = false
//            collectionView?.isUserInteractionEnabled = false
            let location = sender.location(in: collectionView)
            let indexPath = collectionView?.indexPathForItem(at: location)
            if let cell = collectionView?.cellForItem(at: indexPath!) as? MediaCollectionViewCell, let asset = cell.asset
            {
                FileUpload.getURL(of: asset) { (mediaurl) in
                    guard let mediaUrl = mediaurl else { return }
                    if asset.mediaType == .image
                    {
                        let openFileVC = self.storyboard!.instantiateViewController(withIdentifier: "openFileVC") as? OpenFileViewController
                        openFileVC?.titleStr = ""
                        openFileVC?.openURLStr = "\(mediaUrl)"
                        self.navigationController?.pushViewController(openFileVC!, animated: true)
                    }
                    else if asset.mediaType == .video
                    {
                        DispatchQueue.main.async {
                            
                            let player = AVPlayer(url: mediaUrl)
                            let playerViewController = AVPlayerViewController()
                            playerViewController.player = player
                            self.present(playerViewController, animated: true) {
                                playerViewController.player!.play()
                            }
                        }
                    }
                }
            }
            
//            sender.isEnabled = true
//            collectionView?.isUserInteractionEnabled = true
            
        }
        
    }
    @objc func cancelBtnClick()
    {
        self.dismiss(animated: true, completion: nil)
    }
    @objc func doneBtnClick()
    {
        self.dismiss(animated: true) {
            self.delegate?.sendMediaAssests(assets: self.selectedAssets)
        }
    }
    @objc func selectAlbumsOptionsMethod()
    {
        self.selectedAssets = []
        doneBtn.title = "Done"
        doneBtn.isEnabled = false
        let alert = UIAlertController(title: "Choose Your option", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "All Photos", style: .default, handler: { _ in
            
            self.customTitleView.titleLabel.text = "All Photos"
            self.allMediaMethod()
        }))
        let albumResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil)
        
        for i in 0..<albumResult.count
        {
            print(albumResult[i].localizedTitle as Any)
            alert.addAction(UIAlertAction(title: albumResult[i].localizedTitle, style: .default, handler: { _ in
                
                self.customTitleView.titleLabel.text = albumResult[i].localizedTitle!
                
                self.fetchCustomAlbumPhotos(albumID: albumResult[i].localIdentifier)
                self.albumTitleView.frame = self.navigationItem.titleView!.bounds
                
            }))
        }
        alert.addAction(UIAlertAction(title: "Videos", style: .default, handler: { _ in
            self.customTitleView.titleLabel.text = "Videos"
            self.fetchVideoFromLibrary()
        }))
        
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        /*If you want work actionsheet on ipad
         then you have to use popoverPresentationController to present the actionsheet,
         otherwise app will crash on iPad */
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            
            alert.popoverPresentationController?.sourceView = self.view
            alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            alert.popoverPresentationController?.permittedArrowDirections = []
            
        default:
            break
        }
        
        self.present(alert, animated: true, completion: nil)
    
    }
    
    func fetchImageFromLibrary(albumName:String) {
        self.arrayOfPHAsset = []
        let fetchOptions: PHFetchOptions = PHFetchOptions()
        
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        photos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        photos.enumerateObjects { (object, index, stop) -> Void in
            let options = PHImageRequestOptions()
            options.isSynchronous = true
            options.deliveryMode = .highQualityFormat
            self.arrayOfPHAsset.append(object)
        }
        print(photos as Any)
        collectionView.reloadData()
    }
    func fetchCustomAlbumPhotos(albumID:String)
    {
        self.arrayOfPHAsset = []
        var assetCollection = PHAssetCollection()
        var photoAssets = PHFetchResult<AnyObject>()
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "localIdentifier = %@", albumID)
        let collection:PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        
        if let firstObject = collection.firstObject{
            //found the album
            assetCollection = firstObject
        }
        
        _ = collection.count
        photoAssets = PHAsset.fetchAssets(in: assetCollection, options: nil) as! PHFetchResult<AnyObject>
        photoAssets.enumerateObjects{(object: AnyObject!,
            count: Int,
            stop: UnsafeMutablePointer<ObjCBool>) in
            
            if object is PHAsset{
                let asset = object as! PHAsset
                self.arrayOfPHAsset.append(asset)
            }
        }
        collectionView.reloadData()
    }
    func fetchVideoFromLibrary() {
        self.arrayOfPHAsset = []
        let fetchOptions: PHFetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        photos = PHAsset.fetchAssets(with: .video, options: fetchOptions)
        photos.enumerateObjects { (object, index, stop) -> Void in
            let options = PHVideoRequestOptions()
            options.version = .original
            options.deliveryMode = .highQualityFormat
            self.arrayOfPHAsset.append(object)
        }
        print(photos as Any)
        collectionView.reloadData()
    }
    func allMediaMethod()
    {
        self.arrayOfPHAsset = []
        let fetchOptions: PHFetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        photos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        photos.enumerateObjects { (object, index, stop) -> Void in
            let options = PHImageRequestOptions()
            options.isSynchronous = true
            options.deliveryMode = .highQualityFormat
            self.arrayOfPHAsset.append(object)
            
            
        }
        photos = PHAsset.fetchAssets(with: .video, options: fetchOptions)
        photos.enumerateObjects { (object, index, stop) -> Void in
            let options = PHImageRequestOptions()
            options.isSynchronous = true
            options.deliveryMode = .highQualityFormat
            self.arrayOfPHAsset.append(object)
            
            
        }
        print(photos as Any)
        collectionView.reloadData()
    }

    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return arrayOfPHAsset.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
//
//        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height:cell.frame.height))
//        imgView.image = nil
//
//        cell.addSubview(imgView)
//
        let asset = arrayOfPHAsset[indexPath.row]
        let width: CGFloat = imageWidth
        let height: CGFloat = imageWidth
        let size = CGSize(width:width, height:height)
        
        
        mediaCell = collectionView.dequeueReusableCell(withReuseIdentifier: "mediaCell", for: indexPath) as? MediaCollectionViewCell
        
        mediaCell!.asset = arrayOfPHAsset[indexPath.row]

        PHImageManager.default().requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: nil) { (image: UIImage?, info: [AnyHashable : Any]?) in
            self.mediaCell!.mediaImgView.image = image
            if asset.mediaType == .image
            {
                self.mediaCell!.playImg.isHidden = true
            }
            else
            {
                self.mediaCell!.playImg.isHidden = false
            }
        }

        // Configure the cell
    
        return mediaCell!
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: imageWidth, height: imageWidth)
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if let cell = collectionView.cellForItem(at: indexPath) as? MediaCollectionViewCell
        {
            
            if self.selectedAssets.contains(arrayOfPHAsset[indexPath.row])
            {
                cell.selectCellView.isHidden = true
                print("unselected")
                self.selectedAssets.remove(at: self.selectedAssets.firstIndex(of: arrayOfPHAsset[indexPath.row])!)
            }
            else
            {
                if self.selectedAssets.count != maxNumberOfSelections
                {
                    cell.selectCellView.isHidden = false
                    print("selected")
                    self.selectedAssets.append(arrayOfPHAsset[indexPath.row])
                }
            }
            if selectedAssets.count > 0
            {
                doneBtn.title = "Done (\(selectedAssets.count))"
                doneBtn.isEnabled = true
            }
            else
            {
                doneBtn.title = "Done"
                doneBtn.isEnabled = false
            }
            print(self.selectedAssets.count,maxNumberOfSelections)
            
//            if (self.selectedAssets.count > maxNumberOfSelections)
//            {
//                if cell.selectCellView.isHidden
//                {
//
//                }
//                else
//                {
//                    cell.selectCellView.isHidden = true
//                    print("unselected")
//                    if self.selectedAssets.contains(arrayOfPHAsset[indexPath.row])
//                    {
//                        self.selectedAssets.remove(at: self.selectedAssets.firstIndex(of: arrayOfPHAsset[indexPath.row])!)
//                    }
//                }
//                if selectedAssets.count > 0
//                {
//                    doneBtn.title = "Done (\(selectedAssets.count))"
//                    doneBtn.isEnabled = true
//                }
//                else
//                {
//                    doneBtn.title = "Done"
//                    doneBtn.isEnabled = false
//                }
//            }
            
            
        }
        
//        if let cell = collectionView.cellForItem(at: indexPath)
//        {
//
//            if cell.vi
//
//            if cell.isSelected
//            {
//
//                cell.isSelected = false
//                collectionView.deselectItem(at: indexPath, animated: false)
//                print("unselected")
//            }
//            else
//            {
//                cell.isSelected = true
//                print("selected")
//            }
//        }
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
extension MediaCollectionViewController
{
    @objc public var albumButton: UIButton {
        get {
            return albumTitleView
        }
        set {
            albumTitleView = newValue
        }
    }
}
