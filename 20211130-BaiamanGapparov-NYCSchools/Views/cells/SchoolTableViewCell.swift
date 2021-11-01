//
//  SchoolTableViewCell.swift
//  20211130-BaiamanGapparov-NYCSchools
//
//  Created by Baiaman Gapparov on 10/31/21.
//

import Foundation
import UIKit

class SchoolTableViewCell: UITableViewCell {

    // MARK: IBOutlet
    @IBOutlet var cardView: UIView!
    @IBOutlet var sideBarView: UIView!
    @IBOutlet var schoolNameLabel: UILabel!
    @IBOutlet var schoolAddressLabel: UILabel!
    @IBOutlet var schoolPhoneNumButton: UIButton!
    @IBOutlet var navigateToAddressButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCardViewShadows()
        
        self.schoolPhoneNumButton.layer.cornerRadius = 15
        self.navigateToAddressButton.layer.cornerRadius = 15
    }
    
    func setupCardViewShadows(){
        let view = cardView
        view?.layer.cornerRadius = 15.0
        view?.layer.shadowColor = UIColor.black.cgColor
        view?.layer.shadowOffset = CGSize(width: 0, height: 2)
        view?.layer.shadowOpacity = 0.8
        view?.layer.shadowRadius = 3
        view?.layer.masksToBounds = false
    }


}
