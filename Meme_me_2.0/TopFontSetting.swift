//
//  TopFontSetting.swift
//  Meme_me_1.0
//
//  Created by Hareth Naji on 01/06/2016.
//  Copyright © 2016 Hazzaldo. All rights reserved.
//

import UIKit

class TopFontSetting: UITableViewController {
    
    // MARK: Class properties
    var cellIdentifier = "cell"
    var defaultUser = UserDefaults.standard
    let selectedFont = "topTextfieldFontType"
    var currentCheckedCell : UITableViewCell!
    
    
    // MARK: Class methods
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        defaultUser.synchronize()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set the tableview datasource and delegate
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    //Datasrouce:
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as UITableViewCell
        
        // Configure Cell
        cell.textLabel?.text = "\(UIFont.fontNames(forFamilyName: UIFont.familyNames[indexPath.section])[indexPath.row])"
        cell.textLabel?.font = UIFont(name: UIFont.fontNames(forFamilyName: UIFont.familyNames[indexPath.section])[indexPath.row], size: 14)
        
        
        //checking if the default user key value selectedFont is equal to nil then do nothing, otherwise if cell string value is equal to user default selectFont key value then check cell, otherwise don't check cell.
        if (defaultUser.string(forKey: "topTextfieldFontType")) == nil{
            print ("Do nothing as user default selected font value is nil")
        } else if cell.textLabel?.text == defaultUser.string(forKey: "topTextfieldFontType") {
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
            currentCheckedCell = cell
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.none
        }
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return UIFont.familyNames.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UIFont.fontNames(forFamilyName: UIFont.familyNames[section]).count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(UIFont.familyNames[section])"
    }
    
    
    //The Delegate:
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath as IndexPath)
        currentCheckedCell?.accessoryType = UITableViewCellAccessoryType.none
        //check selected cell
        cell?.accessoryType = UITableViewCellAccessoryType.checkmark
        //assign the selected font to default user key selectedFont
        defaultUser.setValue("\(UIFont.fontNames(forFamilyName: UIFont.familyNames[indexPath.section])[indexPath.row])", forKey: "topTextfieldFontType")
        defaultUser.synchronize()
        //change currentChecked Cell to the current selected cell
        currentCheckedCell = cell
    }
}
