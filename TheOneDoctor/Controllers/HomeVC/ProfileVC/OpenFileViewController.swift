//
//  OpenFileViewController.swift
//  TheOneDoctor
//
//  Created by MyMac on 17/05/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import UIKit
import WebKit

class OpenFileViewController: UIViewController,WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    
    var openURLStr:String = ""
    var titleStr:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = titleStr ?? ""
        //        let myBlog = openURLStr
        //        print(myBlog as! String)
        print(openURLStr)
        let encodedUrl : String! = openURLStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) // remove the spaces in the url string
        
        let typeUrl = URL(string: encodedUrl)!
        //        guard let ur:NSURL = NSURL(string: openURLStr) else {
        //            return
        //        }
        print(typeUrl)
        //        let url = NSURL(string: openURLStr)!
        let request = NSURLRequest(url: typeUrl as URL)
        //        GenericMethods.showLoaderMethod(view: self.view, message: "Loading")
        
        //        webView = WKWebView(frame: self.view.frame)
        webView.navigationDelegate = self
        webView.load(request as URLRequest)
        //        self.view.addSubview(webView)
        //        self.view.sendSubviewToBack(webView)
        
        // Do any additional setup after loading the view.
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        GenericMethods.hideLoading()
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
