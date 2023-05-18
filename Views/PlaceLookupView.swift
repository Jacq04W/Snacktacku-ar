//
//  PLaceLookupView.swift
//  PlaceLookupDemo
//
//  Created by Jacquese Whitson  on 5/5/23.
//

import SwiftUI
import MapKit

struct PlaceLookupView: View {
    @EnvironmentObject var locationManager: LocationManager
    @StateObject var placeVM = PlaceViewModel()
    @State private var searchText = ""
    @Environment(\.dismiss) private var dismiss
    @Binding var spot: Spot
    var body: some View {
        
        NavigationStack{
            // shows us the kist of similar things we seaarched up
            List(placeVM.places){ place in
                VStack(alignment: .leading){
                    Text(place.name)
                        .font(.title2)
                    Text(place.address)
                        .font(.callout)
                }.onTapGesture {
                    // allows you to click on the list and upddate the data
                    spot.name = place.name
                    spot.address = place.address
                    spot.latitude = place.latitude
                    spot.longitude = place.longitude

                    
                    
                    dismiss()
                }
            }
            .listStyle(.plain)
            
            .searchable(text: $searchText)
            //every time you type something in the searchbar its going to run the search func
            .onChange(of: searchText, perform:{
                text in
                if !text.isEmpty{
                    placeVM.search(text: text, region: locationManager.region)
                } else {
                    placeVM.places = []
                }
            })
                      
            .toolbar{
                ToolbarItem(placement: .automatic){
                    Button("Dismiss"){
                        dismiss()
                    }
                }
            }
        }
    }
}

struct PlaceLookupView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceLookupView(spot: .constant(Spot()))
            .environmentObject(LocationManager())
    }
}
