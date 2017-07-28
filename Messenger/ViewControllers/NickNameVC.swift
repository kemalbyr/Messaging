//
//  NickNameVC.swift
//  Messenger
//
//  Created by Kemal Bayar [Mobil Yazilim  Servisi] on 26/07/2017.
//  Copyright © 2017 Kemal Bayar. All rights reserved.
//

import UIKit
import EZAlertController

class NickNameVC: UIViewController {

    @IBOutlet weak var nickNameTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pressedContinueButton(_ sender: Any) {
        if (self.nickNameTF.text?.characters.count)!>2{
            self.performSegue(withIdentifier: "openChatGroupSegue", sender: nil)
            let defaults:UserDefaults = UserDefaults.standard
            defaults.set(self.nickNameTF.text, forKey: "nickName")
            
        }else{
           EZAlertController.alert("Warning", message: "Please enter a valid nickname (longer than two character)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let defaults = UserDefaults.standard
        let nickName = defaults.string(forKey: "nickName")
        if  nickName != nil {
            self.performSegue(withIdentifier: "openChatGroupSegue", sender: self)
        }
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
