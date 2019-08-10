//
//  TheUserLocationViewController.swift
//  OnTheMap
//
//  Created by Amjad khalid  on 05/01/2019.
//  Copyright © 2019 Amjad khaled. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

//MARK: class TheUserLocationViewController: UIViewController
class TheUserLocationViewController: UIViewController {
    
    // MARK: Properties
    
    var mapString:String?
    var mediaURL:String?
    var latitude:Double?
    var longitude:Double?
    
    // MARK: Outlets
    @IBOutlet weak var theMap: MKMapView!
    
    
    //MARK: override func viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
     
        
    }
    
    
    //MARK: override func viewWillAppear(_ animated: Bool)
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
        
        //setting Annotation to the map
        settingTheAnnotation()
       

    }
    
    //MARK:  @IBAction func finishPostingButton(_ sender: Any)
    @IBAction func finishPostingButton(_ sender: Any) {
        
        //perform the post request
        postStudentLocation()
        
    }
    
    
    //MARK: func  postStudentLocation()
    func  postStudentLocation(){
        
        //check username
        if ParsingData.SharedPoint().userName != nil{
            
            //set the jsonbody as StudentPostJesonBody
            let jsonBody =  StudentPostJesonBody(uniqueKey:ParsingData.SharedPoint().userID! , firstName:ParsingData.SharedPoint().firstName, lastName:ParsingData.SharedPoint().lastName ,latitude:latitude!, longitude:longitude!, mapString:mapString!,mediaURL:mediaURL!)
            
            //call postStudentLocation method to perform the post
            ParsingData.SharedPoint().postStudentLocation(jsonBody: jsonBody) { (success, errorString) in
                
                if success {
                    DispatchQueue.main.async {
                        //dismiss
                        self.tabBarController?.tabBar.isHidden = false
                        if let navigationController = self.navigationController {
                            navigationController.popToRootViewController(animated: true)
                        }
                    }
                }
                else {
                    DispatchQueue.main.async {
                        //show alert
                        let notvalidPlaceAlert = UIAlertController (title: "An Error Accoure!", message: errorString ,preferredStyle: .alert)
                        
                        notvalidPlaceAlert.addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
                            return
                        }))
                        self.present (notvalidPlaceAlert, animated: true, completion: nil)
                        
                    }
                }
                
            }
        }
    }
    
    
    //MARK: func settingTheAnnotation()
    func settingTheAnnotation(){
     
        //creat MKPointAnnotation object
        let annotation = MKPointAnnotation()
        //set Properties
        annotation.title = self.mapString!
        annotation.subtitle = self.mediaURL!
        annotation.coordinate = CLLocationCoordinate2D(latitude: self.latitude!, longitude: self.longitude!)
        
        self.theMap.addAnnotation(annotation)
        //zoom in the map
        self.zoomOnTheMap  ()
        
        
    }
    
    func zoomOnTheMap  (){
        //make the map get zommed to the location
    //i see this https://www.youtube.com/watch?v=B6VIUWfuiOs resourse to do the zooming code
        let Coordinate2D :CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: Coordinate2D, span: span)
        self.theMap.setRegion(region, animated: true)
        
    }
    
}


