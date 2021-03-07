//
//  TableViewCell.swift
//  Lesson7_Weather
//
//  Created by Huang Ekie on 3/5/21.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var lblDayWeek: UILabel!
    
    @IBOutlet weak var lblFutureTemp: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
