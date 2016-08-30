//
//  PeopleTableViewController.swift
//  PersonList
//
//  Created by Faisal Syed on 8/28/16.
//  Copyright © 2016 Faisal Syed. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class PeopleTableViewController: UITableViewController
{
    let cellID = "Cell"
   
    var names = [String]()
    var namesDictionary = [String: Person]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        observePeople()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(animated: Bool)
    {
        tableView.reloadData()
        print(names)
    }
    
    func observePeople()
    {
        let ref = FIRDatabase.database().reference().child("Users")
        ref.observeEventType(.ChildAdded, withBlock:
        { (snapshot) in
            
            if let firstname = snapshot.value?.objectForKey("firstname"), lastname = snapshot.value?.objectForKey("lastname")
            {
                let fullname = "\(firstname) \(lastname)"
                self.names.append(fullname)
                self.tableView.reloadData()
            }
            
        }, withCancelBlock: nil)
        
        ref.observeEventType(.ChildRemoved, withBlock:
        { (snapshot) in
        
        if let firstname = snapshot.value?.objectForKey("firstname"), lastname = snapshot.value?.objectForKey("lastname"), dateOfBirth = snapshot.value?.objectForKey("Date of Birth"), zipcode = snapshot.value?.objectForKey("Zipcode")
        {
            print("We deleted the person \(firstname) \(lastname) with the details: \(dateOfBirth), \(zipcode)")
        }
            
        }, withCancelBlock: nil)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return names.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel?.text = names[indexPath.row]
        return cell 
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if editingStyle == .Delete
        {
            names.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
            //Delete from firebase            
        }
    }
}
