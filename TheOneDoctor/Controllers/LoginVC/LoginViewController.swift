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
            let otpVC = self.storyboard?.instantiateViewController(withIdentifier: "otpVC") as! OTPVerificationViewController
            otpVC.otp = randomNumber
            otpVC.mobileNumber = mobileTF.text!
            let transition:CATransition = CATransition()
            transition.duration = 0.3
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromRight
            self.view.layer.add(transition, forKey: kCATransition)
            self.present(otpVC, animated: false, completion: nil)
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
