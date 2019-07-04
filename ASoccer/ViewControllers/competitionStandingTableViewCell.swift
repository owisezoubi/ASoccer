//
//  competitionStandingTableViewCell.swift
//  ASoccer
//
//  Created by owise zoubi on 04/07/2019.
//

import UIKit

class competitionStandingTableViewCell: UITableViewCell{
    
    
    @IBOutlet weak var teamPosition: UILabel!
    @IBOutlet weak var teamName: UILabel!
    
    @IBOutlet weak var teamGroup: UILabel!
    @IBOutlet weak var teamMP: UILabel!
    @IBOutlet weak var teamW: UILabel!
    @IBOutlet weak var teamD: UILabel!
    @IBOutlet weak var teamL: UILabel!
    @IBOutlet weak var teamGS: UILabel!
    @IBOutlet weak var teamGA: UILabel!
    @IBOutlet weak var teamGD: UILabel!
    @IBOutlet weak var teamPts: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
