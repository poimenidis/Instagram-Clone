//
//  SearchViewCell.swift
//  Instagram
//
//  Created by Kostas Poimenidis on 12/1/20.
//  Copyright © 2020 Kostas Poimenidis. All rights reserved.
//

import UIKit

class SearchViewCell: UITableViewCell {

    @IBOutlet weak var nameTextview: UILabel!
    @IBOutlet weak var imageview: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
