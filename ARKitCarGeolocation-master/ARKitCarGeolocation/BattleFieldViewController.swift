//
//  BattleFieldViewController.swift
//  ARKitCarGeolocation
//
//  Created by Saransh Mittal on 18/03/18.
//  Copyright © 2018 Esteban Herrera. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class BattleFieldViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    let names = ["CAPTAIN VIKAM RAO", "CAPTAIN HARSHA", "CAPTAIN SARANSH", "ANSH MEHRA"]
    let distance = ["310m", "140m", "40m", "100m"]
    let check = [1,0,1,1]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableOfperson.dequeueReusableCell(withIdentifier: "person", for: indexPath) as! PersonTableViewCell
        cell.name.text = names[indexPath.row]
        cell.distance.text = distance[indexPath.row] + "Away"
        cell.back.layer.borderWidth = 0.4
        cell.back.layer.borderColor = UIColor.init(red: 52/255, green: 98/255, blue: 78/255, alpha: 1.0).cgColor
        if check[indexPath.row] == 1{
            cell.status.text = "ALIVE"
            cell.name.textColor = UIColor.green
            cell.status.textColor = UIColor.green
            cell.distance.textColor = UIColor.green
            cell.animationStart()
        } else {
            cell.status.text = "INJURED"
            cell.name.textColor = UIColor.red
            cell.status.textColor = UIColor.red
            cell.distance.textColor = UIColor.red
        }
        return cell
    }
    

    @IBOutlet weak var tableOfperson: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var viewThree: UIView!
    @IBOutlet weak var viewTwo: UIView!
    @IBOutlet weak var viewOne: UIView!
    
    let locationManager = CLLocationManager()
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
        }
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewOne.layer.borderColor = UIColor.init(red: 52/255, green: 98/255, blue: 78/255, alpha: 1.0).cgColor
        viewOne.layer.borderWidth = 0.4
        viewTwo.layer.borderColor = UIColor.init(red: 52/255, green: 98/255, blue: 78/255, alpha: 1.0).cgColor
        viewTwo.layer.borderWidth = 0.4
        viewThree.layer.borderColor = UIColor.init(red: 52/255, green: 98/255, blue: 78/255, alpha: 1.0).cgColor
        viewThree.layer.borderWidth = 0.4
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = 2.0
        locationManager.requestWhenInUseAuthorization()
        tableOfperson.delegate = self
        tableOfperson.dataSource = self
        
        let annotation = MKPointAnnotation()
        let annotation2 = MKPointAnnotation()
        let annotation3 = MKPointAnnotation()
        let annotation4 = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: 12.976226, longitude: 79.160368)
        annotation.title = "Harsha"
        mapView.addAnnotation(annotation)
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(CLLocationCoordinate2D(latitude: 12.976226, longitude: 79.160368), span)
        mapView.setRegion(region, animated: true)
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
