//
//  SpotDetailView.swift
//  Snacktacku;ar
//
//  Created by Jacquese Whitson  on 4/25/23.
//

import SwiftUI

struct SpotDetailView: View {
    @EnvironmentObject var spotVm: SpotViewModel
    @Environment(\.dismiss) private var dismiss
    @State var spot: Spot
    var body: some View {
        VStack{
            Group{
                
                
                TextField("Name", text: $spot.name)
                    .font (.title)
                TextField( "Address", text: $spot.address)
                    .font (.title2)
                }
            .textFieldStyle (.roundedBorder)
                .overlay {
                RoundedRectangle (cornerRadius: 5)
                        .stroke(.gray.opacity(0.5), lineWidth: 2)
            }
                .padding(.horizontal)
            Spacer()
            
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(spot.id == nil)
        .toolbar {
            if spot.id == nil { // New spot, so show Cancel/Save but
                ToolbarItem(placement: .cancellationAction) {
                    Button ("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button ("Save") {
                        //TODO: add Save code here dismiss ()
                        Task{
                            let success = await spotVm.saveSpot(spot:spot)
                            
                            if success {
                                dismiss()

                            } else {
                                print("🤬 Error: Saving spot")
                            }
                        }

                    }
                }
            }
            
        }
            
            
    }
}

struct SpotDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            SpotDetailView(spot: Spot())
                .environmentObject(SpotViewModel())
        }}
}
