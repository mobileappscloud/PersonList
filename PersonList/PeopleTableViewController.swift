//
//  PeopleTableViewController.swift
//  PersonList
//
//  Created by Faisal Syed on 8/28/16.
//  Copyright © 2016 Faisal Syed. All rights reserved.
//

import UIKit
import Foundation

class PeopleTableViewController: UITableViewController
{
    let cellID = "Cell"
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
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
        return 5
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel?.text = "Sample Text"
        return cell 
    }
}
