//
//  NickNameVC.swift
//  Messenger
//
//  Created by Kemal Bayar [Mobil Yazilim  Servisi] on 26/07/2017.
//  Copyright © 2017 Kemal Bayar. All rights reserved.
//

import UIKit

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
        if (self.nickNameTF.text?.characters.count)!>0{
            self.performSegue(withIdentifier: "openChatGroupSegue", sender: nil)
        }
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
