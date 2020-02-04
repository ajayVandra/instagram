//
//  Post.swift
//  instagram
//
//  Created by Ajay Vandra on 2/4/20.
//  Copyright © 2020 Ajay Vandra. All rights reserved.
//


import UIKit
import Firebase
import GoogleSignIn
import FirebaseFirestore
import Crashlytics
import FirebaseAnalytics
import FirebaseStorage

class Post {
    var caption : String!
    var imageDownloadURL : String?
    private var image : UIImage!
    
    init(image : UIImage,caption : String) {
        self.image = image
        self.caption = caption
    }
    
    func save(){
        
        let db = Firestore.firestore()
        
     
    }
}
