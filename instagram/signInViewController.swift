//
//  signInViewController.swift
//  instagram
//
//  Created by Ajay Vandra on 2/3/20.
//  Copyright © 2020 Ajay Vandra. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FirebaseFirestore
import Crashlytics
import FirebaseAnalytics


class signInViewController: UIViewController {

    @IBOutlet weak var shareTextfield: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        let db = Firestore.firestore()
    
        db.collection("share").document("post").setData(["name":"Ajay"])
        db.collection("share").getDocuments { (snap, error) in
            if error != nil{
                for doucment in snap!.documents{
                    print(doucment.data())
                }
            }
        }
    }
    

    @IBAction func shareButton(_ sender: AnyObject) {
        Analytics.logEvent("event", parameters: nil)
        Crashlytics.sharedInstance().crash()
    }
}
