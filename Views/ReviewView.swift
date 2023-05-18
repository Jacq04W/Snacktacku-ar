//
//  ReviewView.swift
//  Snacktacku;ar
//
//  Created by Jacquese Whitson  on 5/9/23.
//
// for showing date and times ch8.15, min 18
import SwiftUI
import Firebase
struct ReviewView: View {
    @StateObject var reviewVM = ReviewViewModel()
    @State private var postedByThisUser = false
    @State private var rateOrReviewString = "Click to rate:"

    @State var spot: Spot
    @State var review: Review
    @Environment (\.dismiss) private var dismiss
    var body: some View {
        VStack{
            VStack(alignment:.leading){
                Text (spot.name)
                    .font(.title)
                    .bold()
                    .multilineTextAlignment(.leading)
                    .lineLimit(1)
                Text (spot.address)
                    .padding(.bottom)
                
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .leading)
            Text(rateOrReviewString)
            .font (postedByThisUser ? .title2 : .subheadline)
                .bold (postedByThisUser)
                .minimumScaleFactor (0.5)
                .lineLimit(1)
                .padding(.horizontal)
            HStack{
                StarSelectionView(rating: $review.rating)
                // if not posted by this usefr disable
                    .disabled(!postedByThisUser)
            .overlay{
                RoundedRectangle (cornerRadius: 5)
                    .stroke(.gray.opacity (0.5), lineWidth: postedByThisUser ? 2 : 0 )

                    }
            }
            .disabled(!postedByThisUser)
            .padding(.bottom)
            VStack(alignment: .leading){
                Text( "Review Title:")
                .bold()
                
                TextField("Title", text: $review.title)
                    .padding(.horizontal,6)
                .overlay{
                    RoundedRectangle (cornerRadius: 5)
                        .stroke(.gray.opacity (0.5), lineWidth: postedByThisUser ? 2 : 0.3)
                }
                
                
                Text ("Review")
                .bold()
               // axid allows for the field to be scrollable incase of too mucha content
                TextField("Review", text: $review.body, axis: .vertical)
                    .padding(.horizontal,6)
                    .frame(maxHeight: .infinity,alignment:.topLeading)
                .overlay{
                    RoundedRectangle (cornerRadius: 5)
                        .stroke(.gray.opacity (0.5), lineWidth: postedByThisUser ? 2 : 0.3)
                }
            }
            .padding(.horizontal)
            Spacer()
        }
        .onAppear{
            if review.reviewer == Auth.auth().currentUser?.email{
                postedByThisUser = true
            }else {
                
                let reviewPostedOn = review.postedOn.formatted(date:.numeric,time:.omitted)
                rateOrReviewString = "By:\(review.reviewer) on:\(reviewPostedOn)"
            }
        }
        .navigationBarBackButtonHidden(postedByThisUser)// hide the back button if posted by this user
        .toolbar {
            if postedByThisUser {
                ToolbarItem(placement: .cancellationAction) {
                    Button ("Cancel") {
                        dismiss ()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button ("Save") {
                        Task{
                            let success = await reviewVM.saveReview(spot:spot,review:review)
                            if success {
                                dismiss()
                            } else {
                        print("🤬Error: savign data  in review view")
                            }
                        }
                    }
                    
                    
                }
                
                if review.id != nil {
                ToolbarItemGroup(placement: .bottomBar) {
                    Spacer()
                    Button{
                        Task{
                            let success = await reviewVM.deleteReview(spot: spot, review: review)
                            if success {
                                dismiss()
                            }
                        }
                        
                    } label : {
                        Image(systemName: "trash")
                    }
                }
            
                    
                }
                
            }
       
            
        }
    }
}


struct ReviewView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            ReviewView(spot: Spot(name:"Shake Shack",address: "660 Woodward "), review: Review())
                 
        }
    }
}
