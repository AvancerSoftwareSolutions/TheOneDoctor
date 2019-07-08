//
//  ChangeScheduleViewController.swift
//  TheOneDoctor
//
//  Created by MyMac on 26/05/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import UIKit
protocol refreshLoadingDelegate {
    func refreshDelegateMethod(day:String,selectedDate:Date)
}
class ChangeScheduleViewController: UIViewController {

    //MARK: IBOutlets
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var closeImgView: UIImageView!
    
    
    @IBOutlet weak var scrollViewInstance: UIScrollView!
    @IBOutlet weak var delayedSlotsView: UIView!
    @IBOutlet weak var delayedSlotsBtnInst: UIButton!
    @IBOutlet weak var reasonTextView: UITextView!
    @IBOutlet weak var submitBtnInstance: UIButton!
    //MARK: Variables
    var numberOfSlots = ""
    var rescheduleListData:RescheduleModel?
    let apiManager = APIManager()
    var dayStr = ""
    var selectedDate = Date()
    var delegate:refreshLoadingDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        popupView.layer.cornerRadius = 10.0
        popupView.layer.masksToBounds = true
        closeImgView.layer.cornerRadius = 15.0
        closeImgView.layer.masksToBounds = true
        closeImgView.layer.borderWidth = 0.3
        closeImgView.layer.borderColor = #colorLiteral(red: 0.9098039216, green: 0.9098039216, blue: 0.9098039216, alpha: 1)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeMethod))
        self.closeImgView.addGestureRecognizer(tapGesture)
        
        GenericMethods.roundedCornerTextView(textView:reasonTextView)
        GenericMethods.setButtonAttributes(button: submitBtnInstance, with: "Submit")
        
        let numberToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        numberToolbar.barStyle = .default
        numberToolbar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneWithNumberPad))]
        numberToolbar.sizeToFit()
        reasonTextView.inputAccessoryView = numberToolbar
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        delayedSlotsView.layer.addBorder(edge: .bottom, color: AppConstants.appdarkGrayColor, thickness: 1.0)
    }
    @objc func closeMethod()
    {
        self.dismiss(animated: true, completion: nil)
    }
    @objc func doneWithNumberPad()
    {
        let _ = reasonTextView.resignFirstResponder()
        
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
    override func viewDidLayoutSubviews() {
        scrollViewInstance.contentSize = CGSize(width: scrollViewInstance.frame.width, height: submitBtnInstance.frame.origin.y+submitBtnInstance.frame.height+10)
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollViewInstance.contentOffset = CGPoint(x: 0, y: scrollViewInstance.contentOffset.y)
    }
    
    
    @IBAction func delayedSlotsBtnClick(_ sender: Any) {
        let optionsController = UIAlertController(title: "Select No. of slots", message: nil, preferredStyle: .actionSheet)
        
        
        optionsController.view.tintColor = AppConstants.khudColour
        
        let subView: UIView? = optionsController.view.subviews.first
        let alertContentView: UIView? = subView?.subviews.first
        alertContentView?.backgroundColor = UIColor.white
        alertContentView?.layer.cornerRadius = 5
        for i in 1..<11 {
            var action = UIAlertAction()
            
            action = UIAlertAction(title: "\(i)", style: .default, handler: { action in
                
                self.delayedSlotsBtnInst.setTitle("\(i)", for: .normal)
                
                self.numberOfSlots = "\(i)"
                
            })
            optionsController.addAction(action)
        }
        optionsController.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: nil))
        optionsController.modalPresentationStyle = .popover
        
        let popPresenter: UIPopoverPresentationController? = optionsController.popoverPresentationController
        popPresenter?.sourceView = delayedSlotsView
        popPresenter?.sourceRect = delayedSlotsView?.bounds ?? CGRect.zero
        DispatchQueue.main.async(execute: {
            //    self.hud.hide(animated: true)
            //[self.tableView reloadData];
            UIApplication.shared.topMostViewController()?.present(optionsController, animated: true)
        })
    }
    @IBAction func submitBtnClick(_ sender: Any)
    {
        if GenericMethods.isStringEmpty(self.numberOfSlots)
        {
            GenericMethods.showAlert(alertMessage: "Please select number of slots")
        }
        else if GenericMethods.isStringEmpty(self.reasonTextView.text)
        {
            GenericMethods.showAlert(alertMessage: "Please enter reason")
        }
        else
        {
            let postDateFormatter = DateFormatter()
            postDateFormatter.dateFormat = AppConstants.postDateFormat
            var parameters = Dictionary<String, Any>()
            parameters["doctor_id"] = UserDefaults.standard.value(forKey: "user_id") ?? 0 as Int
            parameters["day"] = dayStr
            parameters["date"] = postDateFormatter.string(from:selectedDate)
            parameters["reason"] = reasonTextView.text
            parameters["delaycount"] = Int(numberOfSlots)!
            parameters["type"] = 1
            
            GenericMethods.showLoaderMethod(shownView: self.view, message: "Loading")
            
            apiManager.delaySlotsDetailsAPI(parameters: parameters) { (status, showError, response, error) in
                
                GenericMethods.hideLoaderMethod(view: self.view)
                
                if status == true {
                    self.rescheduleListData = response
                    
                    
                    if self.rescheduleListData?.status?.code == "0"
                    {
                        GenericMethods.showAlertWithCompletionHandler(alertMessage: self.rescheduleListData?.status?.message ?? "Success", completionHandlerForOk: { (alert) in
                            self.dismiss(animated: true, completion: {
                                self.delegate?.refreshDelegateMethod(day: self.dayStr, selectedDate: self.selectedDate)
                            })
                        })
                    }
                    else
                    {
                        GenericMethods.showAlert(alertMessage: self.rescheduleListData?.status?.message ?? "Unable to fetch data. Please try again after sometime.")
                        
                        
                    }
                    
                    
                }
                else {
                    GenericMethods.showAlert(alertMessage: error?.localizedDescription ?? "Something Went Wrong. Please try again.")
                    
                    
                    
                    
                }
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
extension ChangeScheduleViewController:UITextViewDelegate
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
        let scrollPoint : CGPoint = CGPoint(x:0 , y: reasonTextView.frame.origin.y)
        self.scrollViewInstance.setContentOffset(scrollPoint, animated: true)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let zero:UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.scrollViewInstance.contentInset = zero;
    }
}
