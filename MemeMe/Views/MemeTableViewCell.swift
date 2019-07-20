//
//  MemeTableViewCell.swift
//  MemeMe
//
//  Created by Reem on 27/04/2019.
//  Copyright © 2019 Reem. All rights reserved.
//

import UIKit

class MemeTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var topLbl: UILabel!
    @IBOutlet weak var bottomLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        memeImageView.contentMode = .scaleAspectFill
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        self.memeImageView.image = UIImage()
        self.topLbl.text = "TOP"
        self.bottomLbl.text = "BOTTOM"
    }
    
}
