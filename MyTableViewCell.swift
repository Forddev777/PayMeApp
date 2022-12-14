//
//  MyTableViewCell.swift
//  PayMeApp
//
//  Created by suriya taothongkom on 4/12/2565 BE.
//

import UIKit

class MyTableViewCell: UITableViewCell {

    @IBOutlet weak var image_label: UIImageView!
    @IBOutlet weak var time_label: UILabel!
    @IBOutlet weak var type_header_label: UILabel!
    @IBOutlet weak var number_label: UILabel!
    @IBOutlet weak var type_text_sta: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
