//
//  DealsViewController.swift
//  TheOneDoctor
//
//  Created by MyMac on 26/06/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import UIKit
import ACFloatingTextfield_Swift
import Alamofire

class DealsViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var scrollViewInstance: UIScrollView!
    @IBOutlet weak var selectSpecialityView: UIView!
    @IBOutlet weak var selectSpecialityBtnInstance: UIButton!
    @IBOutlet weak var titleTF: ACFloatingTextfield!
    @IBOutlet weak var rateTF: ACFloatingTextfield!
    @IBOutlet weak var detailsTextView: UITextView!
    @IBOutlet weak var discountPercentageTF: ACFloatingTextfield!
    @IBOutlet weak var addDealBtnInstance: UIButton!
    
    
    
    // MARK: - Variables
    
    let apiManager = APIManager()
    var specialityListData:SpecialityModel?
    var addDealsListData:DealsListModel?
    var specialityId = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Add Deal"
        
        GenericMethods.setButtonAttributes(button: addDealBtnInstance, with: "Add Deal")
        
        GenericMethods.roundedCornerTextView(textView: detailsTextView)
        selectSpecialityView.layer.cornerRadius = 5.0
        selectSpecialityView.layer.masksToBounds = true
        selectSpecialityView.layer.borderColor = AppConstants.appdarkGrayColor.cgColor
        selectSpecialityView.layer.borderWidth = 1.0
        
        let numberToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        numberToolbar.barStyle = .default
        numberToolbar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneWithNumberPad))]
        numberToolbar.sizeToFit()
        detailsTextView.inputAccessoryView = numberToolbar
        rateTF.inputAccessoryView = numberToolbar
        discountPercentageTF.inputAccessoryView = numberToolbar
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        loadingSpecialityListAPI(loadFrom: 0)

        // Do any additional setup after loading the view.
    }
    @objc func doneWithNumberPad()
    {
        let _ = detailsTextView.resignFirstResponder()
        let _ = rateTF.resignFirstResponder()
        let _ = discountPercentageTF.resignFirstResponder()
    }
    override func viewDidLayoutSubviews() {
        scrollViewInstance.contentSize = CGSize(width: scrollViewInstance.frame.width, height: addDealBtnInstance.frame.origin.y+addDealBtnInstance.frame.height+10)
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollViewInstance.contentOffset = CGPoint(x: 0, y: scrollViewInstance.contentOffset.y)
    }
    @objc func keyboardWasShown(notification: NSNotification) {
        print("keyboardWasShown")
        let targetFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let contentInsets:UIEdgeInsets = UIEdgeInsets(top: view.frame.origin.x, left: view.frame.origin.y, bottom: targetFrame.height + 2, right: 0)
        scrollViewInstance.contentInset = contentInsets
        scrollViewInstance.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        print("keyboardWillHide")
        let zero:UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        self.scrollViewInstance.contentInset = zero;
        self.scrollViewInstance.scrollIndicatorInsets = zero;
    }

    //MARK: loadingSpecialityListAPI
    func loadingSpecialityListAPI(loadFrom:Int)
    {
        
        var parameters = Dictionary<String, Any>()
        parameters["doctor_id"] = UserDefaults.standard.value(forKey: "user_id") ?? 0 as Int
        
        
        GenericMethods.showLoaderMethod(shownView: self.view, message: "Loading")
        
        apiManager.specialityListAPI(parameters: parameters) { (status, showError, response, error) in
            
            GenericMethods.hideLoaderMethod(view: self.view)
            
            if status == true {
                self.specialityListData = response
                
                if self.specialityListData?.status?.code == "0" {
                    //MARK: Speciality List  Success Details
                    
                    
                }
                else
                {
                    GenericMethods.showAlertwithPopNavigation(alertMessage: self.specialityListData?.status?.message ?? "Unable to fetch data. Please try again after sometime.", vc: self)
                    
                }
                
                
            }
            else {
                GenericMethods.showAlertwithPopNavigation(alertMessage: error?.localizedDescription ?? "Something Went Wrong. Please try again.", vc: self)
            }
        }
    }
    
    //MARK: IBActions
    
    @IBAction func selectSpecialityBtnClick(_ sender: Any)
    {
        let optionsController = UIAlertController(title: "Select Speciality", message: nil, preferredStyle: .actionSheet)
        optionsController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        
        optionsController.view.tintColor = AppConstants.khudColour
        
        let subView: UIView? = optionsController.view.subviews.first
        let alertContentView: UIView? = subView?.subviews.first
        alertContentView?.backgroundColor = UIColor.white
        alertContentView?.layer.cornerRadius = 5
        for i in 0..<(self.specialityListData?.specialityData?.count ?? 0) {
            var action = UIAlertAction()
            
            action = UIAlertAction(title: self.specialityListData?.specialityData?[i].name ?? "", style: .default, handler: { action in
                
                self.selectSpecialityBtnInstance.setTitle(self.specialityListData?.specialityData?[i].name ?? "", for: .normal)
                
                self.specialityId = "\(self.specialityListData?.specialityData?[i].id ?? "0")"
                print("specialityId \(self.specialityId) ")
                
               
                
            })
            optionsController.addAction(action)
        }
        optionsController.modalPresentationStyle = .popover
        
        let popPresenter: UIPopoverPresentationController? = optionsController.popoverPresentationController
        popPresenter?.sourceView = selectSpecialityView
        popPresenter?.sourceRect = selectSpecialityView?.bounds ?? CGRect.zero
        DispatchQueue.main.async(execute: {
            //    self.hud.hide(animated: true)
            //[self.tableView reloadData];
            UIApplication.shared.topMostViewController()?.present(optionsController, animated: true)
        })
    }
    @IBAction func addDealBtnClick(_ sender: Any)
    {
        if GenericMethods.isStringEmpty(specialityId)
        {
            GenericMethods.showAlert(alertMessage: "Please select Speciality")
        }
        else if GenericMethods.isStringEmpty(titleTF.text)
        {
            GenericMethods.showAlert(alertMessage: "Please enter title")
        }
        else if GenericMethods.isStringEmpty(detailsTextView.text)
        {
            GenericMethods.showAlert(alertMessage: "Please enter details")
        }
        else if GenericMethods.isStringEmpty(rateTF.text)
        {
            GenericMethods.showAlert(alertMessage: "Please enter rate")
        }
        else if GenericMethods.isStringEmpty(discountPercentageTF.text)
        {
            GenericMethods.showAlert(alertMessage: "Please enter discount")
        }
        else if Int(rateTF.text!)! < 1
        {
            GenericMethods.showAlert(alertMessage: "Rate should be more than 1 KWD")
        }
        else if Int(discountPercentageTF.text!)! > 100
        {
            GenericMethods.showAlert(alertMessage: "Discount should be below 100")
        }
        else
        {
            
            var parameters = Dictionary<String, Any>()
            parameters["doctor_id"] = UserDefaults.standard.value(forKey: "user_id") ?? 0 as Int
            parameters["speciality_id"] = Int(specialityId)
            parameters["title"] = titleTF.text
            parameters["description"] = detailsTextView.text!
            parameters["amount"] = rateTF.text
            parameters["percentage"] = discountPercentageTF.text
            
            
            GenericMethods.showLoaderMethod(shownView: self.view, message: "Loading")
            
            apiManager.addDealsAPI(parameters: parameters) { (status, showError, response, error) in
                
                GenericMethods.hideLoaderMethod(view: self.view)
                
                if status == true {
                    self.addDealsListData = response
                    
                    if self.addDealsListData?.status?.code == "0" {
                        //MARK: Speciality List  Success Details
                        
                        GenericMethods.showAlertwithPopNavigation(alertMessage: self.addDealsListData?.status?.message ?? "Sucess", vc: self)
                        
                    }
                    else
                    {
                        
                        GenericMethods.showAlert(alertMessage:self.addDealsListData?.status?.message ?? "Unable to fetch data. Please try again after sometime.")
                        
                        
                    }
                    
                    
                }
                else {
                    
                    GenericMethods.showAlert(alertMessage:error?.localizedDescription ?? "Something Went Wrong. Please try again.")
                }
            }
        }
    }
    

}
extension DealsViewController:UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case discountPercentageTF:
            let maxLength = 3
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        default:
            return true
        }
        
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == titleTF
        {
            let _ = titleTF.resignFirstResponder()
            let _ = detailsTextView.becomeFirstResponder()
        }
        return true
    }
}
extension DealsViewController:UITextViewDelegate
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
    func textViewDidBeginEditing(_ textView: UITextView) {
        let scrollPoint : CGPoint = CGPoint(x:0 , y: detailsTextView.frame.origin.y)
        self.scrollViewInstance.setContentOffset(scrollPoint, animated: true)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let zero:UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.scrollViewInstance.contentInset = zero;
    }
}
