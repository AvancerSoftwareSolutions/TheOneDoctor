//
//  DeletePicturesViewController.swift
//  TheOneDoctor
//
//  Created by MyMac on 21/05/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

protocol sendDeletePicDelegate {
    func sendDeletePicValues(picArray:NSMutableArray,uploadArray:NSMutableArray)
}

class DeletePicturesViewController: UIViewController {

    var deletePicCell:DeletePicturesCollectionViewCell? = nil
    var picturesArray:NSMutableArray = []
    var uploadPicturesArray:NSMutableArray = []
    var deletePicData:DeletePicModel?
    let apiManager = APIManager()
    var delegate:sendDeletePicDelegate?
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var submitBtnInstance: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        submitBtnInstance.layer.cornerRadius = 5.0
        submitBtnInstance.layer.masksToBounds = true
        self.title = "Additional Pictures"
        let closeBtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(closeBtnMethod))
        self.navigationItem.rightBarButtonItem = closeBtn

        // Do any additional setup after loading the view.
    }
    @objc func closeBtnMethod()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func deleteImg(btn:UIButton)
    {
        print("selected delete \(self.picturesArray[btn.tag] as? String ?? " ")")
        self.picturesArray.remove(self.picturesArray[btn.tag] as? String ?? " ")
        self.uploadPicturesArray.remove(self.uploadPicturesArray[btn.tag] as? String ?? " ")
        
        self.collectionView.reloadData()
        
    }
    
    // MARK: - IBActions
    
    @IBAction func submitBtnClick(_ sender: Any) {
        self.delegate?.sendDeletePicValues(picArray: self.picturesArray, uploadArray: self.uploadPicturesArray)
        self.dismiss(animated: true, completion: nil)
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
extension DeletePicturesViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picturesArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        deletePicCell = collectionView.dequeueReusableCell(withReuseIdentifier: "deletePicCell", for: indexPath) as? DeletePicturesCollectionViewCell
        
        deletePicCell?.contentView.layer.cornerRadius = 5.0
        deletePicCell?.contentView.layer.masksToBounds = true
        deletePicCell?.deleteBtnInstance.layer.cornerRadius = (deletePicCell?.deleteBtnInstance.frame.height)! / 2
        deletePicCell?.deleteBtnInstance.layer.masksToBounds = true
        deletePicCell?.deleteBtnInstance.tag = indexPath.row
        deletePicCell?.deleteBtnInstance.addTarget(self, action: #selector(deleteImg(btn:)), for: .touchUpInside)
        
        GenericMethods.createThumbnailOfVideoFromRemoteUrl(url: self.picturesArray[indexPath.item] as? String ?? "",imgView: deletePicCell!.imgView,playImgView: deletePicCell!.playImg)
        
        return deletePicCell!
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth:CGFloat = collectionView.frame.size.width - 30
        return CGSize(width: cellWidth / 3, height: cellWidth / 3)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            if let cell = collectionView.cellForItem(at: indexPath) as? DeletePicturesCollectionViewCell {
                if cell.playImg.isHidden == false
                {
                    let videoURL = URL(string: self.picturesArray[indexPath.item] as? String ?? "")
                    let player = AVPlayer(url: videoURL!)
                    let playerViewController = AVPlayerViewController()
                    playerViewController.player = player
                    self.present(playerViewController, animated: true) {
                        playerViewController.player!.play()
                    }
                }
                else
                {
                    let openFileVC = self.storyboard!.instantiateViewController(withIdentifier: "openFileVC") as? OpenFileViewController
                    openFileVC?.titleStr = ""
                    openFileVC?.openURLStr = self.picturesArray[indexPath.item] as? String ?? ""
                    self.navigationController?.pushViewController(openFileVC!, animated: true)
                }
            }
            
        
    }
}
