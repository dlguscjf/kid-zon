
import Foundation
import MapKit

class BusanData: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var addrRoad: String?
    var phone: String?
    var room: String?
    var member: String?
    var teacher: String?
    var car: String?
    var homepage: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String, addrRoad: String, phone: String, room: String, member: String, teacher: String, car: String, homepage: String) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.addrRoad = addrRoad
        self.phone = phone
        self.room = room
        self.member = member
        self.teacher = teacher
        self.car = car
        self.homepage = homepage
    }
}
