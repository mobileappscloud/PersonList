//
//  EditViewController.swift
//  PersonList
//
//  Created by Faisal Syed on 9/2/16.
//  Copyright © 2016 Faisal Syed. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class EditViewController: UIViewController, UITextFieldDelegate
{
    let peopleTVC: PeopleTableViewController? = nil
    
    let firstNameField: UITextField =
        {
            let tf = UITextField()
            tf.placeholder = "Enter Firstname..."
            tf.textAlignment = .Center
            tf.translatesAutoresizingMaskIntoConstraints = false
            return tf
    }()
    
    let lastNameField: UITextField =
        {
            let tf = UITextField()
            tf.placeholder = "Enter Lastname..."
            tf.textAlignment = .Center
            tf.translatesAutoresizingMaskIntoConstraints = false
            return tf
    }()
    
    let dateOfBirthField: UITextField =
        {
            let tf = UITextField()
            tf.placeholder = "Enter Date of Birth..."
            tf.textAlignment = .Center
            tf.translatesAutoresizingMaskIntoConstraints = false
            return tf
    }()
    
    let zipcodeField: UITextField =
        {
            let tf = UITextField()
            tf.placeholder = "Enter Zipcode..."
            tf.textAlignment = .Center
            tf.translatesAutoresizingMaskIntoConstraints = false
            tf.keyboardType = .NumberPad
            return tf
    }()
    
    lazy var finishButton: UIButton =
    {
            let button = UIButton(type: .System)
            button.setTitle("Finish Editing", forState: .Normal)
            button.addTarget(self, action: #selector(handleEditPerson), forControlEvents: .TouchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
    }()
    
    func handleEditPerson()
    {
        self.dismissViewControllerAnimated(true, completion: nil)
       
        //Retrieve proper user entry in Firebase and update its values
        let ref = FIRDatabase.database().reference().child("Users")
        ref.observeEventType(.ChildAdded, withBlock: { (snapshot) in
       
            guard let dictionary = snapshot.value as? [String:AnyObject] else { return }
            
            if self.firstNameField.text == dictionary["firstname"] as? String
            {
                if let lastname = dictionary["lastname"]
                {
                    print("Here is the lastname of the current person \(lastname)")
                    
                    guard let firstname = self.firstNameField.text, lastname = self.lastNameField.text, dateOfBirth = self.dateOfBirthField.text, zipcode = Int(self.zipcodeField.text!) else
                    {
                        print("Form not valid")
                        return
                    }
                    
                    
                    let properties: [String: AnyObject] = ["firstname": firstname, "lastname": lastname, "Date of Birth": dateOfBirth, "Zipcode": zipcode]
                    
                    let currentKey = snapshot.key
                    ref.child(currentKey).updateChildValues(properties, withCompletionBlock: { (error, ref) in
                        
                        if error != nil
                        {
                            print("We have an error updating the data \(error)")
                        }
                        
                        print("We were able to update the entry in the reference \(ref)")
                        
                    })
                }
            }
            
        }, withCancelBlock: nil)
    }
    
    func setUpUI()
    {
        // Need iOS9 Constraints for X, Y, W, H
        
        zipcodeField.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        zipcodeField.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true
        zipcodeField.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        zipcodeField.heightAnchor.constraintEqualToConstant(50).active = true
        
        dateOfBirthField.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        dateOfBirthField.bottomAnchor.constraintEqualToAnchor(zipcodeField.topAnchor).active = true
        dateOfBirthField.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        dateOfBirthField.heightAnchor.constraintEqualToConstant(50).active = true
        
        lastNameField.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        lastNameField.bottomAnchor.constraintEqualToAnchor(dateOfBirthField.topAnchor).active = true
        lastNameField.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        lastNameField.heightAnchor.constraintEqualToConstant(50).active = true
        
        firstNameField.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        firstNameField.bottomAnchor.constraintEqualToAnchor(lastNameField.topAnchor).active = true
        firstNameField.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        firstNameField.heightAnchor.constraintEqualToConstant(50).active = true
        
        finishButton.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        finishButton.topAnchor.constraintEqualToAnchor(zipcodeField.bottomAnchor).active = true
        finishButton.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        finishButton.heightAnchor.constraintEqualToConstant(60).active = true
    }
    
    var fullname: String!
    
    func retrieveDataAndPopulateFields()
    {
        let ref = FIRDatabase.database().reference().child("Users")
        ref.observeEventType(.ChildAdded, withBlock: { (snapshot) in
            
            if let firstname = snapshot.value?.objectForKey("firstname"), lastname = snapshot.value?.objectForKey("lastname")
            {
                let fullnameString = "\(firstname) \(lastname)"
                
                if self.fullname == fullnameString
                {
                    if let dateofBirth = snapshot.value?.objectForKey("Date of Birth"), zipcode = snapshot.value?.objectForKey("Zipcode")
                    {
                        dispatch_async(dispatch_get_main_queue())
                        {
                            let zipcodeString = String(zipcode)
                            
                            self.firstNameField.text = firstname as? String
                            self.lastNameField.text = lastname as? String
                            self.dateOfBirthField.text = dateofBirth as? String
                            self.zipcodeField.text = zipcodeString 
                        }
                        
                    }
                }
                
            }
            
            }, withCancelBlock: nil)
    }
    
    override func viewDidLoad()
    {
        view.addSubview(zipcodeField)
        view.addSubview(dateOfBirthField)
        view.addSubview(lastNameField)
        view.addSubview(firstNameField)
        view.addSubview(finishButton)
        
        setUpUI()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard))
        view.addGestureRecognizer(tap)
        
        retrieveDataAndPopulateFields()
    }
    
    func dismissKeyBoard()
    {
        view.endEditing(true)
    }
    
    override func viewDidLayoutSubviews()
    {
        zipcodeField.addBorderLayer()
        dateOfBirthField.addBorderLayer()
        lastNameField.addBorderLayer()
        firstNameField.addBorderLayer()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        self.view.endEditing(true)
        return false
    }

}
