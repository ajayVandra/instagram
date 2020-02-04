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
import FirebaseStorage


class signInViewController: UIViewController {

    @IBOutlet weak var shareTextfield: UITextField!
    var str:String = ""
    @IBOutlet weak var imageview: UIImageView!
    var imagePicker  : UIImagePickerController!
  
    var takenImage : UIImage!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker = UIImagePickerController()
    
        imagePicker.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            imagePicker.sourceType = .camera
            imagePicker.cameraCaptureMode = .photo
        }else{
            imagePicker.sourceType = .photoLibrary
        }
               self.present(imagePicker,animated: true,completion: nil)
        
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
    
    @IBAction func ImageBtn(_ sender: UIButton) {
        
    }
    
    @IBAction func shareButton(_ sender: AnyObject) {
       let randomID = UUID.init().uuidString
        str = "name/\(randomID).jpg"
              let uploadRef = Storage.storage().reference(withPath: "\(str)")
              guard let imageData = imageview.image?.jpegData(compressionQuality: 0.75) else {return }
              let uploadMetadata = StorageMetadata.init()
              uploadMetadata.contentType = "image/jpeg"
              
              uploadRef.putData(imageData, metadata: uploadMetadata) { (downloadMetadata, error) in
                  if let error = error{
                      print(error.localizedDescription)
                   return
                  }
                self.performSegue(withIdentifier: "imageCell", sender: self)
                  print("i got this back:\(downloadMetadata)")
    }
}
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! postViewController
        vc.image = str
    }
}
extension signInViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        self.takenImage = image
        self.imageview.image = self.takenImage
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}
