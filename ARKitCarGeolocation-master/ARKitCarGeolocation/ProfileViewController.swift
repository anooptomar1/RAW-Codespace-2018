//
//  ProfileViewController.swift
//  ARKitCarGeolocation
//
//  Created by Saransh Mittal on 18/03/18.
//  Copyright © 2018 Esteban Herrera. All rights reserved.
//

import UIKit
import Lottie

class ProfileViewController: UIViewController {

    @IBOutlet weak var viewOne: UIView!
    @IBOutlet weak var viewThree: UIView!
    @IBOutlet weak var viewTwo: UIView!
    @IBOutlet weak var heartbeat: UIView!
    let animationView = LOTAnimationView(name: "Heartbeat")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewOne.layer.borderColor = UIColor.init(red: 52/255, green: 98/255, blue: 78/255, alpha: 1.0).cgColor
        viewOne.layer.borderWidth = 0.4
        viewTwo.layer.borderColor = UIColor.init(red: 52/255, green: 98/255, blue: 78/255, alpha: 1.0).cgColor
        viewTwo.layer.borderWidth = 0.4
        viewThree.layer.borderColor = UIColor.init(red: 52/255, green: 98/255, blue: 78/255, alpha: 1.0).cgColor
        viewThree.layer.borderWidth = 0.4
        animationView?.contentMode = .scaleToFill
        animationView?.frame = CGRect(x: -30, y: 0, width: 500, height: 300)
        self.heartbeat.addSubview(animationView!)
        // Lets turn looping on, since we want it to repeat while the image is 'Downloading'
        animationView?.loopAnimation = true
        // Now play from 0 to 0.5 progress and loop indefinitely.
        animationView?.play()
//        animationView.play(fromProgress: 0, toProgress: 0.5, withCompletion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
