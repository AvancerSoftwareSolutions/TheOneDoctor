//
//  OTPVerificationViewController.swift
//  TheOneDoctor
//
//  Created by MyMac on 06/05/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import UIKit

class OTPVerificationViewController: UIViewController {

    //MARK:- IBOutlets
    @IBOutlet weak var tf1: UITextField!
    @IBOutlet weak var tf2: UITextField!
    @IBOutlet weak var tf3: UITextField!
    @IBOutlet weak var tf4: UITextField!
    
    @IBOutlet weak var resendOTPBtnInstance: UIButton!
    @IBOutlet weak var verifyBtnInstance: UIButton!
    
    //MARK:- Variables
    var otp = ""
    var mobileNumber = ""
    var pinString = ""
    let apiManager = APIManager()
    var loginData:LoginModel?
    var loginUserData:LoginUserDataModel?
    var sendOTPData:SendOTPModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pinString = otp
        
        GenericMethods.setButtonAttributes(button: verifyBtnInstance, with: "VERIFY")
        
        tf1.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor.black, thickness: 1.0)
        tf2.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor.black, thickness: 1.0)
        tf3.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor.black, thickness: 1.0)
        tf4.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor.black, thickness: 1.0)
        
        let numberToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        numberToolbar.barStyle = .default
        numberToolbar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneWithNumberPad))]
        numberToolbar.sizeToFit()
        tf1.inputAccessoryView = numberToolbar
        tf2.inputAccessoryView = numberToolbar
        tf3.inputAccessoryView = numberToolbar
        tf4.inputAccessoryView = numberToolbar
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        let digits = otp.compactMap{Int(String($0))}
        tf1.text = "\(digits[0])"
        tf2.text = "\(digits[1])"
        tf3.text = "\(digits[2])"
        tf4.text = "\(digits[3])"
    }
    @objc func doneWithNumberPad()
    {
        self.view.endEditing(true)
        if pinValidationMethod()
        {
            verifyMethod()
        }
    }
    func pinValidationMethod() -> Bool
    {
        pinString = ""
        if GenericMethods.isStringEmpty(tf1.text) || GenericMethods.isStringEmpty(tf2.text) || GenericMethods.isStringEmpty(tf3.text) || GenericMethods.isStringEmpty(tf4.text)
        {
            GenericMethods.showAlert(alertMessage: "Please enter valid OTP")
            return false
        }
        let _ = tf4.resignFirstResponder()
        print("\(tf1.text!)\(tf2.text!)\(tf3.text!)\(tf4.text!)")
        let pin = "\(tf1.text!)\(tf2.text!)\(tf3.text!)\(tf4.text!)"
        print("pin \(pin)")
        pinString = pin
        return true
    }


    // MARK: - IBActions
    
    @IBAction func resendOTPBtnClick(_ sender: Any)
    {
        
        let randomNumber = AppConstants.fourDigitNumber
        
        
        var parameters = Dictionary<String, Any>()
        parameters["mobile"] = mobileNumber
        parameters["Type"] = "Login"
        parameters["OTP"] = randomNumber
        
        GenericMethods.showLoaderMethod(shownView: self.view, message: "Loading")
        apiManager.sendOTPAPI(parameters: parameters) { (status, showError, response, error) in
            
            GenericMethods.hideLoaderMethod(view: self.view)
            
            if status == true {
                self.sendOTPData = response
                
                if self.sendOTPData?.status?.code == "0" {
                    //MARK: Login Success Details
                    
                    self.otp = randomNumber
                    let digits = self.otp.compactMap{Int(String($0))}
                    self.tf1.text = "\(digits[0])"
                    self.tf2.text = "\(digits[1])"
                    self.tf3.text = "\(digits[2])"
                    self.tf4.text = "\(digits[3])"
                    let alert = UIAlertController(title: nil, message: self.sendOTPData?.status?.message ?? "", preferredStyle: .alert)
                    
                    UIApplication.shared.topMostViewController()?.present(alert, animated: true)
                    let duration: Int = 1 // duration in seconds
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Double(duration) * Double(NSEC_PER_SEC)) / Double(NSEC_PER_SEC), execute: {
                        alert.dismiss(animated: true)
                        // dashboardVC
                        
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
    @IBAction func verifyBtnClick(_ sender: Any) {
        if pinValidationMethod()
        {
           verifyMethod()
        }
    }
    func verifyMethod()
    {
        self.view.endEditing(true)
        if GenericMethods.isStringEmpty(self.pinString)
        {
            GenericMethods.showAlert(alertMessage: "Please enter valid OTP")
        }
        else if otp != pinString
        {
            GenericMethods.showAlert(alertMessage: "Please enter valid OTP")
        }
        else
        {
            
            var parameters = Dictionary<String, Any>()
            parameters["mobile"] = mobileNumber
            parameters["token"] = UserDefaults.standard.value(forKey: "device_token") as? String ?? ""
            parameters["device_id"] = UIDevice.current.identifierForVendor?.uuidString
            
            GenericMethods.showLoaderMethod(shownView: self.view, message: "Loading")
            
            apiManager.loginAPI(parameters: parameters) { (status, showError, response, error) in
                
                GenericMethods.hideLoaderMethod(view: self.view)
                
                if status == true {
                    self.loginData = response
                    if self.loginData?.status?.code == "0" {
                        //MARK: Login Success Details
                        UserDefaults.standard.set(self.loginData?.userData?.userId, forKey: "user_id")
                        UserDefaults.standard.set(self.loginData?.userData?.userImg, forKey: "user_image")
                        UserDefaults.standard.set(self.loginData?.userData?.gender, forKey: "gender")
                        
                        let alert = UIAlertController(title: nil, message: self.loginData?.status?.message ?? "", preferredStyle: .alert)
                        UIApplication.shared.topMostViewController()?.present(alert, animated: true)
                        let duration: Int = 1 // duration in seconds
                        
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Double(duration) * Double(NSEC_PER_SEC)) / Double(NSEC_PER_SEC), execute: {
                            alert.dismiss(animated: true)
                            // dashboardVC
                            GenericMethods.navigateToDashboard()
                            
                        })
                        
                    }
                    else
                    {
                        GenericMethods.showAlert(alertMessage: self.loginData?.status?.message ?? "Unable to fetch data. Please try again after sometime.")
                    }
                    
                }
                else {
                    GenericMethods.showAlert(alertMessage:error?.localizedDescription ?? "")
                    
                }
            }
        }
    }
    func navigateToDashboardVC()
    {
        let storyboard: UIStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
        let dashNavigateVC = storyboard.instantiateViewController(withIdentifier: "dashNavigateVC") as! DashboardNavigateVC
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.window?.rootViewController = dashNavigateVC
        appDelegate?.window?.makeKeyAndVisible()
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
extension OTPVerificationViewController:UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        if (string != "") {
            textField.text = string;
            switch textField
            {
            case tf1:
                tf2.becomeFirstResponder()
            case tf2:
                tf3.becomeFirstResponder()
            case tf3:
                tf4.becomeFirstResponder()
            case tf4:
                return pinValidationMethod()
            default:
                return false
            }
            return false
        }
        else
        {
            textField.text = ""
            switch textField
            {
                //            case tf1:
            //                tf1.resignFirstResponder()
            case tf2:
                tf1.becomeFirstResponder()
            case tf3:
                tf2.becomeFirstResponder()
            case tf4:
                tf3.becomeFirstResponder()
                print("dismiss")
            default:
                return false
            }
            return false
        }
        //        return true
    }
    func jump(toNextTextField textField: UITextField?, withTag tag: Int) {
        // Gets the next responder from the view. Here we use self.view because we are searching for controls with
        // a specific tag, which are not subviews of a specific views, because each textfield belongs to the
        // content view of a static table cell.
        //
        // In other cases may be more convenient to use textField.superView, if all textField belong to the same view.
        let nextResponder: UIResponder? = view.viewWithTag(tag)
        print("jumptag is \(tag)")
        if (nextResponder is UITextField) {
            // If there is a next responder and it is a textfield, then it becomes first responder.
            nextResponder?.becomeFirstResponder()
        } else {
            // If there is not then removes the keyboard.
            textField?.resignFirstResponder()
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text!.isEmpty
        {
            textField.text = "\u{200B}"
        }
    }
}
