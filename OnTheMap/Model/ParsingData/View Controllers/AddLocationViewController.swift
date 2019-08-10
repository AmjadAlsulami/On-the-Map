//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Amjad khalid  on 27/12/2018.
//  Copyright © 2018 Amjad khaled. All rights reserved.
//

import UIKit
import CoreLocation

// MARK: class AddLocationViewController: UIViewController
class AddLocationViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var link: UITextField!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    // MARK: Properties
    var latitude : Double?
    var longitude : Double?
    
    // MARK: override func viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: navigationItem Properties
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector (cancelButtonWork))
        
        self.navigationItem.leftBarButtonItem = cancelButton
    }
    
    // MARK: override func viewWillAppear(_ animated: Bool)
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        indicator.isHidden = true
    }
    
    
    // MARK: func cancelButtonWork()
    @objc func cancelButtonWork(){
        
        DispatchQueue.main.async {
            self.tabBarController?.tabBar.isHidden = false
            if let navigationController = self.navigationController {
                navigationController.popToRootViewController(animated: true)
            }
        }
    }
    
    
    // MARK: func findLocation(_ sender: Any)
    @IBAction func findLocation(_ sender: Any) {
        
        let stulocation = location.text
        
        let stulink = link.text
        
        //check
        if (stulocation!.isEmpty) ||   (stulink?.hasPrefix("https://") == false) {
            //show alert
            let requiredInfoAlert = UIAlertController (title: "Fill  correctley", message: "Please fill both the location and link correctley ", preferredStyle: .alert)
            
            requiredInfoAlert.addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
                return
            }))
            
            self.present (requiredInfoAlert, animated: true, completion: nil)
            
        } else {
            
            indicator.isHidden =  false
            indicator.startAnimating()
            
            //creat CLGeocoder() object
            let geoCoder = CLGeocoder()
            
            //transform text to number using geocodeAddressString (doubls)
            geoCoder.geocodeAddressString(stulocation!, completionHandler: {(placepoints, error) -> Void in
                if((error) != nil){
                    //alert
                    
                    DispatchQueue.main.async {
                        let notvalidPlaceAlert = UIAlertController (title: "No Such a Place!", message: "\(String(describing: error!))", preferredStyle: .alert)
                        notvalidPlaceAlert.addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
                            return
                        }))
                        
                        //stop indicator and hide
                        self.indicator.stopAnimating()
                        self.indicator.isHidden =  true
                        
                        self.present (notvalidPlaceAlert, animated: true, completion: nil)
                       
                       
                    }
                }
                    
                else{
                    //set variables
                    if let placemark = placepoints?.first {
                        let coordinates: CLLocationCoordinate2D = placemark.location!.coordinate
                        self.latitude = coordinates.latitude
                        self.longitude =  coordinates.longitude
                    }
                    
                    //stop indicator and hide
                    self.indicator.stopAnimating()
                    self.indicator.isHidden =  true
                    //move to the TheUserLocationViewController view controller
                    self.performSegue(withIdentifier: "letsAddTheLocation", sender: nil)
                }
            })
            
        }
    }
    
    
    // MARK:  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "letsAddTheLocation"{
            let vc = segue.destination as! TheUserLocationViewController
            
            vc.mapString = location.text
            vc.mediaURL = link.text
            vc.latitude = self.latitude
            vc.longitude = self.longitude
            
        }
        
    }
}




