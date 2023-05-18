//
//  StarSelectionView.swift
//  Snacktacku;ar
//
//  Created by Jacquese Whitson  on 5/10/23.
//

import SwiftUI

struct StarSelectionView: View {
    @Binding var rating: Int // change this to @Binding after layout is tested
    
    // this is to let us know if we can edit the stars
    @State var interactive = true
    let highestRating = 5
    let unselected = Image(systemName: "star")
    let selected = Image (systemName: "star.fill")
    var font: Font = .largeTitle
    let fillColor: Color = .red
    let emptyColor: Color = .gray
    
    var body: some View {
        HStack{
            // show 5 things
            ForEach(1...highestRating, id:\.self) { number in
                // this is the thing that is showing
                showStar(for: number)
                    .foregroundColor (number <= rating ? fillColor : emptyColor)
                    .onTapGesture {
                        if interactive{
                        rating = number
                    } 
                    }
            }
            .font(font)
        }
    }
    
    
    func showStar(for number: Int) -> Image{
        if number > rating{
             return unselected
        } else {
            return selected
        }
    }
}

struct StarSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        StarSelectionView(rating:.constant(4))
    }
}
