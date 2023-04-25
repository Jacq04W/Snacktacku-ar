//
//  Spot.swift
//  Snacktacku;ar
//
//  Created by Jacquese Whitson  on 4/25/23.
//

import Foundation
import FirebaseFirestoreSwift
import MapKit

struct Spot: Identifiable,Codable  {
    @DocumentID var id: String?
    var name = ""
    var address = ""
//    var coordinate: CLLocationCoordinate2D
//    var averageRating: Double
//    var number0fReviews: Int
//    var postingUserID: String
    var dictionary:[String:Any]{
        return ["name": name,"address":address]
    }
}
