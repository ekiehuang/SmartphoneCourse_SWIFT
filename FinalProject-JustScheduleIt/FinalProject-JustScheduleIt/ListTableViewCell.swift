//
//  ListTableViewCell.swift
//  FinalProject-JustScheduleIt
//
//  Created by Huang Ekie on 4/28/21.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblPri: UILabel!
    
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var lblDur: UILabel!
    
    @IBOutlet weak var lblLoc: UILabel!
    
    @IBOutlet weak var lblCon: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
