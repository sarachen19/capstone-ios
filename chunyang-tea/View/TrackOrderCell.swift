//
//  TrackOrderCell.swift
//  chunyang-tea
//
//  Created by 陈西 on 2021-04-08.
//

import UIKit

class TrackOrderCell: UITableViewCell {
    @IBOutlet weak var cellNameLbl: UILabel!
    @IBOutlet weak var cellDescLbl: UILabel!
    @IBOutlet weak var cellPriceLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


    }
}
