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
    func sendDeletePicValues()
}

class DeletePicturesViewController: UIViewController {

    var deletePicCell:DeletePicturesCollectionViewCell? = nil
    var picturesArray:NSMutableArray = []
    var uploadPicturesArray:NSMutableArray = []
    var deletePicData:DeletePicModel?
    let apiManager = APIManager()
    var delegate:sendDeletePicDelegate?
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.title = "Additional Pictures"
        let closeBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(closeBtnMethod))
        self.navigationItem.rightBarButtonItem = closeBtn

        // Do any additional setup after loading the view.
    }
    @objc func closeBtnMethod()
    {
        self.dismiss(animated: true) {
            self.delegate?.sendDeletePicValues()
        }
    }
    
    @objc func deleteImg(btn:UIButton)
    {
        print("selected delete \(self.picturesArray[btn.tag] as? String ?? " ")")

        
        print("uploading \(self.uploadPicturesArray[btn.tag] as? String ?? " ")")
        
        GenericMethods.showYesOrNoAlertWithCompletionHandler(alertTitle: "", alertMessage: "Do you want to delete this item?") { (alertAction) in
            
            var parameters = Dictionary<String, Any>()
            parameters["doctor_id"] = UserDefaults.standard.value(forKey: "user_id") ?? 0 as Int
            parameters["file"] = self.uploadPicturesArray[btn.tag] as? String ?? " "
            
            GenericMethods.showLoaderMethod(shownView: self.view, message: "Loading")
            
            self.apiManager.deletePicDetailsAPI(parameters: parameters) { (status, showError, response, error) in
                
                GenericMethods.hideLoaderMethod(view: self.view)
                
                if status == true {
                    self.deletePicData = response
                    if self.deletePicData?.status?.code == "0" {
                        //MARK: Profile Success Details
                        
                        GenericMethods.showAlert(alertMessage: self.deletePicData?.status?.message ?? "Updated Successfully")
                        self.picturesArray.remove(self.picturesArray[btn.tag] as? String ?? " ")
                        self.uploadPicturesArray.remove(self.uploadPicturesArray[btn.tag] as? String ?? " ")
                        
                        self.collectionView.reloadData()
                    }
                    else
                    {
                        
                        GenericMethods.showAlert(alertMessage: self.deletePicData?.status?.message ?? "Unable to fetch data. Please try again after sometime.")
                    }
                    
                    
                }
                else {
                    
                    GenericMethods.showAlert(alertMessage: self.deletePicData?.status?.message ?? "Unable to fetch data. Please try again after sometime.")
                }
            }

        }
       
        
    }
    // MARK: - Delete Picture API
    func deletePicDetailsAPI(pictureUrl:String)
    {

    }
    
    // MARK: - IBActions

    
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
