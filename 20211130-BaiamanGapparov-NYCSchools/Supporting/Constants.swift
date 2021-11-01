//
//  Constants.swift
//  20211130-BaiamanGapparov-NYCSchools
//
//  Created by Baiaman Gapparov on 10/31/21.
//

import Foundation

struct Constants {
    static let schoolsURL = "https://data.cityofnewyork.us/resource/97mf-9njv.json"
    static let schoolWithSATScoreURL = "https://data.cityofnewyork.us/resource/734v-jeq5.json"
    static let schoolCellIdentifier = "schoolCell"
    static let SchoolWithSATScoreSegue = "SchoolWithSATScoreSegue"
}

struct DetailConstants {
    struct Cells {
        static let schoolWithSATScoreCellIdentifier =  "SchoolSATScoresTableViewCell"
        static let schoolOverviewCellIdentifier = "SchoolOverViewTableViewCell"
        static let schoolWithAddressCellIdentifier = "SchoolAddressTableViewCell"
        static let schoolWithContactCellIdentifier = "SchoolContactTableViewCell"
    }

    
    static let noSATScoreInfomationText = "There is no SAT score information for this high school"
    static let averageSATReadingScore = "SAT Average Critical Reading Score:  "
    static let averageSATMathScore = "SAT Average Math Score:   "
    static let averageSATWritingScore = "SAT Average Writing Score:   "
}
