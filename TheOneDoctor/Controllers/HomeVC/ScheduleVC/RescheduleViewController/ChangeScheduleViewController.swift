//
//  ChangeScheduleViewController.swift
//  TheOneDoctor
//
//  Created by MyMac on 26/05/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import UIKit

class ChangeScheduleViewController: UIViewController {

    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var closeBtnInst: UIButton!
    
    @IBOutlet weak var scrollViewInstance: UIScrollView!
    @IBOutlet weak var delayedSlotsView: UIView!
    @IBOutlet weak var delayedSlotsBtnInst: UIButton!
    @IBOutlet weak var reasonTextView: UITextView!
    @IBOutlet weak var submitBtnInstance: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        delayedSlotsView.layer.addBorder(edge: .bottom, color: AppConstants.appdarkGrayColor, thickness: 1.0)
        
        GenericMethods.roundedCornerTextView(textView:reasonTextView)
        GenericMethods.setButtonAttributes(button: submitBtnInstance, with: "Submit")
        
        let numberToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        numberToolbar.barStyle = .default
        numberToolbar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneWithNumberPad))]
        numberToolbar.sizeToFit()
        reasonTextView.inputAccessoryView = numberToolbar

        // Do any additional setup after loading the view.
    }
    @objc func doneWithNumberPad()
    {
        let _ = reasonTextView.resignFirstResponder()
        
    }
    override func viewDidLayoutSubviews() {
        scrollViewInstance.contentSize = CGSize(width: scrollViewInstance.frame.width, height: submitBtnInstance.frame.origin.y+submitBtnInstance.frame.height+10)
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollViewInstance.contentOffset = CGPoint(x: 0, y: scrollViewInstance.contentOffset.y)
    }
    
    @IBAction func closeBtnClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func delayedSlotsBtnClick(_ sender: Any) {
    }
    @IBAction func submitBtnClick(_ sender: Any) {
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
        return textView.text.count + (text.count - range.length) <= 250
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
