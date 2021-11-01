//
//  SchoolDetailTableViewController.swift
//  20211130-BaiamanGapparov-NYCSchools
//
//  Created by Baiaman Gapparov on 10/31/21.
//

import Foundation
import CoreLocation
import MapKit

class SchoolDetailTableViewController: UITableViewController {
    
    var satScore: School!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = satScore.schoolName
        self.tableView.rowHeight = UITableView.automaticDimension
    }
}

// MARK: - Table view data source
extension SchoolDetailTableViewController {
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        CellAnimator.animate(cell, withDuration: 0.6, animation: CellAnimator.AnimationType(rawValue: 5)!)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return DetailCells.tableViewCellWithSATScore(self.tableView, SchoolWithSatScore: self.satScore)
        case 1:
            return DetailCells.tableViewCellWithOverView(self.tableView, SchoolWithSatScore: self.satScore)
        case 2:
            return DetailCells.tableViewCellWithContactInfo(self.tableView, SchoolWithSatScore: self.satScore)
        default:
            return DetailCells.tableViewCellWithAddress(self.tableView, SchoolWithSatScore: self.satScore)
        }
    }
    
    //MARK: - UITable View Delegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0,1,2:
            return UITableView.automaticDimension
        default:
            return UIScreen.main.bounds.width * 0.7
        }
    }
    
}
