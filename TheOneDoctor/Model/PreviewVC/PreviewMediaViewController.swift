//
//  PreviewMediaViewController.swift
//  TheOneDoctor
//
//  Created by MyMac on 15/06/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import UIKit
import AVKit

class PreviewMediaViewController: UIViewController {
    
    //MARK:- IBOutlets
    
    @IBOutlet weak var closeBtnInst: UIButton!
    @IBOutlet weak var mediaPreviewCollectionView: UICollectionView!
    
    @IBOutlet weak var mediaListCollectionView: UICollectionView!
    //MARK:- Variables
    
    var mediaArray:NSMutableArray = []
    var docPicturesCell:DoctorPicturesCollectionViewCell?
    var onceOnly:Bool = false
    var indexToScrollTo = IndexPath(item: 0, section: 0)
    var isDeleteEnabled = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mediaPreviewCollectionView.register(UINib(nibName: "DoctorPicturesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "docPicturesCell")
        mediaListCollectionView.register(UINib(nibName: "DoctorPicturesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "docPicturesCell")
        
        mediaPreviewCollectionView.backgroundColor = UIColor.black
        
        closeBtnInst.imageView?.setImageColor(color: UIColor.white)
        
        
        

        // Do any additional setup after loading the view.
    }
//    override func viewWillAppear(_ animated: Bool) {
//        navigationController?.navigationBar.isHidden = true
//    }
//    override func viewWillDisappear(_ animated: Bool) {
//        navigationController?.navigationBar.isHidden = false
//    }
    override func viewDidAppear(_ animated: Bool) {
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        
        if statusBar.responds(to: #selector(setter: UIView.backgroundColor)) {
            statusBar.backgroundColor = AppConstants.appGreenColor
        }
    }
    //MARK:- IBActions

    @IBAction func deleteBtnClick(_ sender: Any) {
        
    }
    @IBAction func closeBtnClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
extension PreviewMediaViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    //dashboardCell
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return mediaArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        docPicturesCell = collectionView.dequeueReusableCell(withReuseIdentifier: "docPicturesCell", for: indexPath) as? DoctorPicturesCollectionViewCell
        docPicturesCell?.DocPicImgView.tag = indexPath.row
        GenericMethods.createThumbnailOfVideoFromRemoteUrl(url: self.mediaArray[indexPath.item] as? String ?? "",imgView: docPicturesCell!.DocPicImgView,playImgView: docPicturesCell!.playImgView)
        
        if collectionView == mediaListCollectionView
        {
            print("item \(indexPath.item) scroll \(indexToScrollTo.item)")
            if indexPath.item == indexToScrollTo.item
            {
                
                docPicturesCell?.DocPicImgView.layer.borderWidth = 2.0
                docPicturesCell?.DocPicImgView.layer.borderColor = UIColor.white.cgColor
                docPicturesCell?.DocPicImgView.layer.masksToBounds = true
                docPicturesCell?.DocPicImgView.layer.cornerRadius = 5.0
            }
            else
            {
                docPicturesCell?.DocPicImgView.layer.borderColor = UIColor.clear.cgColor
            }
        }
        
        
        return docPicturesCell!
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth:CGFloat = collectionView.frame.size.width - 10
        let cellHeight:CGFloat = collectionView.frame.size.height - 20
        switch collectionView {
        case mediaPreviewCollectionView:
            return CGSize(width: cellWidth, height: cellHeight)
        case mediaListCollectionView:
            return CGSize(width: 80, height: 80)
        default:
            break
        }
        return CGSize(width: cellWidth, height: cellHeight)
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
            switch collectionView {
            case mediaPreviewCollectionView:
                print("indepath \(indexPath.item)")
                indexToScrollTo = IndexPath(item: indexPath.item, section: 0)
                self.mediaListCollectionView.reloadData()
                
                self.mediaListCollectionView.scrollToItem(at: indexToScrollTo, at: .right, animated: false)
                
            default:
                break
            }
        
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let media = FileUpload.checkImgOrVideofromURL(filePath: self.mediaArray[indexPath.item] as? String ?? "")
        print("media \(media)")
        if media == AppConstants.imageFileName
        {
//            let openFileVC = self.storyboard!.instantiateViewController(withIdentifier: "openFileVC") as? OpenFileViewController
//            openFileVC?.titleStr = ""
//            openFileVC?.openURLStr = "\(self.mediaArray[indexPath.item] as? String ?? "")"
//
//            self.present(openFileVC!, animated: <#T##Bool#>, completion: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)
//            self.navigationController?.pushViewController(openFileVC!, animated: true)
        }
        else if media == AppConstants.videoFileName
        {
            DispatchQueue.main.async {
                guard let mediaUrl = URL(string: self.mediaArray[indexPath.item] as? String ?? "") else {return}
                
                let player = AVPlayer(url: mediaUrl)
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player
                self.present(playerViewController, animated: true) {
                    playerViewController.player!.play()
                }
            }
        }
        
    }
    
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        let point = CGPoint(x: self.view.frame.size.width/2.0, y:150 )
//
//        print(point)
//        let centerIndex = self.mediaPreviewCollectionView.indexPathForItem(at: point)
//        print(centerIndex?.row as Any)
//    }
}
