//
//  Review.swift
//  Snacktacku;ar
//
//  Created by Jacquese Whitson  on 5/9/23.
//

import Foundation
import Firebase
import FirebaseCore
import FirebaseFirestoreSwift
import SwiftUI
import MapKit
import PhotosUI
import WeatherKit

struct Review : Identifiable, Codable{
    @DocumentID var id: String?
    var title = ""
    var body = ""
    var rating = 0
    var reviewer = Auth.auth().currentUser?.email ?? ""
    var postedOn = Date()
    
    var dictionary: [String: Any] {
        return ["title": title, "body": body, "rating": rating,
            "reviewer":
                    reviewer, "postedOn": Timestamp(date: Date ())]
    }
    
}
