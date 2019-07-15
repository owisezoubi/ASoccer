//
//  TeamInfoTransferInTableViewCell.swift
//  ASoccer
//
//  Created by owise zoubi on 11/07/2019.
//

import UIKit

class TeamInfoTransferInTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var fromClub: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var type: UILabel!    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //set the values for top,left,bottom,right margins
        let margins = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        contentView.frame = contentView.frame.inset(by: margins)
    }
}
