
import UIKit
import GoogleMaps

struct LegModel {
    var path = GMSPath()
    var distance = [String:Any]()
    var duration = [String:Any]()
    var endAddress = String()
    var startAddress = String()
    var startLocation = [String:Any]()
    var endLocation = [String:Any]()
}
