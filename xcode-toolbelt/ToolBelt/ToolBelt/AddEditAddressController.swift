//
//  EditAddressController.swift
//  ToolBelt
//
//  Created by Afaan on 5/14/16.
//  Copyright © 2016 teamToolBelt. All rights reserved.
//

import UIKit
import Alamofire

class AddEditAddressController: UIViewController {
    
    // Outlets
    
    
    
    
    
    @IBOutlet weak var addStreetAddress1: UITextField!
    
    
    @IBOutlet weak var addStreetAddress2: UITextField!
    
    
    @IBOutlet weak var addCity: UITextField!
    
    
    @IBOutlet weak var addState: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
    }
    
    
    func editUser() {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let userid: Int = defaults.objectForKey("toolBeltUserID") as! Int
        
        let newStreetAddress1 = String(addStreetAddress1.text!)
        let newStreetAddress2 = String(addStreetAddress2.text!)
        let newCity = String(addCity.text!)
        let newState = String(addState.text!)
        let parameters = ["street_address_1": newStreetAddress1, "street_address_2": newStreetAddress2, "city": newCity, "state": newState]
    
        
        Alamofire.request(.PUT, "http://afternoon-bayou-17340.herokuapp.com/users/\(userid)/", parameters: parameters) .responseJSON {response in
            
            print("Sent new address")
        }
            
    }
    
    
    @IBAction func editButton(sender: AnyObject) {
        editUser()
        
    }
    
    
    
    

    
    

}
