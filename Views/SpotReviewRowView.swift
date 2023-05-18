//
//  SpotReviewRowView.swift
//  Snacktacku;ar
//
//  Created by Jacquese Whitson  on 5/12/23.
//

import SwiftUI

struct SpotReviewRowView: View {
    @State var review: Review
    var body: some View {
        VStack(alignment:.leading){
            
            Text (review.title)
            .font(.title2)
            
            HStack{
                StarSelectionView(rating: $review.rating,interactive: false,font: .callout)
                Text (review.body)
                .font (.callout)
                .lineLimit (1)
            }
        }
        
    }
}

struct SpotReviewRowView_Previews: PreviewProvider {
    static var previews: some View {
        SpotReviewRowView(review: Review( title: "Good food", body: "I love this place so mucht its exactley what i needed", rating: 4))
    }
}
