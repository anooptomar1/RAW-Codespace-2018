//
//  dashboard.swift
//  ARKitCarGeolocation
//
//  Created by Saransh Mittal on 18/03/18.
//  Copyright © 2018 Esteban Herrera. All rights reserved.
//

import UIKit
import Lottie

class dashboard: UIView {
    
    @IBOutlet weak var heartbeat: UIView!
    override init(frame: CGRect) {
        let f = CGRect(x: 0, y: 0, width: 100, height: 400)
        super.init(frame: f)
//        alpha()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        alpha()
    }
    let animationView = LOTAnimationView(name: "Heartbeat")
    
    func alpha(){
        animationView?.contentMode = .scaleToFill
        animationView?.frame = CGRect(x: -30, y: 0, width: 500, height: 300)
//        heartbeat.addSubview(animationView!)
        // Lets turn looping on, since we want it to repeat while the image is 'Downloading'
        animationView?.loopAnimation = true
        // Now play from 0 to 0.5 progress and loop indefinitely.
        animationView?.play()
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
