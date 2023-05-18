//
//  PLaceViewModel.swift
//  PlaceLookupDemo
//
//  Created by Jacquese Whitson  on 5/5/23.
//
// ch 8.8 @15min

import Foundation
import MapKit

@MainActor
class PlaceViewModel : ObservableObject {
    @Published var places : [Place] = []
    
    
    // func alllows us to get all the data of the address typed in
    func search(text:String,region: MKCoordinateRegion){
        let searchRequest = MKLocalSearch.Request()
        // this allows for suggested things to pop uo based on what we type ↓
        searchRequest.naturalLanguageQuery = text
        searchRequest.region = region
        let search = MKLocalSearch(request: searchRequest)
        
        search.start{
            response, error in
            guard let response = response else {
                print("🤬Error: \(error?.localizedDescription)")
                return
            }
            self.places = response.mapItems.map(Place.init)
        }
    }
}


