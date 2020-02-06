//
//  TableViewCell.swift
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
import FirebaseStorage

class TableViewCell: UITableViewCell {

   
    @IBOutlet weak var buttonOutlet: UIButton!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    @IBAction func button(_ sender: UIButton) {
    }
}
