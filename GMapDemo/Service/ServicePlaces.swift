//
//  ServicePlaces.swift
//  GMapDemo
//
//  Created by Kirill Khudiakov on 26.04.2018.
//  Copyright © 2018 Kirill Khudiakov. All rights reserved.
//

import Foundation
import GoogleMaps
import RealmSwift


struct PlaceDescription {
    let title: String
    let description: String
}


class ServicePlaces {
    
    func getList() -> [GeoPoint]{
        return [
            GeoPoint(55.75, 37.61, title: "Первое", desc: "Центральное место"),
            GeoPoint(55.763852,  37.592105, title: "Второе", desc: "Патриаршие пруды\nХорошее место"),
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
