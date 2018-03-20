//
//  BattlefieldMapViewController.swift
//  ARKitCarGeolocation
//
//  Created by Saransh Mittal on 18/03/18.
//  Copyright © 2018 Esteban Herrera. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class BattlefieldMapViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = 2.0
        locationManager.requestWhenInUseAuthorization()
        
        let annotation = MKPointAnnotation()
        let annotation2 = MKPointAnnotation()
        let annotation3 = MKPointAnnotation()
        let annotation4 = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: 12.976226, longitude: 79.160368)
        annotation.title = "Harsha"
        mapView.addAnnotation(annotation)
        annotation2.coordinate = CLLocationCoordinate2D(latitude: 12.972839, longitude: 79.169144)
        annotation2.title = "Ansh"
        mapView.addAnnotation(annotation2)
        annotation3.coordinate = CLLocationCoordinate2D(latitude: 13.015418, longitude: 79.095032)
        annotation3.title = "Saransh"
        mapView.addAnnotation(annotation3)
        annotation4.coordinate = CLLocationCoordinate2D(latitude: 12.972839, longitude: 79.169144)
        annotation4.title = "Vikram"
        mapView.addAnnotation(annotation4)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        mapView.camera.heading = newHeading.magneticHeading
        mapView.setCamera(mapView.camera, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        mapView.setRegion(region, animated: true)
        self.mapView.showsUserLocation = true
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
