//
//  GeoPoint.swift
//  GMapDemo
//
//  Created by Kirill Khudiakov on 22.05.2018.
//  Copyright © 2018 Kirill Khudiakov. All rights reserved.
//

import Foundation
import GoogleMaps
import Realm
import RealmSwift

class GeoPoint {
    var latitude: CLLocationDegrees = CLLocationDegrees(bitPattern: 0)
    var longitude: CLLocationDegrees = CLLocationDegrees(bitPattern: 0)
    var placeDescription: PlaceDescription = PlaceDescription(title: "", description: "")
    
    init(_ lat: CLLocationDegrees, _ long: CLLocationDegrees, title: String, desc: String) {
        latitude = lat
        longitude = long
        placeDescription = PlaceDescription(title: title, description: desc)
    }
    
    convenience init(point: CLLocationCoordinate2D) {
        self.init(point.latitude, point.longitude, title: "" , desc: "")
    }
    
    func postion() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
    
    func toString() -> String {
        return "\(latitude),\(longitude)"
    }
    
}

class GeoPointRecord: Object {
    @objc dynamic var latitude = ""
    @objc dynamic var longitude = ""
    @objc dynamic var title = ""
    @objc dynamic var desc = ""
}

extension GeoPointRecord {
    func setup(by point: GeoPoint) {
        latitude = "\(point.latitude)"
        longitude = "\(point.longitude)"
        title = point.placeDescription.title
        desc = point.placeDescription.description
    }
    
    func toPoint() -> GeoPoint {
        return GeoPoint(
            CLLocationDegrees(Double(latitude) ?? 0),
            CLLocationDegrees(Double(longitude) ?? 0),
            title: title, desc: desc)
    }
}







