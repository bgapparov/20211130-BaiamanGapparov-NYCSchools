//
//  SchoolViewController.swift
//  20211130-BaiamanGapparov-NYCSchools
//
//  Created by Baiaman Gapparov on 10/31/21.
//

import UIKit
import MapKit

class SchoolViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet var reloadBtn: UIBarButtonItem!
    @IBOutlet var tableView: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    var schoolList: [School]?
    var filteredschoolList = [School]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.global(qos: .userInitiated).async {
            self.fetchSchoolInformation()
        }
    }
    
    // MARK: - Private instance methods
    
    func setupSearchController(){
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Schools"
        searchController.searchBar.tintColor = UIColor.white
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredschoolList = (schoolList?.filter({( schools : School) -> Bool in
            return schools.schoolName!.lowercased().contains(searchText.lowercased())
        }))!
        
        tableView.reloadData()
    }
    
    @IBAction func reloadAction(_ sender: Any) {
        print("Reloading...")
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.fetchSchoolInformation()
        }
        
    }
    
    //MARK: - Fetch API and parse JSON payloads
    private func fetchSchoolInformation(){
        guard let highSchoolsURL = URL(string: Constants.schoolsURL) else {
            return
        }
        
        let request = URLRequest(url:highSchoolsURL)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { [weak self] (highSchoolsData, response, error)  in
            if highSchoolsData != nil{
                do{
                    let highSchoolsObject = try JSONSerialization.jsonObject(with: highSchoolsData!, options: [])
                    self?.schoolList = Utils.fetchschoolWithJsonData(highSchoolsObject)
                    self?.fetchHighSchoolSATSore()
                }catch{
                    print("School JSON error: \(error.localizedDescription)")
                }
            }
        }
        task.resume()
    }
    
    
    /// This function is will call the API to get all of the High School with SAT Score, and add to the exist model array according to the common parameter DBN.
    private func fetchHighSchoolSATSore(){
        guard let highSchoolsSATScoreURL = URL(string: Constants.schoolWithSATScoreURL) else {
            return
        }
        let requestForSATScore = URLRequest(url:highSchoolsSATScoreURL)
        let session = URLSession.shared
        let task = session.dataTask(with: requestForSATScore) {[weak self] (schoolsWithSATScoreData, response, error) in
            if schoolsWithSATScoreData != nil{
                do{
                    let satScoreObject = try JSONSerialization.jsonObject(with: schoolsWithSATScoreData!, options: [])
                    self?.addSatScoreToHighSchool(satScoreObject)
                    DispatchQueue.main.async {[weak self] in
                        self?.tableView.reloadData()
                    }
                }catch{
                    debugPrint("high school with sat score json error: \(error.localizedDescription)")
                }
            }
        }
        task.resume()
    }
    
    /// This function is used to add the sat score to the high school
    ///
    /// - Parameter satScoreObject: Data of Array composed with Dictionary
    private func addSatScoreToHighSchool(_ satScoreObject: Any){
        guard let highSchoolsWithSatScoreArr = satScoreObject as? [[String: Any]] else{
            return
        }
        
        for  highSchoolsWithSatScore in highSchoolsWithSatScoreArr{
            if let matchedDBN = highSchoolsWithSatScore["dbn"] as? String{
                //This will get the High School with the Common DBN
                var matchedHighSchools = self.schoolList?.first(where: { (school) -> Bool in
                    return school.dbn == matchedDBN
                })
                
                guard matchedHighSchools != nil else{
                    continue
                }
                
                if let satReadingScoreObject =  highSchoolsWithSatScore["sat_critical_reading_avg_score"] as? String{
                    matchedHighSchools!.satCriticalReadingAvgScore = satReadingScoreObject
                }
                
                if let satMathScoreObject = highSchoolsWithSatScore["sat_math_avg_score"] as? String{
                    matchedHighSchools!.satMathAvgScore = satMathScoreObject
                }
                
                if let satWritingScoreObject =  highSchoolsWithSatScore["sat_writing_avg_score"] as? String{
                    matchedHighSchools!.satWritinAvgScore = satWritingScoreObject
                }
                
            }
        }
    }
    
    // MARK: Selector Functions
    
    @objc func callNumber(_ sender: UIButton){
    
        
        var heighSchoolList: School
        
        if isFiltering() {
            heighSchoolList = filteredschoolList[sender.tag]
        } else {
            heighSchoolList = self.schoolList![sender.tag]
        }
        
        let schoolPhoneNumber = heighSchoolList.schoolTelephoneNumber
        
        if let url = URL(string: "tel://\(String(describing: schoolPhoneNumber))"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }else{
            let alertView = UIAlertController(title: "Error!", message: "Call works on real devices \(schoolPhoneNumber!)", preferredStyle: .alert)
            
            let okayAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
            
            alertView.addAction(okayAction)
            
            self.present(alertView, animated: true, completion: nil)
        }
    }
    
    @objc func navigateToAddress(_ sender: UIButton){
        
        var heighSchoolList: School
        
        if isFiltering() {
            heighSchoolList = filteredschoolList[sender.tag]
        } else {
            heighSchoolList = self.schoolList![sender.tag]
        }
        
        let schoolAddress = heighSchoolList.schoolAddress
        
        if let highSchoolCoordinate = Utils.getCoordinateForSelectedSchool(schoolAddress){
            let coordinate = CLLocationCoordinate2DMake(highSchoolCoordinate.latitude, highSchoolCoordinate.longitude)
            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
            mapItem.name = "\(heighSchoolList.schoolName!)"
            mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Pass the selected school with sat score to the destinatiion view controller
        if segue.identifier == Constants.SchoolWithSATScoreSegue{
            let schoolWithSATScoreVC = segue.destination as! SchoolDetailTableViewController
            if let schoolWithSATScore = sender as? School {
                schoolWithSATScoreVC.satScore = schoolWithSATScore
            }
        }
    }
}

extension SchoolViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}


// MARK: UITableViewDataSource and UITableViewDelegate Extensions
extension SchoolViewController: UITableViewDataSource, UITableViewDelegate {
    
    //MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !isFiltering() {
            CellAnimator.animate(cell, withDuration: 0.6, animation: CellAnimator.AnimationType(rawValue: 5)!)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return self.filteredschoolList.count
        }
        return self.schoolList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SchoolTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: Constants.schoolCellIdentifier, for: indexPath) as! SchoolTableViewCell
        
        tableView.rowHeight = 195
        
        var heighSchoolList: School
        
        if isFiltering() {
            heighSchoolList = filteredschoolList[indexPath.row]
        } else {
            heighSchoolList = self.schoolList![indexPath.row]
        }
        
        
        if let schoolName = heighSchoolList.schoolName {
            cell.schoolNameLabel.text = schoolName
        }
        
        if let schoolAddr = heighSchoolList.schoolAddress {
            let address = Utils.getCompleteAddressWithoutCoordinate(schoolAddr)
            cell.schoolAddressLabel.text = "Address: \(address)"
            
            cell.navigateToAddressButton.tag = indexPath.row
            cell.navigateToAddressButton.addTarget(self, action: #selector(self.navigateToAddress(_:)), for: .touchUpInside)
        }
        
        if let phoneNum = heighSchoolList.schoolTelephoneNumber{
            cell.schoolPhoneNumButton.setTitle("Phone # \(phoneNum)", for: .normal)
            
            cell.schoolPhoneNumButton.tag = indexPath.row
            cell.schoolPhoneNumButton.addTarget(self, action: #selector(self.callNumber(_:)), for: .touchUpInside)
        }
        return cell
    }
    
    //MARK: - UITable View Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var heighSchoolList: School
        
        if isFiltering() {
            heighSchoolList = filteredschoolList[indexPath.row]
        } else {
            heighSchoolList = self.schoolList![indexPath.row]
        }
        
        let selectedHighSchool = heighSchoolList
        self.performSegue(withIdentifier: Constants.SchoolWithSATScoreSegue, sender: selectedHighSchool)
    }
}


