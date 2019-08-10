//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Amjad khalid  on 24/12/2018.
//  Copyright © 2018 Amjad khaled. All rights reserved.
//

import UIKit
import MapKit

// MARK: MapViewController: UIViewController, MKMapViewDelegate
class MapViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var theMap: MKMapView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    // MARK: Properties
    var annotations = [MKPointAnnotation] ()
    var studentArray = UuserDataArray.shared.studentDataArray
    
    
    // MARK:override func viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: navigationItem Properties
        let logoutButton = UIBarButtonItem(title: "LOGOUT", style: .done, target: self, action: #selector (logoutButtonWork))
        
        self.navigationItem.leftBarButtonItem = logoutButton
        
        let refrechButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector (refrechButtonWork))
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector (addButtonWork))
        
        self.navigationItem.rightBarButtonItems = [addButton,refrechButton]
        theMap.delegate = self
        
    }
    
    //Mark : viewWillAppear(_ animated: Bool)
    override func viewWillAppear(_ animated: Bool) {
        //call student location getter
        studentsLocationGetter()
        indicator.isHidden = false
        indicator.startAnimating()
    }
    
    
    // MARK: func logoutButtonWork()
    @objc func logoutButtonWork(){
        //call the deleitinginASession to perform the sing out action
        ParsingData.SharedPoint().deleitinginASession { (success, sessionID, errorString) in
            
            DispatchQueue.main.async {
                if success {
                    self.dismiss(animated: true, completion: nil)
                    
                }
                else {
                    //show alert
                    let connetsingoutAlert = UIAlertController (title: " Sing Out Error", message: errorString , preferredStyle: .alert)
                    
                    connetsingoutAlert .addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
                        return
                    }))
                    
                    self.present ( connetsingoutAlert , animated: true, completion: nil)
                }}}
    }
    
    
    // MARK: refrechButtonWork()
    @objc func refrechButtonWork(){
        
        indicator.isHidden = false
        indicator.startAnimating()
        
        //recall the getter method to regetting data
        self.studentsLocationGetter()
    }
    
    
    // MARK: addButtonWork()
    @objc func addButtonWork(){
        //move to the Addlocation view controller
        self.performSegue(withIdentifier: "letsAddstudentNow", sender: nil)
    }
    
    
    //Mark : studentsLocationGetter()
    private func studentsLocationGetter(){
        //reset both arrays to reload the refreshed data to them
        studentArray.removeAll()
        annotations.removeAll()
        
        //call the gettingStudentLocations to perform the get request
        ParsingData.SharedPoint().gettingStudentLocations(completion: ){ (success, data, error) in
            DispatchQueue.main.async {
                if success {
                    //Guard: check returned  result
                    guard   let studentLocation = data as! [StudentInformation]? else {
                        
                        //stop indicator and hide
                        self.indicator.stopAnimating()
                        self.indicator.isHidden =  true
                        
                        //show alert
                        let locationsErrorAlert = UIAlertController(title: "Erorr loading locations", message: error, preferredStyle: .alert )
                        
                        locationsErrorAlert.addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
                            return
                        }))
                        self.present(locationsErrorAlert, animated: true, completion: nil)
                        return
                    }
                    //set the studentArray to StudentInformation array
                    self.studentArray = studentLocation
                    
                    //stop indicator and hide
                    self.indicator.stopAnimating()
                    self.indicator.isHidden =  true
                    
                    //for loop to add annotations array Properties using studentLocation array information
                    for index in studentLocation {
                        
                        
                        if let latitude = index.latitude , let longitude = index.longitude , let first = index.firstName ,let last = index.lastName , let mediaURL = index.mediaURL {
                            //convert double object to CLLocationDegrees
                            let lat = CLLocationDegrees(latitude)
                            let long = CLLocationDegrees(longitude)
                            
                            //create CLLocationCoordinate2D coordinate
                            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                            
                            //set annotation object
                            
                            let annotation = MKPointAnnotation()
                            
                            //set Properties
                            annotation.coordinate = coordinate
                            annotation.title = "\(first) \(last)"
                            annotation.subtitle = mediaURL
                            
                            //add object to annotations array
                            self.annotations.append(annotation)
                            
                        }
                        // ass annotationsarray to the map
                        self.theMap.addAnnotations(self.annotations)
                        
                    }
                }
                    
                else{
                    // show alert
                    if error != nil {
                        
                        //stop indicator and hide
                        self.indicator.stopAnimating()
                        self.indicator.isHidden =  true
                        
                        let errorAlert = UIAlertController(title: "Erorr performing request", message: error, preferredStyle: .alert )
                        
                        errorAlert.addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
                            return
                        }))
                        self.present(errorAlert, animated: true, completion: nil)
                        return
                    }
                   
                    
                }
            }
        }
    }
    
    
    //MARK: func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        //set pin in the  map
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    //MARK: func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl)
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            
            if let stuUrl = view.annotation?.subtitle! {
                
                //check url if it was correct url to be open
                if (stuUrl.hasPrefix("https://")) {
                    
                    app.open( NSURL(string: stuUrl)! as URL, options: [:], completionHandler: nil)
                }
                    
                else{
                    DispatchQueue.main.async {
                        //show alert if not
                        let notvalidAlert = UIAlertController (title: "Not a valid Url", message: "NOt valid URL to  be Open", preferredStyle: .alert)
                        
                        notvalidAlert.addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
                            return
                        }))
                        
                        self.present (notvalidAlert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
}


