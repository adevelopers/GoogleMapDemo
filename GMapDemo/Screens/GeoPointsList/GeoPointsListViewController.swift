
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
    var lm: CLLocationManager!
    var activityIndicatorAlert: UIAlertController?
    
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
        tableView.delegate = self
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
        activityIndicatorAlert = UIAlertController(title: NSLocalizedString("Loading", comment: ""), message: NSLocalizedString("PleaseWait", comment: "") + "...", preferredStyle: UIAlertControllerStyle.alert)
        activityIndicatorAlert!.addActivityIndicator()
        var topController:UIViewController = UIApplication.shared.keyWindow!.rootViewController!
        while ((topController.presentedViewController) != nil) {
            topController = topController.presentedViewController!
        }
        topController.present(activityIndicatorAlert!, animated:true, completion:nil)
        
        lm.requestLocation()
    }
    
    func saveLocationToRealm(pointRecord: GeoPointRecord) {
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(pointRecord)
        }
    }
    
    func removeRecord(by index: Int) {
        let item = viewModel.list[index]
        let realm = try! Realm()
        try! realm.write {
            realm.delete(item)
        }
        viewModel.list.remove(at: index)
        tableView.reloadData()
    }
    
}


extension GeoPointsListViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first {
            let geoPoint = GeoPoint(point: location.coordinate)
            
            let geoPointRecord = GeoPointRecord()
            geoPointRecord.setup(by: geoPoint)
            saveLocationToRealm(pointRecord: geoPointRecord)
            
            
            viewModel.list.append(geoPointRecord)
            tableView.reloadData()
            
            activityIndicatorAlert!.dismissActivityIndicator()
            activityIndicatorAlert = nil
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
        let point = viewModel.list[indexPath.row].toPoint()
        cell.textLabel?.text = point.toString() + " " + point.placeDescription.title
        return cell
    }
}

extension GeoPointsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Del") {action, index in
            self.removeRecord(by: index.row)
        }
        
        deleteAction.backgroundColor = .red
        return [deleteAction]
    }
}

extension UIAlertController {
    
    private struct ActivityIndicatorData {
        static var activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    }
    
    func addActivityIndicator() {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 40,height: 40)
        ActivityIndicatorData.activityIndicator.color = UIColor.blue
        ActivityIndicatorData.activityIndicator.startAnimating()
        vc.view.addSubview(ActivityIndicatorData.activityIndicator)
        self.setValue(vc, forKey: "contentViewController")
    }
    
    func dismissActivityIndicator() {
        ActivityIndicatorData.activityIndicator.stopAnimating()
        self.dismiss(animated: false)
    }
}
