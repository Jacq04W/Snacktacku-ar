///
//  SpotDetailView.swift
//  Snacktacku;ar
//
//  Created by Jacquese Whitson  on 4/25/23.
//

import SwiftUI
import MapKit
import FirebaseFirestoreSwift




//Ch. 8.12 Part
//@15min
import Foundation
import FirebaseFirestore

class ReviewViewModel: ObservableObject {
    @Published var review = Review()
    
    
    func saveReview(spot:Spot,review:Review) async -> Bool{
        let db = Firestore.firestore()
        // this is to make suree we have an spot id
        guard let spotID = spot.id else {
            print ("🤬ERROR: Could not get spot id '")
            return false
        }
        
        // this is the path that we are storing the reviews to
        let collectinString = "spots/\(spotID)/reviews"
        if let id = review.id { // update the data that alrsady here
            do {
                try await db.collection(collectinString).document(id).setData (review.dictionary)
                print ("😎 Data updated successfully!")
                return true
            } catch {
                print ("🤬ERROR: Could not update data in'spots reviews")
                return false
            }
        } else {
            // add data to firestore
            do{
              _ = try await db.collection(collectinString).addDocument(data: review.dictionary)
                print("😎 Data added succesfully ")
                return true
            } catch{
                print("🤬Error: could not create new review in 'reviews' \(error.localizedDescription)")
                
                return false
                
            }
        }
    }
    
    
    // if we want to access certain paths in the collections we have to create a var it in the func
    func deleteReview(spot: Spot, review: Review) async -> Bool {
        let db = Firestore.firestore()
        
        guard let spotID = spot.id, let reviewID = review.id else {
            print("🤬Error: Could not find spot ID")
            return false
        }
        do {

let _ = try await db.collection("spots").document(spotID).collection("reviews").document(reviewID).delete()
            print("🗑️ Document Successfully deleted")
            return true


        } catch {
            print("🤬Error: removing document \(error.localizedDescription)")
            return false

            
        }
        
    }
}
    
