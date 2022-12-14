//
//  TableViewCell.swift
//  PayMeApp
//
//  Created by suriya taothongkom on 28/11/2565 BE.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var image_view: UIImageView!
    @IBOutlet weak var time_label: UILabel!
    @IBOutlet weak var text_H_label: UILabel!
    @IBOutlet weak var input_number: UILabel!
    @IBOutlet weak var type_Label: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
        
        // Configure the view for the selected state
    }

}
