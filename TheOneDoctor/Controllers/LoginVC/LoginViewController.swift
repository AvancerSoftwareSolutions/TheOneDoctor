//
//  LoginViewController.swift
//  TheOneDoctor
//
//  Created by MyMac on 06/05/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {

    //MARK:- IBOutlets
    @IBOutlet weak var mobileLeftView: UIView!
    @IBOutlet weak var mobileCodeLbl: UILabel!
    @IBOutlet weak var mobileTF: UITextField!
    @IBOutlet weak var sendOTPBtnInstance: UIButton!
    
    //MARK:- Variables
    var sendOTPData:SendOTPModel?
    let apiManager = APIManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GenericMethods.setButtonAttributes(button: sendOTPBtnInstance, with: "SEND OTP")
        GenericMethods.setLeftViewWithSVG(svgView: mobileLeftView, with: "phone", color: AppConstants.appGreenColor)
        
        let numberToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        numberToolbar.barStyle = .default
        numberToolbar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneWithNumberPad))]
        numberToolbar.sizeToFit()
        mobileTF.inputAccessoryView = numberToolbar

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    @objc func doneWithNumberPad()
    {
        let _ = mobileTF.resignFirstResponder()
    }
    // MARK: - IBActions
    
    @IBAction func sendOTPBtnClick(_ sender: Any) {
        if GenericMethods.isStringEmpty(mobileTF.text)
        {
            GenericMethods.showAlert(alertMessage: "Please enter mobile number")
        }
        else if mobileTF.text!.count < 8
        {
            GenericMethods.showAlert(alertMessage: "Please enter valid mobile number")
        }
        else
        {
            
            let randomNumber = AppConstants.fourDigitNumber
            
            
            var parameters = Dictionary<String, Any>()
            parameters["mobile"] = mobileTF.text
            parameters["Type"] = "Login"
            parameters["OTP"] = randomNumber
            
            GenericMethods.showLoaderMethod(shownView: self.view, message: "Loading")
            apiManager.sendOTPAPI(parameters: parameters) { (status, showError, response, error) in
                
                GenericMethods.hideLoaderMethod(view: self.view)
                
                if status == true {
                    self.sendOTPData = response
                    
                    if self.sendOTPData?.status?.code == "0" {
                        //MARK: Login Success Details
                       
                        let alert = UIAlertController(title: nil, message: self.sendOTPData?.status?.message ?? "", preferredStyle: .alert)
                        
                        UIApplication.shared.topMostViewController()?.present(alert, animated: true)
                        let duration: Int = 1 // duration in seconds
                        
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Double(duration) * Double(NSEC_PER_SEC)) / Double(NSEC_PER_SEC), execute: {
                            alert.dismiss(animated: true)
                            // dashboardVC
                            let otpVC = self.storyboard?.instantiateViewController(withIdentifier: "otpVC") as! OTPVerificationViewController
                            otpVC.otp = randomNumber
                            otpVC.mobileNumber = self.mobileTF.text!
                            let transition:CATransition = CATransition()
                            transition.duration = 0.3
                            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                            transition.type = CATransitionType.push
                            transition.subtype = CATransitionSubtype.fromRight
                            self.view.layer.add(transition, forKey: kCATransition)
                            self.present(otpVC, animated: false, completion: nil)
                            
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
//        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut, animations: {
//            self.present(otpVC, animated: false, completion: nil)
//        }, completion: nil)
        
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
extension LoginViewController:UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            let maxLength = 8
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
    }
}
