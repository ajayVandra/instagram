//
//  ViewController.swift
//  instagram
//
//  Created by Ajay Vandra on 2/3/20.
//  Copyright © 2020 Ajay Vandra. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class ViewController: UIViewController ,GIDSignInDelegate{
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
      
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.signIn()
    }
//    func signIN(){
//        Auth.auth().signIn(with: credential) { (authResult, error) in
//          if let error = error {
//            // ...
//            return
//          }
//          // User is signed in
//          // ...
//        }
//    }
    func signOut(){
            let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
          
    }

}

