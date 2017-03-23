//
//  MemeTableViewCell.swift
//  MemeMe
//
//  Created by Nikko on 3/16/17.
//  Copyright © 2017 Nikko Sanchez. All rights reserved.
//

import UIKit

class MemeTableViewCell: UITableViewCell {
    @IBOutlet weak var memeImage: UIImageView!
    @IBOutlet weak var memeTextLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        fonts()
    }
    
    func fonts() {
        memeTextLabel.font.withSize(10)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
