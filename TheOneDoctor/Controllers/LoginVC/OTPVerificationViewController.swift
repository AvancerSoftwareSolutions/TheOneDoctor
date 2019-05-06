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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        tf1.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor.black, thickness: 1.0)
        tf2.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor.black, thickness: 1.0)
        tf3.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor.black, thickness: 1.0)
        tf4.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor.black, thickness: 1.0)
        
        let numberToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        numberToolbar.barStyle = .default
        numberToolbar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneWithNumberPad))]
        numberToolbar.sizeToFit()
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
        pinValidationMethod()
    }
    func pinValidationMethod()
    {
        if GenericMethods.isStringEmpty(tf1.text) || GenericMethods.isStringEmpty(tf2.text) || GenericMethods.isStringEmpty(tf3.text) || GenericMethods.isStringEmpty(tf4.text)
        {
            GenericMethods.showAlert(alertMessage: "Please enter valid pin")
            return
        }
        let _ = tf4.resignFirstResponder()
        print("\(tf1.text!)\(tf2.text!)\(tf3.text!)\(tf4.text!)")
        let pin = "\(tf1.text!)\(tf2.text!)\(tf3.text!)\(tf4.text!)"
        print("pin \(pin)")
    }


    // MARK: - IBActions
    
    @IBAction func resendOTPBtnClick(_ sender: Any) {
        
    }
    @IBAction func verifyBtnClick(_ sender: Any) {
        
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
                pinValidationMethod()
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
