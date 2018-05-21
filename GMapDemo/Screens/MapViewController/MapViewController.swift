//
//  ViewController.swift
//  GMapDemo
//
//  Created by Kirill Khudiakov on 26.04.2018.
//  Copyright © 2018 Kirill Khudiakov. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var sliderView: UISlider!
    
    @IBAction func onChange(_ sender: UISlider) {
        mapView.animate(toZoom: sender.value)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = .blue

        initMap()
        
        let points = ServicePlaces().getList()
        guard
            let first = points.first,
            let second = points.last
            else {
                return
        }
        
        RouteCreater.fetchRouteInformation(from: first.postion(),
                                           to: second.postion(),
                                           waypoints: nil,
                                           successCallBack: { dict in
                                            let routes = dict["routes"] as! [[String:AnyObject]]
                                                for route in routes
                                                {
                                                    DispatchQueue.main.async {
                                                        let routeOverviewPolyline = route["overview_polyline"] as! [String : String]
                                                        if let points = routeOverviewPolyline["points"] {
                                                            let path = GMSPath(fromEncodedPath: points)
                                                            let polyline = GMSPolyline(path: path)
                                                            polyline.strokeColor = .red
                                                            polyline.strokeWidth = 4
                                                            polyline.map = self.mapView
                                                        }
                                                    }
                                                }
                                            
        },
                                           failureCallBack: {_ in
                                                print("fail callback in route creator")
                                            
        })
        
        
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(showGeoPointsViewController))
        swipeGesture.direction = .right
        view.addGestureRecognizer(swipeGesture)
    }
    
    @objc func showGeoPointsViewController() {
      print("swift to left or from left")
      let model = GeoPointsViewModel(points: ServicePlaces().getList())
      let geoPointsListViewController = GeoPointsListViewController(viewModel: model)
      navigationController?.pushViewController(geoPointsListViewController, animated: true)
    }
    
    func addRoute() {

        
    }
    
    func initMap() {
        let points = ServicePlaces().getList()
        
        guard
            let first = points.first
        else {
            return
        }
        
        let camera = GMSCameraPosition.camera(withLatitude: first.latitude,
                                              longitude: first.longitude,
                                              zoom: 15.0)
        mapView.camera = camera
        mapView.isMyLocationEnabled = true
        
        for point in points {
            let marker = GMSMarker()
            marker.position = point.postion()
            marker.title = point.placeDescription.title
            marker.snippet = point.placeDescription.description
            marker.map = mapView
        }
    }

}

