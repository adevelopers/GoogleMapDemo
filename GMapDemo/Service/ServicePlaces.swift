//
//  ServicePlaces.swift
//  GMapDemo
//
//  Created by Kirill Khudiakov on 26.04.2018.
//  Copyright © 2018 Kirill Khudiakov. All rights reserved.
//

import Foundation
import GoogleMaps


struct PlaceDescription {
    let title: String
    let description: String
}

struct GeoPoint {
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees
    let placeDescription: PlaceDescription
    
    func postion() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
    
    func toString() -> String {
        return "\(latitude),\(longitude)"
    }
    
}

class ServicePlaces {
    
    func getList() -> [GeoPoint]{
        return [
            GeoPoint(latitude: 55.75, longitude: 37.61, placeDescription: PlaceDescription(title: "Первое", description: "Центральное место") ),
            GeoPoint(latitude: 55.763852, longitude: 37.592105,
                     placeDescription: PlaceDescription(title: "Второе", description: "Патриаршие пруды\nХорошее место")
                     )
        ]
    }
    
    func getLink() -> String {
        let points = getList()
        
        if
            let first = points.first,
            let second = points.last
        {
            let link = "http://maps.googleapis.com/maps/api/directions/json?origin=\(first.toString())&destination=\(second.toString())&mode=driving"
            return link
        }
        
        return ""
    }
}
