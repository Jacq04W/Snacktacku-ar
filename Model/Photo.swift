//
//  Photo.swift
//  Snacktacku;ar
//
//  Created by Jacquese Whitson  on 5/13/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift


struct Photo : Identifiable,Codable{
    @DocumentID var id: String?
    var imageUrlString = ""
    var description = ""
    var reviewer = Auth.auth().currentUser?.email ?? ""
    var postedOn = Date()
    var dictionary : [String: Any]{
        return[ "imageUrlString" : imageUrlString,"description" :  description,
                "reviewer" : reviewer, "Posted" : Timestamp(date: Date())]
    }


    
}

