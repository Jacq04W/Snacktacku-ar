//
//  File.swift
//  PlaceLookupDemo
//
//  Created by Jacquese Whitson  on 5/4/23.
//

import CoreLocation
import Foundation
import MapKit

    // to use and get user location
//Dont forget about Plist add two things 

@MainActor
class LocationManager:NSObject,ObservableObject{
    @Published var location : CLLocation?
    @Published var region = MKCoordinateRegion()

    private let locationManager = CLLocationManager()
   
    override init() {
        super.init()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self


    }
    
    
    
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        guard let location = locations.last else {return}
        self.location = location
        self.region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)
    }
}
