//
//  CompetitionsTableViewCell.swift
//  ASoccer
//
//  Created by owise zoubi on 04/07/2019.
//

import UIKit

import UIKit

class CompetitionsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellCompName: UILabel!
    @IBOutlet weak var cellCompRegion: UILabel!
    
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
