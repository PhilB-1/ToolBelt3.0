//
//  Map.swift
//  ToolBelt
//
//  Created by Peter Kang on 5/14/16.
//  Copyright © 2016 teamToolBelt. All rights reserved.
import Alamofire
import MapKit
class ToolMapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    
    
    

    
    let locationManager = CLLocationManager()
    var currentLat: CLLocationDegrees = 0.0
    var currentLong: CLLocationDegrees = 0.0
    
    
    
    
    @IBOutlet var searchBar: UISearchBar!
    
    @IBOutlet var map: MKMapView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map.delegate = self
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.startUpdatingLocation()
        }
        
    }
    
    func mapView(mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == annotationView.rightCalloutAccessoryView {
            if control == annotationView.rightCalloutAccessoryView {
                performSegueWithIdentifier("maptochat", sender: self)
            }
        }
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseIdentifier = "pin"
        var pin = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseIdentifier) as? MKPinAnnotationView
        if pin == nil {
            pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            pin!.pinColor = .Red
            pin!.canShowCallout = true
            pin!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        } else {
            pin!.annotation = annotation
        }
        return pin
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        let location = locations.last! as CLLocation
        currentLat = location.coordinate.latitude
        currentLong = location.coordinate.longitude
    }
    
    
    
    func searchBarSearchButtonClicked( searchbar: UISearchBar) {
        searchbar.resignFirstResponder()
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let userid: Int = defaults.objectForKey("toolBeltUserID") as! Int
        
        let searchTerm = String(searchBar.text!)
        
        print(searchTerm)
        
        Alamofire.request(.GET, "http://afternoon-bayou-17340.herokuapp.com/tools/search", parameters: ["keyword": searchTerm, "latitude": currentLat, "longitude": currentLong]) .responseJSON {response in
            if let JSON = response.result.value {
                print("\(JSON)")
                
                for var i = 0; i < JSON.count; i++ {
                    
                    let owner = JSON[i].objectForKey("owner")
                    let tool = JSON[i].objectForKey("tool")
                    let toolName = tool!["title"]!
                    let toolDescription = tool!["description"]!
                    var lat = owner!["latitude"]?!.doubleValue
                    lat = lat! + Double(arc4random_uniform(5))/10000
                    var long = owner!["longitude"]?!.doubleValue
                    long = long! + Double(arc4random_uniform(5))/10000
                    var latitude: CLLocationDegrees = lat!
                    var longitude: CLLocationDegrees = long!
                    
                    var latDelta: CLLocationDegrees = 0.05
                    var lonDelta: CLLocationDegrees = 0.05
                    var span: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
                    
                    var location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
                    var region: MKCoordinateRegion = MKCoordinateRegionMake(location, span)
                    self.map.setRegion(region, animated: true)
                    
                    func annotate() {
                        
                        let annotation = MKPointAnnotation()
                        
                        annotation.coordinate = location
                        
                        annotation.title = "\(toolName!)"
                        
                        annotation.subtitle = "\(toolDescription!)"
                        
                        
                        self.map.addAnnotation(annotation)
                        
                    }
                    annotate()
                }
                
                
            } else {
                print("Sent search term, but no response")
            }
        }
        
    }
    
}