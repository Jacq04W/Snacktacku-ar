//
//  Spot.swift
//  Snacktacku;ar
//
//  Created by Jacquese Whitson  on 4/25/23.
//

import Foundation
import FirebaseFirestoreSwift
import MapKit

// this is the thats going to get added to firebase 
struct Spot: Identifiable,Codable,Equatable {
    @DocumentID var id: String?
    var name = ""
    var address = ""
    var latitude = 0.0
    var longitude = 0.0
    // this refer to here whenever we need a coordinate to refer to  
    var coordinate: CLLocationCoordinate2D{
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    var dictionary:[String:Any]{
        return ["name": name,"address":address,"latitude" : latitude,"longitude":longitude]
    }
}
