//
//  CreatePerson.swift
//  PersonList
//
//  Created by Faisal Syed on 8/28/16.
//  Copyright © 2016 Faisal Syed. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class CreatePerson: UIViewController, UITextFieldDelegate
{
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
    
    lazy var createButton: UIButton =
    {
        let button = UIButton(type: .System)
        button.setTitle("Create", forState: .Normal)
        button.addTarget(self, action: #selector(handleCreatePerson), forControlEvents: .TouchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
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
        
        createButton.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        createButton.topAnchor.constraintEqualToAnchor(zipcodeField.bottomAnchor).active = true
        createButton.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        createButton.heightAnchor.constraintEqualToConstant(60).active = true
    }
    
    func handleCreatePerson()
    {
        guard let firstname = firstNameField.text, lastname = lastNameField.text, dateOfBirth = dateOfBirthField.text, zipcode = Int(zipcodeField.text!) else
        {
            print("Form not valid")
            return
        }
        
        
        let properties: [String: AnyObject] = ["firstname": firstname, "lastname": lastname, "Date of Birth": dateOfBirth, "Zipcode": zipcode]
        updateFirebaseWithProperties(properties)
        self.view.endEditing(true)
    }
    
    func updateFirebaseWithProperties(properties: [String:AnyObject])
    {
        let ref = FIRDatabase.database().reference().child("Users")
        let childRef = ref.childByAutoId()
        childRef.updateChildValues(properties) { (error, ref) in
            
            if error != nil
            {
                print("There was an error uploading the data \(error)")
                return
            }
            
            print("We were able to store the data into Firebase with the reference \(ref)")
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        view.addSubview(zipcodeField)
        view.addSubview(dateOfBirthField)
        view.addSubview(lastNameField)
        view.addSubview(firstNameField)
        view.addSubview(createButton)
        
        setUpUI()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyBoard()
    {
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
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

extension UITextField
{
    func addBorderLayer()
    {
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor.darkGrayColor().CGColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        
        border.borderWidth = width
        
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}
