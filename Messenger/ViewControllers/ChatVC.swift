//
//  ChatVC.swift
//  Messenger
//
//  Created by Kemal Bayar [Mobil Yazilim  Servisi] on 27/07/2017.
//  Copyright © 2017 Kemal Bayar. All rights reserved.
//

import UIKit
import Alamofire
import JGProgressHUD

class ChatVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    var serviceResponseModel:MessageServiceResponseModel!
    var ownNickName:String = ""
    var messageArray:NSMutableArray = []
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var collectionViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageViewHeightConstraint: NSLayoutConstraint!
    private var keyboardHeight: CGFloat = 0.0
    private var messageViewHeight: CGFloat = 50.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.callMessagesWebService()
        
        let defaults:UserDefaults = UserDefaults.standard
        ownNickName = defaults.string(forKey: "nickName")!
        self.title = ownNickName
        
        self.sendButton.isEnabled = false
        
        //for override backButton
        let backButton = UIBarButtonItem(title: "Leave", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ChatVC.goBack))
        navigationItem.leftBarButtonItem = backButton
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardChange(_:)), name:  Notification.Name.UIKeyboardWillChangeFrame, object: nil)

    }
    func addOwmMessage(message:String){
        let cellModel = MessageCellModel.init(pDirection: MessageDirection.Right, pText:message , pNickName: self.ownNickName, pImage: "")
        self.messageArray.add(cellModel)
        self.collectionView.reloadData()
    }
    func fillMessageModelFromResponse(response:MessageServiceResponseModel!){
        for Message in response.messages! {
            let cellData = MessageCellModel.init(pDirection: MessageDirection.Left, pText: Message.text!, pNickName: (Message.user?.nickname)!, pImage: (Message.user?.avatarUrl)!)
            self.messageArray.add(cellData)
        }
        self.collectionView.reloadData()
    }
    
    func keyboardChange(_ notification : NSNotification){
        if let userInfo = notification.userInfo {
            guard let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
            
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            
            
            if endFrame.origin.y >= UIScreen.main.bounds.size.height {
                self.messageTextView.resignFirstResponder()
                if self.collectionViewBottomConstraint.constant != self.messageViewHeight {
                    self.collectionView.contentOffset.y = self.collectionView.contentOffset.y - (endFrame.size.height)
                    self.collectionViewBottomConstraint.constant = self.messageViewHeight
                }
            } else {
                if self.collectionViewBottomConstraint.constant != (endFrame.size.height) + self.messageViewHeight {
                    self.collectionView.contentOffset.y = self.collectionView.contentOffset.y + (endFrame.size.height)
                }
                self.collectionViewBottomConstraint.constant = (endFrame.size.height) + self.messageViewHeight
                keyboardHeight = endFrame.size.height
            }
            
            UIView.animate(withDuration: duration, delay: TimeInterval(0), options: animationCurve, animations: {
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
            }, completion: nil)
            
        }
    }

    
    func goBack() {
        let defaults:UserDefaults = UserDefaults.standard
        defaults.set(nil, forKey: "nickName")
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - TextView Delegate -
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        self.scrollToBottom()
        return true
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        
        self.sendButton.isEnabled = textView.text?.trimmingCharacters(in: .whitespacesAndNewlines) != ""
        
    }
    

    
    func scrollToBottom(){

        let item = self.collectionView(self.collectionView!, numberOfItemsInSection: 0) - 1
        let lastItemIndex = NSIndexPath.init(item: item, section: 0)
        self.collectionView?.scrollToItem(at: lastItemIndex as IndexPath, at: UICollectionViewScrollPosition.top, animated: true)
    }
    
    // MARK: - Call WebService
    
    func callMessagesWebService(){
        let loading = JGProgressHUD.init(style: JGProgressHUDStyle.dark)
        loading?.textLabel.text = "Loading"
        loading?.show(in: self.view)
        Alamofire.request(
            URL(string: "https://jsonblob.com/api/jsonBlob/3cf871b2-f7cd-11e6-95c2-115605632e53")!,
            method: .get,
            parameters: [:])
            .validate()
            .responseJSON { (response) -> Void in
                loading?.dismiss()
                guard response.result.isSuccess else {
                    print("Error")
                    
                    return
                }
                NSLog("success")
                
                self.messageArray = NSMutableArray.init()
                self.serviceResponseModel = MessageServiceResponseModel.init(dictionary: response.result.value as! NSDictionary)
                self.fillMessageModelFromResponse(response: self.serviceResponseModel)
        }
    }
    
    // MARK: - collectionView delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.messageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cellData = messageArray[indexPath.row] as! MessageCellModel
        var cellIdentifier:String
        if cellData.direction == MessageDirection.Left {
            cellIdentifier = "LeftMessage"
        }else{
            cellIdentifier = "RightMessage"
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! MessageCollectionViewCell
        cell.setupCell(cellData: cellData)
        cell.setNeedsDisplay()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let model = self.messageArray[indexPath.row] as! MessageCellModel
        let dummyLabel = UILabel(frame: CGRect(x:0, y:0, width:(self.view.frame.width - 76), height: CGFloat.greatestFiniteMagnitude))
        dummyLabel.numberOfLines = 0
        dummyLabel.font = UIFont.systemFont(ofSize: 17)
        dummyLabel.text = model.text
        dummyLabel.sizeToFit()
        
        let cellHeight = (dummyLabel.frame.height + 53) > 80 ? (dummyLabel.frame.height + 53) : 80
        
        return CGSize(width: self.view.frame.size.width, height: cellHeight)
    }

    
    @IBAction func pressedSendButton(_ sender: Any) {
        if messageTextView.text != "" {
           let messageString = self.messageTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            self.messageTextView.text = ""
            self.addOwmMessage(message: messageString!)
            self.sendButton.isEnabled = false
            self.scrollToBottom()
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
