//
//  GeoPointsViewModel.swift
//  GMapDemo
//
//  Created by Kirill Khudiakov on 21.05.2018.
//  Copyright © 2018 Kirill Khudiakov. All rights reserved.
//

import Foundation

class GeoPointsViewModel {
    var list: [GeoPointRecord] = []
    
    init(points: [GeoPointRecord]) {
        list = points
    }
}
