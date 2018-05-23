
//
//  GeoPointsListViewController.swift
//  GMapDemo
//
//  Created by Kirill Khudiakov on 21.05.2018.
//  Copyright © 2018 Kirill Khudiakov. All rights reserved.
//

import UIKit
import CoreLocation
import RealmSwift

class GeoPointsListViewController: UIViewController {
    
    var viewModel: GeoPointsViewModel!
    var tableView: UITableView!
    var lm:CLLocationManager!
    
    convenience init(viewModel: GeoPointsViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView = UITableView(frame: view.frame, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "defaultCell")
        tableView.dataSource = self
        view.addSubview(tableView)
        
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addUserLocation))
        navigationItem.rightBarButtonItems = [barButtonItem]
        
        lm = CLLocationManager()
        lm.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        lm.delegate = self
        lm.requestAlwaysAuthorization()
        lm.requestWhenInUseAuthorization()
    }
    
    @objc func addUserLocation() {
        lm.requestLocation()
    }
    
    func saveLocationToRealm(pointRecord: GeoPointRecord) {
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(pointRecord)
        }
        
    }
    
}


extension GeoPointsListViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let geoPoint = GeoPoint(point: location.coordinate)
            
            let geoPointRecord = GeoPointRecord()
            geoPointRecord.setup(by: geoPoint)
            saveLocationToRealm(pointRecord: geoPointRecord)
            
            viewModel.list.append(geoPoint)
            tableView.reloadData()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("\(error.localizedDescription)")
    }
}

extension GeoPointsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
        let point = viewModel.list[indexPath.row]
        cell.textLabel?.text = point.toString() + " " + point.placeDescription.title
        return cell
    }
}
