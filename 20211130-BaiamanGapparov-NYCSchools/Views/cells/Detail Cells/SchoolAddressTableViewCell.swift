//
//  SchoolAddressTableViewCell.swift
//  20211130-BaiamanGapparov-NYCSchools
//
//  Created by Baiaman Gapparov on 10/31/21.
//

import Foundation
import UIKit
import MapKit

class SchoolAddressTableViewCell: UITableViewCell {

    @IBOutlet var schoolAddressMapView: MKMapView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func addHSAnnotaionWithCoordinates(_ hsCoordinates: CLLocationCoordinate2D){
        
        let highSchoolAnnotation = MKPointAnnotation()
        highSchoolAnnotation.coordinate = hsCoordinates
        self.schoolAddressMapView.addAnnotation(highSchoolAnnotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
        let region = MKCoordinateRegion(center: highSchoolAnnotation.coordinate, span: span)
        let adjustRegion = self.schoolAddressMapView.regionThatFits(region)
        self.schoolAddressMapView.setRegion(adjustRegion, animated:true)
    }

}
