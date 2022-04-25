//
//  Cells.swift
//  Company Meeting Scheduler
//
//  Created by Roro on 4/11/22.
//

import UIKit

class Cells: UITableViewCell {

    @IBOutlet weak var startEnd: UILabel!

    @IBOutlet weak var descript: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
