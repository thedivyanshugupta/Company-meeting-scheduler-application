
import UIKit

class Cells: UITableViewCell {

    @IBOutlet weak var startEndTime: UILabel!
    @IBOutlet weak var meetingDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
