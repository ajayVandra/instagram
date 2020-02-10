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
import MessageUI
import Localize_Swift

class signInViewController: UIViewController,CAAnimationDelegate,UITableViewDelegate, UITableViewDataSource{
    
    
    var arrdata = ["Post","home","share","signout"]
//    var arrImg = [#imageLiteral(resourceName: "appstore"),#imageLiteral(resourceName: "appstore"), #imageLiteral(resourceName: "appstore")]
    @IBOutlet weak var shareTextfield: UITextField!
    var str:String = ""
    @IBOutlet weak var imageview: UIImageView!
    
    @IBOutlet weak var sideview: UIView!
    var isSideViewOpen : Bool = false
    @IBOutlet weak var sidebar: UITableView!
    
    var imagePicker  : UIImagePickerController!
  
    var takenImage : UIImage!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sideview.isHidden = true
        sidebar.backgroundColor = UIColor.groupTableViewBackground
        isSideViewOpen = false

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
    
    
    @IBAction func menuBtn(_ sender: UIBarButtonItem) {
        
        sidebar.isHidden = false
        sideview.isHidden = false
        self.view.addSubview(sideview)
        sideview.isUserInteractionEnabled = true
        //self.view.insertSubview(sideview, at: 1)
        //self.view.bringSubviewToFront(sideview)
        if !isSideViewOpen{
            isSideViewOpen = true
            sideview.frame = CGRect(x: 0, y: 88, width: 0, height: 808)
            sidebar.frame = CGRect(x: 0, y: 0, width: 0, height: 808)
            UIView.setAnimationDuration(0.3)
            UIView.setAnimationDelegate(self)
            UIView.beginAnimations("tableAnimation", context: nil)
            sideview.frame = CGRect(x: 0, y: 88, width: 259, height: 808)
            sidebar.frame = CGRect(x: 0, y: 0, width: 259, height: 808)
            UIView.commitAnimations()
        }else{
            sidebar.isHidden = true
            sideview.isHidden = true
            isSideViewOpen = false
            sideview.frame = CGRect(x: 0, y: 88, width: 259, height: 808)
            sidebar.frame = CGRect(x: 0, y: 0, width: 259, height: 808)
            UIView.setAnimationDuration(0.3)
            UIView.setAnimationDelegate(self)
            UIView.beginAnimations("tableAnimation", context: nil)
           sideview.frame = CGRect(x: 0, y: 88, width: 0, height: 808)
             sidebar.frame = CGRect(x: 0, y: 0, width: 0, height: 808)
            UIView.commitAnimations()
            
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
        let vc = segue.destination as! TableViewController
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrdata.count
        
    }
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
//        cell.lbl.text = arrdata[indexPath.row]
//
//        print(cell.lbl.text!)
//               return cell
//    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = arrdata[indexPath.row]
//        cell.img.image = arrImg[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let select = arrdata[indexPath.row]
        if select == "Post"{
            performSegue(withIdentifier: "imageCell", sender: self)
        }
        else if select == "home"{
             self.dismiss(animated: true, completion: nil)
            sidebar.isHidden = true
            sideview.isHidden = true
           
        }else if select == "share"{
            let alert = UIAlertController(title: "", message: "share", preferredStyle: .actionSheet)
            let emailAction = UIAlertAction(title: "Email", style: .default, handler:
               {
                   (alert: UIAlertAction!) -> Void in
                self.sendEmail()
                   print("email")
               })

               let messageAction = UIAlertAction(title: "Message", style: .default, handler:
               {
                   (alert: UIAlertAction!) -> Void in
                self.sendMessage()
                   print("message")
               })

            let otherAction = UIAlertAction(title: "Other", style: .default, handler:
               {
                   (alert: UIAlertAction!) -> Void in
                let activityvc = UIActivityViewController(activityItems: ["www.google.com"], applicationActivities: nil)
                activityvc.popoverPresentationController?.sourceView = self.view
                
                self.present(activityvc,animated: true,completion: nil)
                
                   print("other")
               })
               alert.addAction(emailAction)
               alert.addAction(messageAction)
               alert.addAction(otherAction)
            self.present(alert, animated: true, completion: nil)
            
        }else if select == "signout"{
            exit(0)
        }
        print(select)
    }
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self as? MFMailComposeViewControllerDelegate
            mail.setToRecipients(["you@yoursite.com"])
            mail.setMessageBody("<p>You're so awesome!</p>", isHTML: true)

            present(mail, animated: true)
        } else {
            print("not compatible")
        }
    }
    
    func sendMessage(){
       
            let composeVC = MFMessageComposeViewController()
            composeVC.messageComposeDelegate = self
            
            // Configure the fields of the interface.
            composeVC.recipients = ["3142026521"]
            composeVC.body = "I love Swift!"
            
            // Present the view controller modally.
            if MFMessageComposeViewController.canSendText() {
                self.present(composeVC, animated: true, completion: nil)
            } else {
                print("Can't send messages.")
            }
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
extension signInViewController : MFMailComposeViewControllerDelegate{
    
    
}
extension signInViewController : MFMessageComposeViewControllerDelegate{
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
    }
    
    
}
