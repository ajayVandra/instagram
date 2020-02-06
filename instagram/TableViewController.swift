//
//  TableViewController.swift
//  instagram
//
//  Created by Ajay Vandra on 2/5/20.
//  Copyright © 2020 Ajay Vandra. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FirebaseFirestore
import Crashlytics
import FirebaseAnalytics
import AVFoundation
import AVKit
import FirebaseStorage
class TableViewController: UITableViewController {
    var array = [StorageReference]()
    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(array.count)
        return array.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let image = array[indexPath.row]
        print(image)
        let storageRef = Storage.storage().reference(withPath: "\(image.fullPath)")
        storageRef.getData(maxSize: 2 * 1024 * 1024) { data, error in
          if let error = error {
            // Uh-oh, an error occurred!
          } else {
            // Data for "images/island.jpg" is returned
            cell.imageView?.image = UIImage(data: data!)
          }
        }
        return cell
    }
    func loadData(){
        let storageRef = Storage.storage().reference(withPath: "name/")
        storageRef.listAll { (result, error) in
            for item in result.items{
                self.array = result.items
                print(result.items)
                self.tableView.reloadData()
                
            }
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let path = Bundle.main.path(forResource: "Test", ofType: "mp4") else {
                return
            }
            let videoURL = URL(fileURLWithPath: path)
            let player = AVPlayer(url: videoURL)
            let playerView = AVPlayerViewController()
            playerView.player = player
            self.present(playerView, animated: true){
                playerView.player?.play()
            }
        }
}
