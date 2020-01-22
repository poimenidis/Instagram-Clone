//
//  UserChatTableViewCell.swift
//  Instagram
//
//  Created by Kostas Poimenidis on 18/1/20.
//  Copyright © 2020 Kostas Poimenidis. All rights reserved.
//

import UIKit

class UserChatTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageUser: UIImageView!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
