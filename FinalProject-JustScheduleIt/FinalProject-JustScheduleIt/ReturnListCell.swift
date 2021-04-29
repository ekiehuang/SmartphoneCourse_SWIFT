//
//  ReturnListCell.swift
//  FinalProject-JustScheduleIt
//
//  Created by Huang Ekie on 4/28/21.
//

import UIKit

class ReturnListCell: UITableViewCell {
    @IBOutlet weak var priority: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var condition: UILabel!
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
