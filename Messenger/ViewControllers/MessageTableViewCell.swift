//
//  MessageTableViewCell.swift
//  Messenger
//
//  Created by Kemal Bayar [Mobil Yazilim  Servisi] on 27/07/2017.
//  Copyright © 2017 Kemal Bayar. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var messageLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
