

import UIKit
import GoogleMaps

struct PathInformationModel {
    var arrLegs = [LegModel]()
    var arrWaypointOrder = [Int]()
    var path = GMSPath()
    
    func totalTime() -> Double {
        var totalTime = 0.0
        for leg in arrLegs
        {
            guard let timeInSeconds = leg.duration["value"] as? Double else{
                return Double(0)
            }
            totalTime = totalTime + timeInSeconds
        }
        return totalTime
    }
    
    func totalDistance() -> Double {
        var totalDistance = 0.0
        for leg in arrLegs
        {
            guard let distanceInMeters = leg.distance["value"] as? Double else{
                return Double(0)
            }
            totalDistance = totalDistance + distanceInMeters
        }
        return totalDistance
    }
    
}
