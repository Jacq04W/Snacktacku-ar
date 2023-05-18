//
//  SpotDetailView.swift
//  Snacktacku;ar
//
//  Created by Jacquese Whitson  on 4/25/23.
//

import SwiftUI
import MapKit
import FirebaseFirestoreSwift
import PhotosUI

enum ButtonPressed{
    case review, photo
}
struct SpotDetailView: View {
    
    struct Annotation : Identifiable{
        let id = UUID().uuidString
        var name : String
        var address : String
        var coordinate : CLLocationCoordinate2D
    }
    
    
    @State private var annotations: [Annotation] = []
    @EnvironmentObject var spotVM: SpotViewModel
    @EnvironmentObject var locationManager: LocationManager
    // the varibale below does not have the right path change on appear
    @FirestoreQuery(collectionPath:"spots") var reviews: [Review]
    @FirestoreQuery(collectionPath:"spots") var photos: [Photo]
    @Environment(\.dismiss) private var dismiss
    @State var spot: Spot
    @State var newPhoto =  Photo()

   var previewRunning = false
    @State private var showingAsSheet = false
    // this is to keep track of what button is pressed
    @State private var buttonPressed = ButtonPressed.review
    @State private var uiImageSelected = UIImage()

    @State private var showPhotoSheet = false

    @State private var  showReviewViewSHeet = false
    @State private var showPlaceLookupSheet = false
    @State private var showSaveAlert = false
    // this is a type to hold the UI images
    @State private var selectedPhoto : PhotosPickerItem?

    var avgRating: String {
        guard reviews.count != 0 else {
            return "-.-"
        }
        let averageValue = Double(reviews.reduce(0){$0 + $1.rating}) / Double(reviews.count)
        return String(format:"%.1f",averageValue)
    }
    @State private var mapRegion = MKCoordinateRegion()
    let regionSize = 500.0
    var body: some View {
        VStack{
            Group{
                TextField("Name", text: $spot.name)
                    .font (.title)
                TextField("Address", text: $spot.address)
                    .font (.title2)
                }
            // disables the edit feature
            .disabled(spot.id == nil ? false : true )
            .textFieldStyle (.roundedBorder)
                .overlay {
                RoundedRectangle (cornerRadius: 5)
                .stroke(.gray.opacity(0.5), lineWidth: spot.id == nil ? 2 : 0)
            }
    .padding(.horizontal)
            
            Map(coordinateRegion: $mapRegion,showsUserLocation: true, annotationItems:annotations){
                annotation in
                MapMarker(coordinate: annotation.coordinate)
            }.frame(height: 250)
            .onChange(of:spot){ _ in
                annotations = [Annotation(name: spot.name, address: spot.address, coordinate: spot.coordinate)]
                mapRegion.center = spot.coordinate 
            }
            
            // how to display your pictures
            SpotDetailPhotosScrollView(photos: photos, spot: spot)
            
            HStack{
              
                
                Group {
                    Text("Avg. Rating:")
                        .font(.title2)
                        .bold()
                    
                    Text(avgRating)
                        .font(.title)
                        .fontWeight(.black)
                        .foregroundColor(.red)
                    
                    Spacer()
                    
                    // this photos picker auto makes a button we have to provide the label 
                    PhotosPicker(selection: $selectedPhoto, matching: .images, preferredItemEncoding: .automatic){
                        Image(systemName: "photo")
                        Text ("Photo" )
                    }
                    .onChange(of: selectedPhoto){ newValue in
                        Task{
                            do{
                                if let data = try await newValue?.loadTransferable(type: Data.self){
                                    
                                    if let uiImage = UIImage(data: data){
                        // passsing off the uiImage that is loaded into here into a different var so we can use it in other places
                                        uiImageSelected = uiImage
                                        print("📸Succcesffullly selected image")
                                        newPhoto = Photo() // clears out contents if you add more than 1 photo in a row for this spot 
                                        buttonPressed = .photo
                                        
            // use this because if there is no spot we need to save the spot first then continue with the action we just pressed
                                        if spot.id == nil {
                                            showSaveAlert.toggle()
                                        } else {
                                            showPhotoSheet.toggle()
                                        }
                                        
                                        
                                    }
                                    
                                }
                            } catch {
                                print("🤬Error Selecting Image failed \(error.localizedDescription)")
                            }
                        }
                    }
                    
                    Button{
                        buttonPressed = .review
                        if spot.id == nil {
                            showSaveAlert.toggle()
                        } else {
                            showReviewViewSHeet.toggle()
                        }
                        
                    } label : {
                        Image(systemName: "star.fill")
                        Text("Rate")
                    }
                }.font(Font.caption)
                // this controle how many lines the text can be shown on
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                .buttonStyle(.borderedProminent)
                    .bold()
                    .tint(.red)
            }.padding(.horizontal)
            List{
                Section{
                    ForEach(reviews) { review in
                        NavigationLink{
                            ReviewView(spot:spot,review:review)
                        } label :{
                         SpotReviewRowView(review: review)
                        }
                    }
                } 
            }
            .listStyle(.plain)
            
            
            
            Spacer()
            
        }
        // makes data show up soon as view is loaded
        .onAppear{
            // to retrieve images from the corrrect collection
            if !previewRunning  && spot.id != nil {

                $reviews.path = "spots/\(spot.id ?? "")/reviews"
                print("reviews.path = \($reviews.path)")

                // update the photos so  it shows all of the photos of the spot collection we are looking at
                $photos.path = "spots/\(spot.id ?? "")/photos"

                print("photos.path = \($photos.path)")
            } else {// spot id starts off @nil
                showingAsSheet = true
            }
        if spot.id != nil { // if we have a spot center it on the map
            mapRegion = MKCoordinateRegion(center: spot.coordinate, latitudinalMeters: regionSize, longitudinalMeters: regionSize)
        } else {// otherwise  center the map on the devices location
            Task {
                // make map region shows user lo
                mapRegion = MKCoordinateRegion(center: locationManager.location?.coordinate  ?? CLLocationCoordinate2D(), latitudinalMeters: regionSize, longitudinalMeters: regionSize)
            }
        }
            // allows us for us to plot something on the map
            annotations = [Annotation(name: spot.name, address: spot.address, coordinate: spot.coordinate)]
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(spot.id == nil)
        .toolbar {
            if showingAsSheet{
                if spot.id == nil && showingAsSheet{ // New spot, so show Cancel/Save but
                    ToolbarItem(placement: .cancellationAction) {
                        Button ("Cancel") {
                            dismiss()
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button ("Save") {
                             Task{
                                let success = await spotVM.saveSpot(spot:spot)
                                if success {
                                    dismiss()
                                } else {
                                    print("🤬 Error: Saving spot")
                                }
                            }

                        }
                    }
                    ToolbarItemGroup(placement: .bottomBar) {
                        Spacer()
                        Button{
                            showPlaceLookupSheet.toggle()
                        } label :{
                            Image(systemName: "magnifyingglass")
                            Text("LookUp Place")
                        }
                    }
                }
                else if showingAsSheet && spot.id != nil {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done"){
                            dismiss()
                        }
                    }
                }
            }
           
            
        }
        .sheet(isPresented: $showPlaceLookupSheet) {
            PlaceLookupView(spot:$spot)
        }
        .sheet(isPresented: $showReviewViewSHeet) {
            NavigationStack{
                ReviewView(spot: spot, review: Review())
            }
            
        }
        .sheet(isPresented: $showPhotoSheet) {
            NavigationStack{
                PhotoView(photo:$newPhoto,uiImage:uiImageSelected,spot:spot)
            }
            
            
            .alert("Cannot Rate Place Unless It is Saved",isPresented: $showSaveAlert) {
                Button ("Cancel", role: .cancel) {}
                Button ("Save", role: .none){
                    Task{
                        let success = await spotVM.saveSpot(spot: spot)
                        spot = spotVM.spot
                        if success {
                            // if we didnt update the path after saving a spot we wouldnt be able to see the new reviews added
                        $reviews.path = "spots/\(spot.id ?? "")/reviews"
                        $photos.path = "spots/\(spot.id ?? "")/photos"
                            switch buttonPressed {
                            case .review :
                                showReviewViewSHeet.toggle()
                            case .photo :
                                showPhotoSheet.toggle()
                            }
                            
                        } else {
                            print("🤬Dang Error saving spot")
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
            SpotDetailView(spot: Spot(),previewRunning: true )
                .environmentObject(SpotViewModel())
                .environmentObject(LocationManager())

        }}
}
