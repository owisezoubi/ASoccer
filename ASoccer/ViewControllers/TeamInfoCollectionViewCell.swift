//
//  TeamInfoCollectionViewCell.swift
//  ASoccer
//
//  Created by owise zoubi on 08/07/2019.
//

import UIKit

class TeamInfoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var playerAge: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //set the values for top,left,bottom,right margins
        let margins = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        contentView.frame = contentView.frame.inset(by: margins)
    }
    
}
