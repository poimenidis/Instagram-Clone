//
//  FriendChatTableViewCell.swift
//  Instagram
//
//  Created by Kostas Poimenidis on 18/1/20.
//  Copyright © 2020 Kostas Poimenidis. All rights reserved.
//

import UIKit

class FriendChatTableViewCell: UITableViewCell {

    @IBOutlet weak var imageFriend: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var message: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
