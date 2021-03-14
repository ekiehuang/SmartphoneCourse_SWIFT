//
//  TableViewCell.swift
//  Lesson7_Weather
//
//  Created by Huang Ekie on 3/5/21.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var lblDayWeek: UILabel!
    
    @IBOutlet weak var lblCellHigh: UILabel!
    
    @IBOutlet weak var imageCellHigh: UIImageView!
    
    @IBOutlet weak var lblCellLow: UILabel!
    
    @IBOutlet weak var imageCellLow: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
