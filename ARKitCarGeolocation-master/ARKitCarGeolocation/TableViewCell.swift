//
//  TableViewCell.swift
//  ARKitCarGeolocation
//
//  Created by Saransh Mittal on 18/03/18.
//  Copyright © 2018 Esteban Herrera. All rights reserved.
//

import UIKit
import Lottie

class PersonTableViewCell: UITableViewCell {
    
    let animationView = LOTAnimationView(name: "Heartbeat")

    @IBOutlet weak var back: UIView!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var heartRate: UIView!
    @IBOutlet weak var name: UILabel!
    
    func animationStart(){
        animationView?.contentMode = .scaleAspectFill
        animationView?.frame = CGRect(x: 0, y: 20, width: 150, height: 30)
        self.heartRate.addSubview(animationView!)
        // Lets turn looping on, since we want it to repeat while the image is 'Downloading'
        animationView?.loopAnimation = true
        // Now play from 0 to 0.5 progress and loop indefinitely.
        animationView?.play()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        print("Started")
//        animationStart()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
//        animationStart()
        // Configure the view for the selected state
    }

}
