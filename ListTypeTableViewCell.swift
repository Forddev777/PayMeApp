//
//  ListTypeTableViewCell.swift
//  PayMeApp
//
//  Created by suriya taothongkom on 13/1/2566 BE.
//

import UIKit

class ListTypeTableViewCell: UITableViewCell {
    @IBOutlet weak var Header: UILabel!
    @IBOutlet weak var Detail: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
