

import UIKit
import GoogleMaps

class RouteCreater {
    
    class func navigationPath(dictPathInformation:[String:Any]) -> PathInformationModel?
    {
        guard let arrRoutes = dictPathInformation["routes"] as? [[String:Any]],arrRoutes.count > 0,let arrWaypointOrder = arrRoutes[0]["waypoint_order"] as? [Int],let arrLegs = arrRoutes[0]["legs"] as? [[String:Any]]  else{
            return nil
        }
        var pathInformation = PathInformationModel()
        pathInformation.arrWaypointOrder = arrWaypointOrder
        let path = GMSMutablePath()
        
        for leg in arrLegs
        {
            var stepIndex = 0
            let intermediatePath = GMSMutablePath()
            guard let distance = leg["distance"] as? [String:Any],let duration = leg["duration"] as? [String:Any],let endLocation = leg["end_location"] as? [String:Any],let startLocation = leg["start_location"] as? [String:Any],let startAddress = leg["start_address"] as? String,let endAddress = leg["end_address"] as? String, let arrSteps = leg["steps"] as? [[String:Any]] else{
                return nil
            }
            var leg = LegModel()
            leg.distance = distance
            leg.duration = duration
            leg.endLocation = endLocation
            leg.startLocation = startLocation
            leg.startAddress = startAddress
            leg.endAddress = endAddress
            
            for step in arrSteps
            {
                guard let dictStartLocation = step["start_location"] as? [String:Any] else{
                    return nil
                }
                stepIndex = stepIndex + 1
                guard let coordinate = RouteCreater.coordinateFromLocation(dict:dictStartLocation) else{
                    return nil
                }
                path.add(coordinate)
                intermediatePath.add(coordinate)
                guard let dictPolyLine = step["polyline"] as? [String:Any],let polyLinePoints = dictPolyLine["points"] as? String else{
                    return nil
                }
                let polyLinePath = GMSPath(fromEncodedPath: polyLinePoints)
                guard let unwrappedPolyLinePath = polyLinePath else{
                    return nil
                }
                for index in 0..<unwrappedPolyLinePath.count()
                {
                    path.add(unwrappedPolyLinePath.coordinate(at: index))
                    intermediatePath.add(unwrappedPolyLinePath.coordinate(at: index))
                }
                if arrSteps.count == stepIndex
                {
                    guard let dictEndLocation = step["end_location"] as? [String:Any] else{
                        return nil
                    }
                    stepIndex = stepIndex + 1
                    guard let coordinate = RouteCreater.coordinateFromLocation(dict:dictEndLocation) else{
                        return nil
                    }
                    path.add(coordinate)
                    intermediatePath.add(coordinate)
                }
            }
            leg.path = intermediatePath
            pathInformation.arrLegs.append(leg)
        }
        pathInformation.path = path
        return pathInformation
    }
    
    class func fetchRouteInformation(from:CLLocationCoordinate2D,to:CLLocationCoordinate2D,
                                     waypoints:[CLLocationCoordinate2D]?,
                                     successCallBack:@escaping ([String:Any]) -> Void,
                                     failureCallBack:@escaping Typealias.MapCallBack)
    {
        let origin = "\(from.latitude),\(from.longitude)"
        let destination = "\(to.latitude),\(to.longitude)"
        var baseURL = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)"
        
        if let arrWaypoints = waypoints,let waypointString = self.waypointString(locations: arrWaypoints)
        {
            baseURL = baseURL + waypointString
        }
        
        let transitMode = "&mode=driving"
        baseURL = baseURL + transitMode 
        guard let url = URL(string: baseURL) else{
            return
        }
        URLSession.shared.dataTask(with: url) { (data, url, error) in
            guard let unwrappedData = data ,let jsonReceived = try? JSONSerialization.jsonObject(with: unwrappedData, options: JSONSerialization.ReadingOptions.mutableContainers) ,let dictReceived = jsonReceived as? [String:Any] else{
                failureCallBack(MapError.pathFetchFailed)
                return
            }
            
            successCallBack(dictReceived)
        }.resume()
    }
    
    private class func coordinateFromLocation(dict:[String:Any]) -> CLLocationCoordinate2D?
    {
        guard let lat = dict["lat"] as? Double,let long = dict["lng"] as? Double else{
            return nil
        }
        return CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
    
    private class func waypointString(locations:[CLLocationCoordinate2D]) -> String?
    {
        var strTemp = "&waypoints=optimize:true|"
        locations.forEach { (location) in
            strTemp = strTemp + "\(location.latitude),\(location.longitude)|"
        }
        strTemp.remove(at: strTemp.index(before: strTemp.endIndex))
        return strTemp.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
    }
    
}
