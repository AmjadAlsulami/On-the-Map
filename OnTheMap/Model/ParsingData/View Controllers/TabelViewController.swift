//
//  TabelViewController.swift
//  OnTheMap
//
//  Created by Amjad khalid  on 24/12/2018.
//  Copyright © 2018 Amjad khaled. All rights reserved.
//

import UIKit
// MARK: class TabelViewController: UIViewController

class TabelViewController : UIViewController, UITableViewDelegate,UITableViewDataSource {
    

    // MARK: Properties
    var studentArray = UuserDataArray.shared.studentDataArray
    
    
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    // MARK:  override func viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        // MARK: navigationItem Properties
        let logoutButton = UIBarButtonItem(title: "LOGOUT", style: .done, target: self, action: #selector (logoutButtonWork))
        
        self.navigationItem.leftBarButtonItem = logoutButton
        
        let refrechButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector (refrechButtonWork))
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector (addButtonWork))
        
        self.navigationItem.rightBarButtonItems = [addButton,refrechButton]
        
        
    }
    
    
    // MARK:  override func viewWillAppear(_ animated: Bool)
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //call student location getter
        studentsLocationGetter()
        
        indicator.isHidden = false
        indicator.startAnimating()
        //Update table view
        tableView.reloadData()
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
                    let connetsingoutAlert = UIAlertController (title: " Sing Out Error", message: errorString, preferredStyle: .alert)
                    
                    connetsingoutAlert .addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
                        return
                    }))
                    
                    self.present ( connetsingoutAlert , animated: true, completion: nil)
                }}}
    }
    
    
    // MARK: refrechButtonWork()
    @objc func refrechButtonWork(){
        //recall the getter method to regetting data
        
        indicator.isHidden = false
        indicator.startAnimating()
        
        self.studentsLocationGetter()
    }
    
    
    // MARK: addButtonWork()
    @objc func addButtonWork(){
        //move to the Addlocation view controller
        self.performSegue(withIdentifier: "letsAddstudentNow", sender: nil)
    }
    
    
    //Mark : studentsLocationGetter()
    private func studentsLocationGetter() {
        //reset bstudentArray
        studentArray.removeAll()
        
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
                    
                    DispatchQueue.main.async {
                        //relload table to show data
                        self.tableView.reloadData()
                    }
                    
                }
            
                else{
                    //show alert
                    
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
        
        
        
        //MARK: func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return  self.studentArray.count
        }
        
        
        //MARK: func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentCell")
        
        //Get cell information
        let StudentInfo = self.studentArray[indexPath.row] as! StudentInformation
        let frist = StudentInfo.firstName , last = StudentInfo.lastName, url = StudentInfo.mediaURL
        cell?.textLabel!.text = "\(frist ?? "FirstName") \(last ?? "LastName")"
        cell?.detailTextLabel?.text = url
     
        return cell!
    }


    
    //MARK: func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let StudentInfo = self.studentArray[indexPath.row] as! StudentInformation
        
        let stuUrl = StudentInfo.mediaURL
        
        if let stuUrl = stuUrl {
            
            //check validty of url
            if  (stuUrl.hasPrefix("https://")) {
                // check if your application can open the NSURL instance
                let app = UIApplication.shared
                
                app.open(NSURL(string: stuUrl)! as URL, options: [:], completionHandler: nil)
            }
        }
        else{
            
            DispatchQueue.main.async {
                //show alert if not
                let notvalidAlert = UIAlertController(title: "Alert", message: "NOt valid URL to  be Open", preferredStyle: .alert)
                notvalidAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(notvalidAlert, animated: true, completion: nil)
                
            }
        }
   
    }
}



