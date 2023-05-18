//
//  SpotDetailPhotosScrollView.swift
//  Snacktacku;ar
//
//  Created by Jacquese Whitson  on 5/14/23.
//

import SwiftUI

struct SpotDetailPhotosScrollView: View {
//    struct FakePhoto: Identifiable{
//        let id = UUID().uuidString
//        let imageURLString = "https://firebasestorage.googleapis.com:443/v0/b/snacktackula.appspot.com/o/67Ti3g27u5MZqkhPZF9X%2F250CF247-1326-4731-80E6-DE7BB892FBA4.jpeg?alt=media&token=3263dac5-6ec9-4aa2-af87-d4033de7fa77"
//
//    }
//    let photos = [ FakePhoto(),FakePhoto(),FakePhoto(),FakePhoto(),FakePhoto(),FakePhoto(),FakePhoto()]
//
    var photos: [Photo]
    var spot :Spot
    
    @State private var selectedPhoto = Photo()

    @State private var showPhotoViewerView = false
    @State private var uiImage = UIImage()

    var body: some View {
        ScrollView(.horizontal,showsIndicators: true){
            HStack(spacing: 4){
       
    ForEach(photos){photo in
        
let imageURL = URL(string: photo.imageUrlString ) ?? URL(string: "")
        
        // how to load up the images and can edit them
        AsyncImage(url:imageURL){
            image in
            
            image
                .resizable()
                .scaledToFill ()
                .frame(width: 80, height: 80)
                .clipped()
                .onTapGesture {
        // this allows for the image to pop up on another page
                let renderer = ImageRenderer(content: image)
                    selectedPhoto = photo
                    uiImage = renderer.uiImage ?? UIImage()
                    showPhotoViewerView.toggle()
                }
            
        } placeholder: {
            ProgressView()
                .frame(width: 80, height: 80)

        }
              
    }
           
    }
            
        }
        .frame(height:80)
        .padding(.horizontal,4)
        .sheet(isPresented: $showPhotoViewerView){  
            PhotoView(photo: $selectedPhoto,spot: spot, uiImage: uiImage )
            
        }
        
    }
}

struct SpotDetailPhotosScrollView_Previews: PreviewProvider {
    static var previews: some View {
        SpotDetailPhotosScrollView(photos: [Photo(imageUrlString: "https://firebasestorage.googleapis.com:443/v0/b/snacktackula.appspot.com/o/67Ti3g27u5MZqkhPZF9X%2F250CF247-1326-4731-80E6-DE7BB892FBA4.jpeg?alt=media&token=3263dac5-6ec9-4aa2-af87-d4033de7fa77")], spot: Spot(id: "67Ti3g27u5MZqkhPZF9X") )
    }
}
