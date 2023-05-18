//
//  ListView.swift
//  Snacktacku;ar
//
//  Created by Jacquese Whitson  on 4/24/23.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift


struct ListView: View {
    // how to put the collection of data from firebase into a variable
    @FirestoreQuery(collectionPath: "spots") var spots: [Spot]
    @Environment(\.dismiss) private var dismiss
     @State private var sheetIsPresented = false
    var body: some View {
        NavigationStack {
            List(spots){spot in
                NavigationLink{
                    SpotDetailView(spot: spot)
                }
            label:{
                Text(spot.name)
                    .font(.title2)
            }
            }
            .listStyle(.plain)
            .navigationTitle("Snack Spots")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    Button("Sign Out"){
                        do {
                            try Auth.auth().signOut()
                            print("🪵⏩ log out successful ")
                            dismiss()
                        } catch{
                            print("🤬 Error: Could sign out")
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarLeading){
                    Button{
                        sheetIsPresented.toggle()
                    }
                    label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $sheetIsPresented) {
                NavigationStack{
                   SpotDetailView(spot: Spot())
                }
        }
        }
//
        
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}

