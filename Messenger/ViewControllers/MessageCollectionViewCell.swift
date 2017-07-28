//
//  MessageCollectionViewCell.swift
//  Messenger
//
//  Created by Kemal Bayar [Mobil Yazilim  Servisi] on 27/07/2017.
//  Copyright © 2017 Kemal Bayar. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire

enum MessageDirection{
    case Left, Right
}

class MessageCellModel: NSObject {
     init(pDirection:MessageDirection, pText:String, pNickName:String, pImage:String) {
        self.direction = pDirection
        self.text = pText
        self.nickName = pNickName
        self.image = pImage
    }
    
    public var direction:MessageDirection
    public var text:String
    public var nickName:String
    public var image:String

}


class MessageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var viewTextWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewText: UIView!
    
    func setupCell(cellData: MessageCellModel) {
        self.viewText.layer.cornerRadius = 3
        self.calculateWidthOfLabel(labelText: cellData.text)
        self.lblText.text = cellData.text
        self.lblName.text = cellData.nickName
        if cellData.direction == MessageDirection.Left {
            self.loadImage(url: cellData.image)
        }else{
            self.imageProfile.image = #imageLiteral(resourceName: "profilePicture")
        }
        
    }
    
    private func calculateWidthOfLabel(labelText: String) {
        
        let dummyLabel = UILabel(frame: CGRect(x:0, y:0, width:(self.contentView.frame.size.width - 76), height: CGFloat.greatestFiniteMagnitude))
        
        dummyLabel.numberOfLines = 0
        dummyLabel.lineBreakMode = .byWordWrapping
        dummyLabel.font =  UIFont.systemFont(ofSize: 17)
        dummyLabel.text = labelText
        dummyLabel.sizeToFit()
        
        let minimumWidth = 2 * CGFloat(3)
        var labelWidth = dummyLabel.frame.size.width > minimumWidth ? dummyLabel.frame.size.width : minimumWidth
        labelWidth = labelWidth > (self.contentView.frame.size.width - 76) ? self.contentView.frame.size.width - 76 : labelWidth
        self.viewTextWidthConstraint.constant = labelWidth + 53
        
        self.setNeedsUpdateConstraints()
        self.setNeedsLayout()
        self.layoutIfNeeded()
        self.updateConstraints()
    }

    private func loadImage(url:String){
        Alamofire.request(url, method: .get).responseImage { response in
            guard let image = response.result.value else {
                // Handle error
                return
            }
            self.imageProfile.image = image
        }
    
    }
}
