//
//  File.swift
//  Snacktacku;ar
//
//  Created by Jacquese Whitson  on 4/25/23.
//

import Foundation
import FirebaseFirestore
class SpotViewModel: ObservableObject {
    @Published var spot = Spot()
    
    
    func saveSpot(spot:Spot) async -> Bool{
        let db = Firestore.firestore()
        if let id = spot.id { // update the data that alrsady here
        do {
            try await db.collection("spots").document(id).setData (spot.dictionary)
        print ("😎 Data updated successfully!")
        return true
        } catch {
        print ("🤬ERROR: Could not update data in'spots'")
            print ("🤬ERROR: Could not update data in'spots")

           return false
        }
        } else {
            // add to firestore
            do{
                try await db.collection("spots").addDocument(data: spot.dictionary)
                print("😎 Data added succesfully ")
                return true
            } catch{
                print("🤬Error: could not add data ")

                return false
                
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
}// class
