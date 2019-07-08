//
//  AdvertismentPreviewViewController.swift
//  TheOneDoctor
//
//  Created by MyMac on 28/06/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import UIKit
import SDWebImage

class AdvertismentPreviewViewController: UIViewController {

    @IBOutlet weak var popUpHgtConst: NSLayoutConstraint!
    @IBOutlet weak var closeImgView: UIImageView!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var advtImgView: UIImageView!
    @IBOutlet weak var advtContentView: UITextView!
    @IBOutlet weak var advtTVHgConst: NSLayoutConstraint!

    
    
    var imageStr = ""
    var advtContent = ""
    var adTypeId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("imageStr \(imageStr) advtContent \(advtContent) adTypeId \(adTypeId)")
        
        
        
        if adTypeId == 1
        {
            // fullPage
            popUpHgtConst.constant = self.view.bounds.height - 80
        }
        else if adTypeId == 2
        {
            //half page
            popUpHgtConst.constant = self.view.bounds.height - (self.view.bounds.height / 3)
        }
        
        advtContentView.text = advtContent
        
        
        
        closeImgView.layer.cornerRadius = 30.0
        closeImgView.layer.masksToBounds = true
        closeImgView.layer.borderWidth = 0.3
        closeImgView.layer.borderColor = UIColor.white.cgColor
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeMethod))
        self.closeImgView.addGestureRecognizer(tapGesture)

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        advtImgView.contentMode = .scaleAspectFit
        advtImgView.image = nil
        
        advtImgView.sd_setShowActivityIndicatorView(true)
        advtImgView.sd_setIndicatorStyle(.gray)
        advtImgView.sd_setImage(with: URL(string: imageStr), placeholderImage: AppConstants.docImgListplaceHolderImg,options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
            
            if error == nil
            {
                self.advtImgView.image = image
                
            }
            else
            {
                print("error is \(error?.localizedDescription as Any)")
                self.advtImgView.contentMode = .center
                self.advtImgView.image = AppConstants.errorLoadingImg
                
            }
            
            // Perform operation.
        })
        advtTVHgConst.constant = advtContentView.contentSize.height
    }
    override func viewDidAppear(_ animated: Bool) {
        print("content size \(advtContentView.contentSize)")
        
    }
    @objc func closeMethod()
    {
        self.dismiss(animated: true, completion: nil)
    }

    

}
extension AdvertismentPreviewViewController:UITextViewDelegate
{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if range.length == 1
        {
            return true
        }
        let notAllowedCharacters = "<>";
        let set = NSCharacterSet(charactersIn: notAllowedCharacters);
        let inverted = set.inverted;
        let filtered = text.components(separatedBy: inverted).joined(separator: "")
        if filtered == text
        {
            return false
        }
        else
        {
            let textCount = textView.text.count + (text.count - range.length)
            if textCount <= 250
            {
                return true
            }
            
            return false
        }
        
        
        
    }
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return false
    }

}
