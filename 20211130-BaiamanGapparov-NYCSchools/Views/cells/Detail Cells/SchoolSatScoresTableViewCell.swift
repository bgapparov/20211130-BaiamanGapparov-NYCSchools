//
//  SchoolSatScoresTableViewCell.swift
//  20211130-BaiamanGapparov-NYCSchools
//
//  Created by Baiaman Gapparov on 10/31/21.
//

import Foundation
import UIKit

class SchoolSatScoresTableViewCell: UITableViewCell {

    @IBOutlet var schoolNameLabel: UILabel!
    @IBOutlet var satReadingAvgScoreLabel: UILabel!
    @IBOutlet var satMathAvgScoreLabel: UILabel!
    @IBOutlet var satWritingAvgScoreLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


}
