//
//  Place.swift
//  PlaceLookupDemo
//
//  Created by Jacquese Whitson  on 5/5/23.
//

import Foundation
import MapKit

 // chapter 8.8
// @12 min

// this is the model for the places Ex: La fit
struct Place : Identifiable{
    let id = UUID().uuidString
    
    // the map item has decoded info about the place we select
    // name,addy, lat,lon stufff like that
    private var mapItem: MKMapItem
    
    init(mapItem: MKMapItem) {
        self.mapItem = mapItem
    }
    
    var name : String {
        self.mapItem.name ?? ""
    }
    
    var address: String{
        let placemark = self.mapItem.placemark
        var cityAndState = ""
        var address = ""
        
        cityAndState = placemark.locality ?? ""
        
        if let state = placemark.administrativeArea {
        cityAndState = cityAndState.isEmpty ? state : "\(cityAndState), \(state)"
        }
        
        address = placemark.subThoroughfare ?? ""
        if let street = placemark.thoroughfare {
            address = address.isEmpty ? street : " \(address) \(street)"
        }
        if address.trimmingCharacters(in: .whitespaces).isEmpty && !cityAndState.isEmpty{
            address = cityAndState
        } else {
            address = cityAndState.isEmpty ? address : "\(address),\(cityAndState)"
        }
        return address
    }
    
    var latitude: CLLocationDegrees {
        self.mapItem.placemark.coordinate.latitude
    }
    
    
    var longitude: CLLocationDegrees {
        self.mapItem.placemark.coordinate.longitude
    }
}
