//
//  SettingsViewController.swift
//  TheOneDoctor
//
//  Created by MyMac on 19/06/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var settingsTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"
        
        settingsTableView.tableFooterView = UIView()
        
        // Do any additional setup after loading the view.
    }


}
extension SettingsViewController:UITableViewDelegate,UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let settingsCell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath)
        settingsCell.textLabel?.text = "Logout"
        return settingsCell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        GenericMethods.showYesOrNoAlertWithCompletionHandler(alertTitle: "Are you sure want to Logout", alertMessage: "") { (UIAlertAction) in
            GenericMethods.resetDefaults()
            GenericMethods.navigateToLogin()
        }
    }
}
