//
//  MenuTableViewCell.swift
//  chunyang-tea
//
//  Created by 陈西 on 2021-02-04.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    @IBOutlet weak var cellNameLbl: UILabel!
    @IBOutlet weak var cellDescLbl: UILabel!
    @IBOutlet weak var cellPriceLbl: UILabel!
    @IBOutlet weak var cellImage: UIImageView!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
