
import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, XMLParserDelegate,CLLocationManagerDelegate {

    var locationManager = CLLocationManager()
    @IBOutlet weak var vzoom: UIStepper!
   
    
    @IBOutlet weak var myMapView: MKMapView!
    
    var annotation: BusanData?
    var annotations: Array = [BusanData]()
    
    var item:[String:String] = [:]  // item[key] => value
    var items:[[String:String]] = []
    var currentElement = ""
    var selected: BusanData?
    var tPM10: String?
    var address: String?
    var lat: String?
    var long: String?
    var loc: String?
    var dLat: Double?
    var dLong: Double?
   
    
    let addrs:[String:[String]] = [
        "방울어린이집" : ["35.094243", "128.992474"],
        "별초롱어린이집" : ["35.058019", "128.963672"],
        "보금자리어린이집" : ["35.077993", "128.963808"],
        "보리어린이집" : ["35.110414", "128.984306"],
        "봉우리어린이집" : ["35.092935", "128.970777"],
        "부산YWCA부설어린이집" : ["35.075728", "128.981124"],
        "부산아라빅스맘어린이집" : ["35.054025", "128.961856"],
        "붕붕이어린이집" : ["35.065506", "128.981948"],
        "블루아이어린이집" : ["35.064760", "128.982516"],
        "빛나라어린이집" : ["35.080072", "128.969168"],
        "뽀뽀뽀어린이집" : ["35.062069", "128.978198"],
        "사과나무어린이집" : ["35.095433", "128.988987"],
        "사랑나무어린이집" : ["35.062219", "128.978921"],
        "사랑뜰어린이집" : ["35.112897", "128.959269"],
        "사랑샘어린이집" : ["35.098430", "128.959854"],
        "사랑이샘솟는어린이집" : ["35.071921", "128.970575"],
        "사하아이자람어린이집" : ["35.107046", "128.977709"],
        "사하어린이집" : ["35.094390", "129.007708"],
        "산새소리어린이집" : ["35.099705", "128.957530"],
        "상아어린이집" : ["35.092383", "128.974752"]
        
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vzoom.wraps = true
        vzoom.autorepeat = true
        vzoom.maximumValue = 11
        
       
        // 사용자 현재 위치 트랙킹
        locationManager.delegate = self
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestAlwaysAuthorization()
        }
        
        locationManager.startUpdatingLocation()
        
        // 사용자 현재 위치, 캠파스 표시
        myMapView.showsUserLocation = true
        myMapView.showsCompass = true
        
        self.title = "Kid Zone"
        // Do any additional setup after loading the view, typically from a nib.
        // XML Parsing
        let key = "E%2FeSbG29KCzlKt24hzLXa%2FztaQQR9XfK0364bMCEN569c0u2qJV4wUYDsaf4cz6XTYesGAj%2BBm5fW1CFwoD3pA%3D%3D"
        let strURL = "http://apis.data.go.kr/6260000/BusanKindergartenInfoService/getKindergartenDetailsInfo?&numOfRows=20&ServiceKey=\(key)"
        
        if let url = URL(string: strURL) {
            if let parser = XMLParser(contentsOf: url) {
                parser.delegate = self
                
                if (parser.parse()) {
                    print("parsing success")
                    
                    for item in items {
                        print("item name = \(item["name"]!)")
                    }
                    
                } else {
                    print("parsing fail")
                }
            } else {
                print("url error")
            }
        }
        
        // Map
        myMapView.delegate = self
        
        //  초기 맵 region 설정
        zoomToRegion()
        
        for item in items {
            let dSite = item["name"]
            
            // 추가 데이터 처리
            for (key, value) in addrs {
                if key == dSite {
                    lat = value[0]
                    long = value[1]
                    dLat = Double(lat!)
                    dLong = Double(long!)
                  
                }
            }

            // 파싱 데이터 처리
        
            let dgubun = item["gubun"]
            let daddrRoad = item["addrRoad"]
            let dphone = item["phone"]
            let droom = item["room"]
            let dmember = item["member"]
            let dteacher = item["teacher"]
            let dcar = item["car"]
            let dhomepage = item["homepage"]
            
//            print(dSite!)
//            print(dgubun!)
//            print(daddrRoad!)
//            print(dphone!)
//            print(droom!)
//            print(dmember!)
//            print(dteacher!)
            


            
            annotation = BusanData(coordinate: CLLocationCoordinate2D(latitude: dLat!, longitude: dLong!), title: dSite!, subtitle: dgubun!, addrRoad: daddrRoad!, phone: dphone!, room: droom!, member: dmember!, teacher: dteacher!,car : dcar!, homepage: dhomepage!)
           
            annotations.append(annotation!)
            
           
            
        }
        // 지도의 중심점, 반경 등(zoomToRegion)이 반드시 필요함
        myMapView.addAnnotations(annotations)
        
        // 지도의 중심점, 반경 등(zoomToRegion)이 없이도 모든 pin을 포함하여 지도가 보여질 수 있도록 함
        //myMapView.showAnnotations(annotations, animated: true)
        
 
    }
    
    func zoomToRegion() {
        let location = CLLocationCoordinate2D(latitude: 35.180100, longitude: 129.081017)
        let span = MKCoordinateSpan(latitudeDelta: 0.27, longitudeDelta: 0.27)
        let region = MKCoordinateRegion(center: location, span: span)
        myMapView.setRegion(region, animated: true)
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "MyPin"

//        if annotation.isKind(of: MKUserLocation.self) {
//            return nil
//        }

        if annotation.isKind(of: BusanData.self) {
            var annotationView = myMapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView

            if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
                annotationView?.animatesDrop = true
                
                let castBusanData = annotation as! BusanData
                let ntitle = castBusanData.title
                
                
                let label = UILabel(frame: CGRect(x: -50, y: 12, width: 300, height: 30))
                label.textColor = UIColor.orange
                //            label.text = annotation.id // set text here
                
                //let castBusanData = annotation as! BusanData
                
                label.text = ntitle
                annotationView?.addSubview(label)
               
            } else {
                annotationView?.annotation = annotation
            }

            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn

            return annotationView
        }
        return nil

    }
    
    // rightCalloutAccessoryView를 눌렀을때 호출되는 delegate method
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        selected = view.annotation as? BusanData
        
        if control == view.rightCalloutAccessoryView {
            self.performSegue(withIdentifier: "showDetail", sender: self)
        }
//        let viewAnno = view.annotation as! BusanData // 데이터 클래스로 형변환(Down Cast)
//        let vname = viewAnno.title
//        let vgubun = viewAnno.subtitle
//        let vaddr = viewAnno.addrRoad
//        let vphoen = viewAnno.phone
//        let vroom = viewAnno.room
//        let vmember = viewAnno.member
//        let vteacher = viewAnno.teacher
//
//
//
//        let ac = UIAlertController(title: vname!, message: "구분 : \(vgubun!) \n 주소 : \(vaddr!) \n 전화번호 : \(vphoen!) \n 유치원생 수 : \(vmember!) \n 교사 수 : \(vteacher!) \n 방 갯수 : \(vroom!)" , preferredStyle: .alert)
//        ac.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
//        self.present(ac, animated: true, completion: nil)

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let detailVC = segue.destination as! TableViewController1
            
            detailVC.selectedForDetail = self.selected
        }
        
    }
    
    func changeStepperLocation(sLat: Double, sLong: Double) {
        
        let currnetLoc: CLLocation = locationManager.location!
        let location = CLLocationCoordinate2D(latitude: currnetLoc.coordinate.latitude, longitude: currnetLoc.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: sLat, longitudeDelta: sLong)
        let region = MKCoordinateRegion(center: location, span: span)
        myMapView.setRegion(region, animated: true)
        
    }
    @IBAction func zoombt(_ sender: UIStepper) {
        let stepVal = vzoom.value
        switch stepVal {
        case 1:
            print("Tesp 1")
            changeStepperLocation(sLat: 0.28, sLong: 0.28)
        case 2:
            print("Tesp 2")
            changeStepperLocation(sLat: 0.20, sLong: 0.20)
        case 3:
            print("Tesp 3")
            changeStepperLocation(sLat: 0.12, sLong: 0.12)
        case 4:
            print("Tesp 4")
            changeStepperLocation(sLat: 0.04, sLong: 0.04)
        default:
            break
        }
    }
    
    // XML Parsing Delegate 메소드
    // XMLParseDelegate
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        currentElement = elementName
        
        // tag 이름이 elements이거나 item이면 초기화
        if elementName == "items" {
            items = []
        } else if elementName == "item" {
            item = [:]
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        //        print("data = \(data)")
        if !data.isEmpty {
            item[currentElement] = data
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            items.append(item)
        }
    }
}

