//
//  Utils.swift
//  20211130-BaiamanGapparov-NYCSchools
//
//  Created by Baiaman Gapparov on 10/31/21.
//

import Foundation
import CoreLocation
import MapKit

class Utils {
    
    /** This function will fetch the address without coodinates
     - Returns: String, address of the school
     */
    static func getCompleteAddressWithoutCoordinate(_ schoolAddress: String?) -> String {
        if let schoolAddress = schoolAddress {
            let address = schoolAddress.components(separatedBy: "(")
            return address[0]
        }
        return ""
    }
    
    /** This function will fetch the coodinates for the selected School location
      - Returns: CLLocationCoordinate2D, coodinate of School location
    */
    static func getCoordinateForSelectedSchool(_ schoolAddress: String?) -> CLLocationCoordinate2D? {
        if let schoolAddress = schoolAddress {
            let coordinateString = schoolAddress.slice(from: "(", to: ")")
            let coordinates = coordinateString?.components(separatedBy: ",")
            if let coordinateArray = coordinates {
                let latitude = (coordinateArray[0] as NSString).doubleValue
                let longitude = (coordinateArray[1] as NSString).doubleValue
                return CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
            }
        }
        return nil
    }
    
    
    /**  This functions is used to fetch JSON payload and assign parameter to the School model
     - Parameter json: Dictionary with Schools Detail
     - Returns: School Model type
     */
    static func getSchoolInfoWithJSON(_ json: [String: Any]) -> School? {
        if !json.isEmpty {
            let school = School()
            if let dbnObject = json["dbn"] as? String{
                school.dbn = dbnObject
            }
            
            if let schoolNameOnject = json["school_name"] as? String {
                school.schoolName = schoolNameOnject
            }
            
            if let overviewParagraphObject = json["overview_paragraph"] as? String {
                school.overviewParagraph = overviewParagraphObject
            }
            if let schoolAddressObject = json["location"] as? String {
                school.schoolAddress = schoolAddressObject
            }
            if let schoolTelObject = json["phone_number"] as? String {
                school.schoolTelephoneNumber = schoolTelObject
            }
            
            if let websiteObject = json["website"] as? String {
                school.schoolWebsite = websiteObject
            }
            
            return school
        }
        return nil
    }
    
    /** Pass the JSON and configure to the model type
     - Parameter schoolsData: Data of Array composed with Dictionary
     - Returns: Array of Model class
     */
    static func fetchschoolWithJsonData(_ schoolsData: Any) -> [School]? {
        guard let schoolsDictionaryArray = schoolsData as? [[String: Any]] else {
            return nil
        }
        var schoolModelArray = [School]()
        for schoolsDictionary in schoolsDictionaryArray {
            if let schoolModels = Utils.getSchoolInfoWithJSON(schoolsDictionary) {
                schoolModelArray.append(schoolModels)
            }
        }
        return schoolModelArray
    }
    
}
