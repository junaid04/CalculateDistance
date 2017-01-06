//
//  ViewController.swift
//  CalculateDistanceDemo
//
//  Created by Higher Visibility on 2/10/16.
//  Copyright © 2016 Higher Visibility. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var txtFrom: UITextField!
    @IBOutlet weak var txtTo: UITextField!
    @IBOutlet weak var txtRouteInstructions: UITextView!
    var startLocation:CLLocation!
    var lastLocation: CLLocation!
    var traveledDistance:Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func calculateDistance(_ sender: AnyObject) {
        
        let from = txtFrom.text!.components(separatedBy: ", ")
        let to = txtTo.text!.components(separatedBy: ", ")
        
        let fromLat = Double(from[0])
        let fromLong = Double(from[1])
        let toLat = Double(to[0])
        let toLong = Double(to[1])
        
        let locationFrom = CLLocation(latitude: fromLat!, longitude: fromLong!)
        let lcoationTo = CLLocation(latitude: toLat!, longitude: toLong!)
        
        print("Aerial Distance - \(locationFrom.distance(from: lcoationTo)) meters")
        
        self.caculateDistance(fromLat!, fromLong: fromLong!, toLat: toLat!, toLong: toLong!)
    }
    
    func caculateDistance(_ fromLat:Double, fromLong:Double, toLat:Double, toLong:Double){
        
        let directionRequest = MKDirectionsRequest()
        
        let sourceCoord = CLLocationCoordinate2D(latitude: fromLat, longitude: fromLong)
        let destinationCoord = CLLocationCoordinate2D(latitude: toLat, longitude: toLong)
        let mkPlacemarkOrigen = MKPlacemark(coordinate: sourceCoord, addressDictionary: nil)
        let mkPlacemarkDestination = MKPlacemark(coordinate: destinationCoord, addressDictionary: nil)
        let source:MKMapItem = MKMapItem(placemark: mkPlacemarkOrigen)
        let destination:MKMapItem = MKMapItem(placemark: mkPlacemarkDestination)
        
        directionRequest.source = source
        directionRequest.destination = destination
        
        //   directionRequest.requestsAlternateRoutes = true
        directionRequest.transportType = MKDirectionsTransportType.automobile;
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate {
            (response, error) -> Void in
            if error != nil { print("Error calculating direction - \(error!.localizedDescription)") }
            else {
                var instructions = ""
                for route in response!.routes{
                    print("Distance = \(route.distance) meters")
                    instructions = "\(instructions)\nTotal Distance \(route.distance) meters \n"
                    for step in route.steps {
                        print(step.instructions)
                        print("\(step.distance) meters")
                        instructions = "\(instructions)\n\(step.instructions) - \(step.distance) meters"
                    }
                    
                }
                
                self.txtRouteInstructions.text = instructions
                
            }
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if startLocation == nil {
            startLocation = locations.first as? CLLocation
        } else {
            let distance = startLocation.distance(from: locations.last as! CLLocation)
            let lastDistance = lastLocation.distance(from: locations.last as! CLLocation)
            traveledDistance += lastDistance
            print( "\(startLocation)")
            print( "\(locations.last!)")
            print("FULL DISTANCE: \(traveledDistance)")
            print("STRAIGHT DISTANCE: \(distance)")
        }
    }
}
