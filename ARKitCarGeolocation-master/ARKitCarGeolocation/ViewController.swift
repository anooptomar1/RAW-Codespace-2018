//
//  ViewController.swift
//  ARKitCarGeolocation
//
//  Created by Esteban Herrera on 11/22/17.
//  Copyright © 2017 Esteban Herrera. All rights reserved.
//

import UIKit
import ARKit

import SceneKit
import CoreLocation
import PusherSwift

class ViewController: UIViewController, ARSCNViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var statusTextView: UITextView!
    
    func instanceFromNib() -> UIView {
        return UINib(nibName: "dashboard", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    let locationManager = CLLocationManager()
    var userLocation = CLLocation()
    
    var heading : Double! = 0.0
    var distance : Float! = 0.0 {
        didSet {
            setStatusText()
        }
    }
    var status: String! {
        didSet {
            setStatusText()
        }
    }
    
    var modelNode:SCNNode!
    let rootNodeName = "Car"
    
    var originalTransform:SCNMatrix4!
    
    let pusher = Pusher(
        key: "323f7bcc40ed7f8ff7f2",
        options: PusherClientOptions(
            authMethod: .inline(secret: "ab688bf7be78368786fe"),
            host: .cluster("ap2")
        )
    )
    var channel: PusherChannel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        // Start location services
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation//kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // Set the initial status
        status = "Getting user location..."
        
        // Set a padding in the text view
        statusTextView.textContainerInset = UIEdgeInsetsMake(30.0, 10.0, 10.0, 0.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.worldAlignment = .gravityAndHeading
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setStatusText() {
        var text = "Status: \(status!)\n"
        text += "Distance: \(String(format: "%.2f m", distance))"
        statusTextView.text = text
    }
    
    //MARK: - CLLocationManager
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations.last)

        if let location = locations.last {
            userLocation = location
            status = "Connecting to Pusher..."
            self.connectToPusher()
        } else {
            status = "Changing location"
            userLocation = locations.last!
            status = "Connecting to Pusher..."
            self.connectToPusher()
        }
    }
    
    //MARK: - Utility methods
    func connectToPusher() {
        // subscribe to channel and bind to event
        let channel = pusher.subscribe("private-channel")
        
        let _ = channel.bind(eventName: "client-new-location", callback: { (data: Any?) -> Void in
            if let data = data as? [String : AnyObject] {
                print(data)
                
                if let latitude = Double(data["latitude"] as! String),
                      let longitude = Double(data["longitude"] as! String),
                      let heading = Double(data["heading"] as! String)  {
                    self.status = "Driver's location received"
                    self.heading = heading
                    self.updateLocation(latitude, longitude)
                }
            }
        })
        
        pusher.connect()
        status = "Waiting to receive location events..."
    }
    
    func updateLocation(_ latitude : Double, _ longitude : Double) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        self.distance = Float(location.distance(from: self.userLocation))
        
        if self.modelNode == nil {
            let modelScene = SCNScene(named: "art.scnassets/Car.scn")
            self.modelNode = modelScene?.rootNode.childNode(withName: rootNodeName, recursively: true)!
            // Move model's pivot to its center in the Y axis
            let (minBox, maxBox) = self.modelNode.boundingBox
            self.modelNode.pivot = SCNMatrix4MakeTranslation(0, (maxBox.y - minBox.y)/2, 0)
            // Save original transform to calculate future rotations
            self.originalTransform = self.modelNode.transform
            // Position the model in the correct place
            positionModel(location)
            // Add the model to the scene
            sceneView.scene.rootNode.addChildNode(self.modelNode)
            
//            guard let carScene = SCNScene(named: "don.dae") else { return }
//            let carNode = SCNNode()
//            let carSceneChildNodes = carScene.rootNode.childNodes
//            for childNode in carSceneChildNodes {
//                carNode.addChildNode(childNode)
//            }
//            carNode.position = SCNVector3(0.5, 0.5, 0.5)
//            carNode.scale = SCNVector3(0.5, 0.5, 0.5)
//            sceneView.scene.rootNode.addChildNode(carNode)
            
            var view = UIView()
            view.frame = CGRect(x: 0, y: 0, width: 100, height: 600)
            view = instanceFromNib()
            let im = view.asImage()
            let arrow = makeBillboardNode(im!)
            arrow.position = SCNVector3Make(0, 4, 0)
            self.modelNode.addChildNode(arrow)
            
//            let cubeNode = SCNNode(geometry: SCNBox(width: 10, height: 10, length: 10, chamferRadius: 0))
//            cubeNode.position = SCNVector3(0, 0, 0)
//            sceneView.scene.rootNode.addChildNode(cubeNode)
//            // Create arrow from the emoji
//            let image = "Saransh Mittal".image()!
//            let arrow = makeBillboardNode(image)
//            // Position it on top of the car
//            arrow.position = SCNVector3Make(0, 4, 0)
//            // Add it as a child of the car model
//            self.modelNode.addChildNode(arrow)
        } else {
            // Begin animation
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 1.0
            
            // Position the model in the correct place
            positionModel(location)
            
            // End animation
            SCNTransaction.commit()
        }
    }
    
    func positionModel(_ location: CLLocation) {
        // Rotate node
        self.modelNode.transform = rotateNode(Float(-1 * (self.heading - 180).toRadians()), self.originalTransform)
        // Translate node
        self.modelNode.position = translateNode(location)
        // Scale node
        self.modelNode.scale = scaleNode(location)
//        print(location)
//        if location != nil {
//
//        } else {
//            print("Found nil value")
//        }
        
    }
    
    func rotateNode(_ angleInRadians: Float, _ transform: SCNMatrix4) -> SCNMatrix4 {
        let rotation = SCNMatrix4MakeRotation(angleInRadians, 0, 1, 0)
        return SCNMatrix4Mult(transform, rotation)
    }
    
    func translateNode (_ location: CLLocation) -> SCNVector3 {
        let locationTransform = transformMatrix(matrix_identity_float4x4, userLocation, location)
        return positionFromTransform(locationTransform)
    }
    
    func scaleNode (_ location: CLLocation) -> SCNVector3 {
        let scale = max( min( Float(1000/distance), 1.5 ), 3 )
        return SCNVector3(x: scale, y: scale, z: scale)
    }
    
    func positionFromTransform(_ transform: simd_float4x4) -> SCNVector3 {
        return SCNVector3Make(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
    }
    
    func transformMatrix(_ matrix: simd_float4x4, _ originLocation: CLLocation, _ driverLocation: CLLocation) -> simd_float4x4 {
        let bearing = bearingBetweenLocations(userLocation, driverLocation)
        let rotationMatrix = rotateAroundY(matrix_identity_float4x4, Float(bearing))
        
        let position = vector_float4(0.0, 0.0, -distance, 0.0)
        let translationMatrix = getTranslationMatrix(matrix_identity_float4x4, position)
        
        let transformMatrix = simd_mul(rotationMatrix, translationMatrix)
        
        return simd_mul(matrix, transformMatrix)
    }
    
    func getTranslationMatrix(_ matrix: simd_float4x4, _ translation : vector_float4) -> simd_float4x4 {
        var matrix = matrix
        matrix.columns.3 = translation
        return matrix
    }
    
    func rotateAroundY(_ matrix: simd_float4x4, _ degrees: Float) -> simd_float4x4 {
        var matrix = matrix
        
        matrix.columns.0.x = cos(degrees)
        matrix.columns.0.z = -sin(degrees)
        
        matrix.columns.2.x = sin(degrees)
        matrix.columns.2.z = cos(degrees)
        return matrix.inverse
    }
    
    func bearingBetweenLocations(_ originLocation: CLLocation, _ driverLocation: CLLocation) -> Double {
        let lat1 = originLocation.coordinate.latitude.toRadians()
        let lon1 = originLocation.coordinate.longitude.toRadians()
        
        let lat2 = driverLocation.coordinate.latitude.toRadians()
        let lon2 = driverLocation.coordinate.longitude.toRadians()
        
        let longitudeDiff = lon2 - lon1
        
        let y = sin(longitudeDiff) * cos(lat2);
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(longitudeDiff);
        
        return atan2(y, x)
    }
    
    func makeBillboardNode(_ image: UIImage) -> SCNNode {
        let plane = SCNPlane(width: 10, height: 10)
        plane.firstMaterial!.diffuse.contents = image
        let node = SCNNode(geometry: plane)
        node.constraints = [SCNBillboardConstraint()]
        return node
    }

}

//extension UIImage {
//    convenience init(view: UIView) {
//        UIGraphicsBeginImageContext(view.frame.size)
//        view.layer.render(in:UIGraphicsGetCurrentContext()!)
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        self.init(cgImage: image!.cgImage!)
//    }
//}

extension UIView {
    
    func asImage() -> UIImage? {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(bounds: bounds)
            return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }
        } else {
            UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0.0)
            defer { UIGraphicsEndImageContext() }
            guard let currentContext = UIGraphicsGetCurrentContext() else {
                return nil
            }
            self.layer.render(in: currentContext)
            return UIGraphicsGetImageFromCurrentImageContext()
        }
    }
}

extension UIView {
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "<<NibFileName>>", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
}

