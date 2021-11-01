//
//  DetailCells.swift
//  20211130-BaiamanGapparov-NYCSchools
//
//  Created by Baiaman Gapparov on 10/31/21.
//

import Foundation
import UIKit

class DetailCells {
    /// This function get the selected High School name's  average sat scores
    ///
    /// - Returns: UITableViewCell
    static func tableViewCellWithSATScore(_ tableView: UITableView, SchoolWithSatScore: School) -> UITableViewCell {
        let schoolWithSATScoresCell = tableView.dequeueReusableCell(withIdentifier: DetailConstants.Cells.schoolWithSATScoreCellIdentifier) as! SchoolSatScoresTableViewCell
        
        schoolWithSATScoresCell.schoolNameLabel.text = SchoolWithSatScore.schoolName
        
        //For some high school, there is no information of the average SAT score, display the static mesaage to the customers
        schoolWithSATScoresCell.satReadingAvgScoreLabel.text = (SchoolWithSatScore.satCriticalReadingAvgScore != nil) ?  (DetailConstants.averageSATReadingScore + SchoolWithSatScore.satCriticalReadingAvgScore!) : DetailConstants.noSATScoreInfomationText
        
        // Sets the Math Average Score
        schoolWithSATScoresCell.satMathAvgScoreLabel.isHidden = (SchoolWithSatScore.satMathAvgScore != nil) ? false : true
        schoolWithSATScoresCell.satMathAvgScoreLabel.text = (SchoolWithSatScore.satMathAvgScore != nil) ? (DetailConstants.averageSATMathScore + SchoolWithSatScore.satMathAvgScore!) : nil
        
        // Sets the Writing Average Score
        schoolWithSATScoresCell.satWritingAvgScoreLabel.isHidden =  (SchoolWithSatScore.satWritinAvgScore != nil) ? false : true
        schoolWithSATScoresCell.satWritingAvgScoreLabel.text = (SchoolWithSatScore.satWritinAvgScore != nil) ? (DetailConstants.averageSATWritingScore + SchoolWithSatScore.satWritinAvgScore!) : nil
        
        return schoolWithSATScoresCell
    }
    
    /// This function get the selected high school's overview
    ///
    /// - Returns: UITableViewCell
    static func tableViewCellWithOverView(_ tableView: UITableView, SchoolWithSatScore: School) -> UITableViewCell {
        let schoolWithOverviewCell = tableView.dequeueReusableCell(withIdentifier: DetailConstants.Cells.schoolOverviewCellIdentifier) as! SchoolOverviewTableViewCell
        
        schoolWithOverviewCell.schoolOverviewLabel.text = SchoolWithSatScore.overviewParagraph
        
        return schoolWithOverviewCell
    }
    
    /// This function get the high school contact information with address, tel and website.
    ///
    /// - Returns: UITableViewCell
    static func tableViewCellWithContactInfo(_ tableView: UITableView, SchoolWithSatScore: School) -> UITableViewCell {
        let schoolWithContactCell = tableView.dequeueReusableCell(withIdentifier: DetailConstants.Cells.schoolWithContactCellIdentifier) as! SchoolContactTableViewCell
        
        schoolWithContactCell.schoolAddressLabel.text = "Address: " + Utils.getCompleteAddressWithoutCoordinate(SchoolWithSatScore.schoolAddress)
        schoolWithContactCell.schoolPhoneLabel.text = (SchoolWithSatScore.schoolTelephoneNumber != nil) ? "Tel:  " + SchoolWithSatScore.schoolTelephoneNumber! : ""
        schoolWithContactCell.schoolWebsiteLabel.text = SchoolWithSatScore.schoolWebsite
        
        return schoolWithContactCell
    }
    
    /// This function get the High School's location with annotaion on the map
    ///
    /// - Returns: UITableViewCell
    static func tableViewCellWithAddress(_ tableView: UITableView, SchoolWithSatScore: School) -> UITableViewCell {
        let schoolWithAddressCell = tableView.dequeueReusableCell(withIdentifier: DetailConstants.Cells.schoolWithAddressCellIdentifier) as! SchoolAddressTableViewCell
        
        if let highSchoolCoordinate = Utils.getCoordinateForSelectedSchool(SchoolWithSatScore.schoolAddress) {
            schoolWithAddressCell.addHSAnnotaionWithCoordinates(highSchoolCoordinate)
        }
        
        return schoolWithAddressCell
    }
}
