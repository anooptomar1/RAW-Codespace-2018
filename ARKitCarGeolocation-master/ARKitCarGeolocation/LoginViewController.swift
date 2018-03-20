
//
//  LoginViewController.swift
//  ARKitCarGeolocation
//
//  Created by Saransh Mittal on 18/03/18.
//  Copyright © 2018 Esteban Herrera. All rights reserved.
//

import UIKit
import LocalAuthentication

class LoginViewController: UIViewController,UITextFieldDelegate {
    
    func notifyUser(_ msg: String, err: String?) {
        let alert = UIAlertController(title: msg,message: err,preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK",style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        self.present(alert, animated: true,completion: nil)
    }
    
    //for activation of finger print authentication this function is used along with notify function
    func fingerprintAuthentication(){
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics,error: &error){
            // Device can use TouchID
            context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics,localizedReason: "Access requires authentication",reply: {(success, error) in
                DispatchQueue.main.async {
                    if error != nil {
                        switch error!._code {
                        case LAError.Code.systemCancel.rawValue:self.notifyUser("Session cancelled",err: error?.localizedDescription)
                        case LAError.Code.userCancel.rawValue:self.notifyUser("Please try again",err: error?.localizedDescription)
                        case LAError.Code.userFallback.rawValue:self.notifyUser("Authentication",err: "Success")
                        // Custom code to obtain password here
                        default:self.notifyUser("Authentication failed",err: error?.localizedDescription)
                        }
                    }
                    else {
                        //If Authentication is successfull then payment is carried forward
//                        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//                        let loggedInView = storyboard.instantiateViewController(withIdentifier: "homePage")
                        
                    }
                }
            })
        }
        else {
            // Device cannot use TouchID
        }
    }
    func addParallaxToBackground(){
        let min = CGFloat(-0)
        let max = CGFloat(0)
        let xMotion = UIInterpolatingMotionEffect(keyPath: "layer.transform.translation.x", type: .tiltAlongHorizontalAxis)
        xMotion.minimumRelativeValue = min
        xMotion.maximumRelativeValue = max
        let yMotion = UIInterpolatingMotionEffect(keyPath: "layer.transform.translation.y", type: .tiltAlongVerticalAxis)
        yMotion.minimumRelativeValue = min
        yMotion.maximumRelativeValue = max
        let motionEffectGroup = UIMotionEffectGroup()
        motionEffectGroup.motionEffects = [xMotion,yMotion]
        backgroundImage.addMotionEffect(motionEffectGroup)
    }

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBAction func scan(_ sender: Any) {
        fingerprintAuthentication()
    }
    
    var initialCenter: CGFloat = 0.0
    var constant:CGFloat = 150.0
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3) {
            self.bottonConstraint.constant += self.constant
            self.view.layoutIfNeeded()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if !(self.idField.isEditing) {
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.3, animations: {
                self.bottonConstraint.constant -= self.constant
                self.view.layoutIfNeeded()
            })
        }
    }
    @objc func dismissKeyboard() {
        idField.resignFirstResponder()
    }
    
    @IBOutlet weak var bottonConstraint: NSLayoutConstraint!
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var idField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addParallaxToBackground()
        idField.delegate = self
        idField.layer.borderColor = UIColor.init(red: 148/255, green: 112/255, blue: 73/255, alpha: 1.0).cgColor
        scanButton.layer.borderColor = UIColor.init(red: 148/255, green: 112/255, blue: 73/255, alpha: 1.0).cgColor
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard)))
        UIApplication.shared.statusBarStyle = .lightContent
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
