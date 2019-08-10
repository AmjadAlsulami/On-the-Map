//
//  ViewController.swift
//  OnTheMap
//
//  Created by Amjad khalid  on 15/12/2018.
//  Copyright © 2018 Amjad khaled. All rights reserved.
//

import UIKit
import SafariServices

// MARK:  LogInViewController: UIViewController
class LogInViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var EmailTextFeild: UITextField!
    @IBOutlet weak var PasswordTextFeild: UITextField!
    
    
    // MARK:override func viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //Mark: override func viewWillDisappear(_ animated: Bool)
    override func viewWillDisappear(_ animated: Bool) {
        EmailTextFeild.text = ""
        PasswordTextFeild.text = ""
    }
    
    
    //Mark:  func logInAction(_ sender: Any)
    @IBAction func logInAction(_ sender: Any) {
        
        // MARK: Set Properties
        let email = EmailTextFeild.text
        let password = PasswordTextFeild.text
        
        //check Properties
        if (email!.isEmpty) || (password!.isEmpty) {
            
            let requiredInfoAlert = UIAlertController (title: "Fill the required fields", message: "Please fill both the email and password", preferredStyle: .alert)
            
            requiredInfoAlert.addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
                return
            }))
            
            self.present (requiredInfoAlert, animated: true, completion: nil)
            
        } else {
            
            //create  UuserSessionBody using provided student email and password
            let jsonbody = UuserSessionBody(udacity: Uuser(username: email!, password: password!))
            
            //Start the authentcation process by calling ParsingData.SharedPoint().userUuthentication method
            ParsingData.SharedPoint().userUuthentication(jsonBody: jsonbody) { (success,errorString) in
                DispatchQueue.main.async {
                    //check result
                    if success {
                        //show the taP bar
                        let mainST = UIStoryboard(name: "Main", bundle: Bundle.main)
                        let VC = mainST.instantiateViewController(withIdentifier: "idTabBar")
                        self.present(VC, animated: true, completion: nil)
                        
                        
                    }
                    else {
                        //show error there is wrong information given
                        let loginAlert = UIAlertController(title: "Erorr logging in", message: errorString, preferredStyle: .alert )
                        
                        loginAlert.addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
                            return
                        }))
                        self.present(loginAlert, animated: true, completion: nil)
                    }
                }
                
            }
        }
        
    }
    
    
    //Mark:  func signUpButton(_ sender: Any)
    @IBAction func signUpButton(_ sender: Any) {
        // open the udacity sing up page in safari
        guard let url = URL(string: "https://auth.udacity.com/sign-up") else { return }
        let sfo = SFSafariViewController(url: url)
        present(sfo, animated: true, completion: nil)
    }
}

