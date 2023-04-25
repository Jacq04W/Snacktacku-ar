//
//  ListView.swift
//  Snacktacku;ar
//
//  Created by Jacquese Whitson  on 4/24/23.
//

import SwiftUI
import Firebase

struct ListView: View {
    @Environment(\.dismiss) private var dismiss
     @State private var sheetIsPresented = false
    var body: some View {
        List{
            Text("list items will go here")
            
        }
        .listStyle(.plain)
        .navigationBarBackButtonHidden()
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
//
        
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}

