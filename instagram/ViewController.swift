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
import FirebaseFirestore
import Crashlytics
import FirebaseAnalytics
import Localize_Swift

class ViewController: UIViewController ,GIDSignInDelegate{
    
    let userdefault = UserDefaults.standard
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.signIn()
    }
    func createUserEmail(email: String,password: String){
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (result, error) in
            if error == nil{
                print("user created")
            }else{
                print(error!)
            }
        }
    }
    func signIn(email:String,password:String){
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil{
                print("sign in")
                self.userdefault.set(true, forKey: "key")
                self.userdefault.synchronize()
                self.performSegue(withIdentifier: "sec", sender: self)
            }else if(error?._code == AuthErrorCode.userNotFound.rawValue)
            {
                self.createUserEmail(email: email, password: password)
            }else{
                print(error!)
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }


    @IBAction func signInBtnPressed(_ sender: UIButton) {
        signIn(email: emailTextField.text!, password: passwordTextField.text!)
    }
}

