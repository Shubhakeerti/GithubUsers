//
//  UserCell.swift
//  GitHubUsers
//
//  Created by Shubhakeerti on 17/04/18.
//  Copyright © 2018 Shubhakeerti. All rights reserved.
//

import UIKit
import SDWebImage

class UserCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(_ dataSetup: UserStruct) {
        self.avatarImageView.sd_setImage(with: URL(string: dataSetup.avatar!), placeholderImage:UIImage())
        self.titleLabel.text = dataSetup.name!
    }
    
}
