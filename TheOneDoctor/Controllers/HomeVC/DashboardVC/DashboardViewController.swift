//
//  DashboardViewController.swift
//  TheOneDoctor
//
//  Created by MyMac on 06/05/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import UIKit
import Alamofire
import Photos

class DashboardViewController: UIViewController,UIGestureRecognizerDelegate {
    
    //MARK:- IBOutlets
    @IBOutlet weak var profilePicImgView: UIImageView!
    @IBOutlet weak var notificationImgView: UIImageView!
    
    @IBOutlet weak var settingsImgView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var profileContainerView: UIView!
    //MARK:- Variables
    
    var dashboardCell:DashboardCollectionViewCell? = nil
    var dashBoardListData:DashboardModel?
    var textArray:NSMutableArray = []
    let apiManager = APIManager()
    

    var fetchResults: [PHFetchResult<PHAssetCollection>] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        roundImgView(imgView: settingsImgView)
        
        
        let cornerRadius = profilePicImgView.bounds.height / 2
        
        profileContainerView.clipsToBounds = false
        profileContainerView.layer.cornerRadius = cornerRadius
        profileContainerView.layer.shadowColor = UIColor.darkGray.cgColor
        profileContainerView.layer.shadowOpacity = 1
        profileContainerView.layer.shadowOffset = CGSize.zero
        profileContainerView.layer.shadowRadius = 2
        profileContainerView.layer.shadowPath = UIBezierPath(roundedRect: profileContainerView.bounds, cornerRadius: cornerRadius).cgPath

        
        let profileTapGesture = UITapGestureRecognizer(target: self, action: #selector(profilePageNavigationMethod))
        profileTapGesture.numberOfTapsRequired = 1
        self.profilePicImgView.addGestureRecognizer(profileTapGesture)
        self.profilePicImgView.isUserInteractionEnabled = true
        
        let settingsTapGesture = UITapGestureRecognizer(target: self, action: #selector(logoutMethod))
        settingsTapGesture.numberOfTapsRequired = 1
        self.settingsImgView.addGestureRecognizer(settingsTapGesture)
        self.settingsImgView.isUserInteractionEnabled = true
        
        textArray = [
            ["image":"Appoint.png",
             "detail":"Appointments"],
            ["image":"Schedule.png",
             "detail":"Schedule"],
            ["image":"Queue.png",
             "detail":"Queue"],
            ["image":"Revenue.png",
             "detail":"Revenue"],
            ["image":"Upload.png",
             "detail":"Upload"],
            ["image":"Watch.png",
             "detail":"Link The ONE Watch"]
        ]
//        fetchCustomAlbumPhotos()
//        getAlbumList()
        fetchVideoFromLibrary()
        
        // Do any additional setup after loading the view.
    }
    func getAlbumList()
    {
        let fetchOptions = PHFetchOptions()
        let albumResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        
        fetchResults = [albumResult]
//        let album = fetchResults.first?.firstObject
        fetchOptions.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: false)
        ]
        fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        for i in 0..<fetchResults.count
        {
            let coll = fetchResults[0][i]
            print("\(String(describing: coll.localizedTitle))\n")
            
            
            
            let fetchResult = PHAsset.fetchAssets(in: coll, options: fetchOptions)
            
            
            print("count \(fetchResult.count)")
            for i in 0..<fetchResult.count
            {
                FileUpload.getURL(of: fetchResult[i]) { (url) in
                    print("image url \(String(describing: url))")
                }
            }
            
            
        }
//        for res in fetchResults
//        {
//            print("\(res.localizedTitle)\n")
//        }
//        print("asset \(String(describing: album?.localizedTitle))")
        
        
        
        
        
//        let photosManager = PHCachingImageManager.default()
//        let ass = PHAsset.fetchAssets(in: <#T##PHAssetCollection#>, options: <#T##PHFetchOptions?#>)
//        photosManager.
//        photosManager.requestImage(for: asset, targetSize: imageSize, contentMode: imageContentMode, options: nil) { (result, _) in
//            cell.imageView.image = result
//        }
    }
    func fetchCustomAlbumPhotos()
    {
        let albumName = "All Photos"
        var assetCollection = PHAssetCollection()
        var albumFound = Bool()
        var photoAssets = PHFetchResult<AnyObject>()
        let fetchOptions = PHFetchOptions()
        
        fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
        let collection:PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        
        if let firstObject = collection.firstObject{
            //found the album
            assetCollection = firstObject
            albumFound = true
        }
        else { albumFound = false }
        _ = collection.count
        photoAssets = PHAsset.fetchAssets(in: assetCollection, options: nil) as! PHFetchResult<AnyObject>
        let imageManager = PHCachingImageManager()
        photoAssets.enumerateObjects{(object: AnyObject!,
            count: Int,
            stop: UnsafeMutablePointer<ObjCBool>) in
            
            if object is PHAsset{
                let asset = object as! PHAsset
                print("Inside  If object is PHAsset, This is number 1")
                
                let imageSize = CGSize(width: asset.pixelWidth,
                                       height: asset.pixelHeight)
                
                /* For faster performance, and maybe degraded image */
                let options = PHImageRequestOptions()
                options.deliveryMode = .fastFormat
                options.isSynchronous = true
                
                imageManager.requestImage(for: asset,
                                          targetSize: imageSize,
                                          contentMode: .aspectFill,
                                          options: options,
                                          resultHandler: {
                                            (image, info) -> Void in
                                            print(info as Any)
//                                            self.photo = image!
//                                            /* The image is now available to us */
//                                            self.addImgToArray(uploadImage: self.photo!)
                                            print("enum for image, This is number 2")
                                            
                })
                
            }
        }
    }
    
    func fetchVideoFromLibrary() {
        let fetchOptions: PHFetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let fetchResult = PHAsset.fetchAssets(with: .video, options: fetchOptions)
        fetchResult.enumerateObjects { (object, index, stop) -> Void in
            let options = PHImageRequestOptions()
            options.isSynchronous = true
            options.deliveryMode = .highQualityFormat

            PHImageManager.default().requestAVAsset(forVideo: object , options: .none) { (avAsset, avAudioMix, dict) -> Void in
                print(avAsset as Any)
                
                if let urlAsset = avAsset as? AVURLAsset {
                    let localVideoUrl = urlAsset.url
                    print("localVideoUrl \(localVideoUrl)")
                }
                
                print("dict is \(dict as Any)")
            }
        }
    }

    @objc func logoutMethod()
    {
        GenericMethods.showYesOrNoAlertWithCompletionHandler(alertTitle: "Are you sure want to Logout ?", alertMessage: "") { (UIAlertAction) in
            GenericMethods.resetDefaults()
            GenericMethods.navigateToLogin()
        }
    }
    @objc func profilePageNavigationMethod()
    {
    
        let profileVC = self.storyboard?.instantiateViewController(withIdentifier: "profileVC") as! ProfileViewController
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
    func roundImgView(imgView:UIImageView)
    {
        imgView.layer.cornerRadius = imgView.frame.size.height / 2
//        imgView.layer.borderWidth = 0.2
        imgView.clipsToBounds = true
        imgView.layer.masksToBounds = true
    }
    override func viewWillAppear(_ animated: Bool) {
        
        GenericMethods.setProfileImage(imageView: profilePicImgView,borderColor:UIColor.lightGray)
        navigationController?.navigationBar.isHidden = true
        loadingdashBoardDetailsAPI()
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    // MARK: - Dashboard API
    func loadingdashBoardDetailsAPI()
    {
        var parameters = Dictionary<String, Any>()
        parameters["user_id"] = UserDefaults.standard.value(forKey: "user_id") ?? 0 as Int
        
        GenericMethods.showLoaderMethod(shownView: self.view, message: "Loading")
        
        apiManager.dashboardListDetailsAPI(parameters: parameters) { (status, showError, response, error) in
            
            GenericMethods.hideLoaderMethod(view: self.view)
            
            if status == true {
                self.dashBoardListData = response
                if self.dashBoardListData?.status?.code == "0" {
                    //MARK: Dashboard Success Details
                    
                    self.collectionView.reloadData()
                    
                }
                else
                {
                    GenericMethods.showAlertwithPopNavigation(alertMessage: self.dashBoardListData?.status?.message ?? "Unable to fetch data. Please try again after sometime.", vc: self)
                    //                    GenericMethods.showAlert(alertMessage: self.profileData?.status?.message ?? "Unable to fetch data. Please try again after sometime.")
                }
                
                
            }
            else {
                GenericMethods.showAlertwithPopNavigation(alertMessage: error?.localizedDescription ?? "Something Went Wrong. Please try again.", vc: self)
                
                
                
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension DashboardViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout

{
    //dashboardCell
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.dashBoardListData != nil {
            return (self.dashBoardListData?.dashboardData?.count) ?? 0
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        dashboardCell = collectionView.dequeueReusableCell(withReuseIdentifier: "dashboardCell", for: indexPath) as? DashboardCollectionViewCell
        dashboardCell?.bgView.layer.cornerRadius = 5.0
        dashboardCell?.bgView.layer.masksToBounds = true
        dashboardCell?.bgView.layer.borderColor = UIColor.white.cgColor
        dashboardCell?.bgView.layer.borderWidth = 1.0
        
        dashboardCell?.descriptionLbl.text = dashBoardListData?.dashboardData?[indexPath.item].name
        
        GenericMethods.createThumbnailOfVideoFromRemoteUrl(url: dashBoardListData?.dashboardData?[indexPath.item].icon ?? "",imgView: dashboardCell!.imgView,playImgView: UIImageView())
        
        
//        dashboardCell?.descriptionLbl.text = (textArray[indexPath.row] as? [AnyHashable:Any])? ["detail"] as? String
//        dashboardCell?.imgView.image = UIImage(named: (textArray[indexPath.row] as? [AnyHashable:Any])? ["image"] as? String ?? "")
        
        return dashboardCell!
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth:CGFloat = collectionView.frame.size.width - 20
        let cellHeight:CGFloat = collectionView.frame.size.height - 30
        return CGSize(width: cellWidth / 2, height: cellHeight / 3)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.item {
        case 0:
            
            let appointVC = self.storyboard?.instantiateViewController(withIdentifier: "appointVC") as! AppointmentsViewController
            self.navigationController?.pushViewController(appointVC, animated: true)
            
        case 1:
            
            let scheduleVC = self.storyboard?.instantiateViewController(withIdentifier: "scheduleVC") as! ScheduleViewController
            self.navigationController?.pushViewController(scheduleVC, animated: true)
        case 2:
            
            let queueVC = self.storyboard?.instantiateViewController(withIdentifier: "queueVC") as! QueueViewController
            self.navigationController?.pushViewController(queueVC, animated: true)
            
        case 3:
            
            let mediaCVC = self.storyboard?.instantiateViewController(withIdentifier: "mediaCVC") as! MediaCollectionViewController
            self.navigationController?.pushViewController(mediaCVC, animated: true)
            
        default:
            break
        }
        
    }
    
    
}
