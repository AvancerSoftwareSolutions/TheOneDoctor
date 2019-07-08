//
//  EditMobileNumberViewController.swift
//  TheOneDoctor
//
//  Created by MyMac on 03/07/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import UIKit
import ACFloatingTextfield_Swift
protocol sendEditMobileNumberDelegate {
    func sendEditMobileMethod(mobileNo:String)
}

class EditMobileNumberViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var scrollViewInstance: UIScrollView!
    @IBOutlet weak var mobileTF: ACFloatingTextfield!
    @IBOutlet weak var sendOTPBtnInstance: UIButton!
    @IBOutlet weak var otpTF: ACFloatingTextfield!
    @IBOutlet weak var submitBtnInstance: UIButton!
    
    
    var mobileNumber = ""
    var randomNumber = ""
    let apiManager = APIManager()
    var sendOTPData:SendOTPModel?
    var delegate:sendEditMobileNumberDelegate? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Edit Mobile Number"
        GenericMethods.setButtonAttributes(button: sendOTPBtnInstance, with: "Send OTP")
        GenericMethods.setButtonAttributes(button: submitBtnInstance, with: "Submit")
        
        
        
        let countryCodeLbl = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 45))
        countryCodeLbl.text = "+961"
        countryCodeLbl.textAlignment = .center
        countryCodeLbl.font = UIFont.systemFont(ofSize: 15)
        mobileTF.leftView = countryCodeLbl
        
        
        let mobileNumberToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        mobileNumberToolbar.barStyle = .default
        mobileNumberToolbar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneWithMobile))]
        mobileNumberToolbar.sizeToFit()
        mobileTF.inputAccessoryView = mobileNumberToolbar
        otpTF.inputAccessoryView = mobileNumberToolbar
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        hideViews(text:"")
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.mobileTF.text = mobileNumber
    }
    @objc func doneWithMobile()
    {
        let _ = mobileTF.resignFirstResponder()
        if mobileTF.text!.count == 8 && mobileTF.text! != self.mobileNumber
        {
            sendOTPMethod()
        }
    }
    override func viewDidLayoutSubviews() {
        scrollViewInstance.contentSize = CGSize(width: scrollViewInstance.frame.width, height: submitBtnInstance.frame.origin.y+submitBtnInstance.frame.height+10)
        
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
    func hideViews(text:String)
    {
        if GenericMethods.isStringEmpty(text)
        {
            self.otpTF.isHidden = true
            self.otpTF.text = text
            self.submitBtnInstance.isHidden = true
        }
        else
        {
            self.otpTF.isHidden = false
            self.otpTF.text = text
            self.submitBtnInstance.isHidden = false
        }
        
    }
    func sendOTPMethod()
    {
        randomNumber = AppConstants.fourDigitNumber
        
        var parameters = Dictionary<String, Any>()
        parameters["mobile"] = mobileTF.text
        parameters["Type"] = "Register"
        parameters["OTP"] = randomNumber
        
        GenericMethods.showLoaderMethod(shownView: self.view, message: "Loading")
        apiManager.sendOTPAPI(parameters: parameters) { (status, showError, response, error) in
            self.view.endEditing(true)
            GenericMethods.hideLoaderMethod(view: self.view)
            
            if status == true {
                self.sendOTPData = response
                
                if self.sendOTPData?.status?.code == "0" {
                    //MARK: sendOTP Success Details
                    
                    let alert = UIAlertController(title: nil, message: self.sendOTPData?.status?.message ?? "", preferredStyle: .alert)
                    
                    UIApplication.shared.topMostViewController()?.present(alert, animated: true)
                    let duration: Int = 1 // duration in seconds
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Double(duration) * Double(NSEC_PER_SEC)) / Double(NSEC_PER_SEC), execute: {
                        alert.dismiss(animated: true)
                        self.hideViews(text: self.randomNumber)
                    })
                    
                }
                else
                {
                    GenericMethods.showAlert(alertMessage: self.sendOTPData?.status?.message ?? "Unable to fetch data. Please try again after sometime.")
                }
                
            }
            else {
                GenericMethods.showAlert(alertMessage:error?.localizedDescription ?? "")
                
            }
        }
    }
    
    // MARK: - IBActions
    @IBAction func mobielEditChange(_ sender: UITextField) {
        if sender.text!.count == 8
        {
            if sender.text != self.mobileNumber
            {
                sendOTPMethod()
            }
            
        }
        else
        {
            hideViews(text: "")
        }
    }
    @IBAction func otpEditChange(_ sender: UITextField) {
        
    }
    @IBAction func sendOTPBtnClick(_ sender: Any) {
    }
    @IBAction func submitBtnClick(_ sender: Any) {
        
        if GenericMethods.isStringEmpty(otpTF.text)
        {
            GenericMethods.showAlert(alertMessage: "Please enter mobile number")
        }
        else if otpTF.text != self.randomNumber
        {
            GenericMethods.showAlert(alertMessage: "Invalid OTP")
        }
        else
        {
            self.dismiss(animated: true) {
                self.delegate?.sendEditMobileMethod(mobileNo: self.mobileTF.text!)
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
