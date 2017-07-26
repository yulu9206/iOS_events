//
//  eventCellVC.swift
//  Events
//
//  Created by Lu Yu on 7/22/17.
//  Copyright © 2017 Lu Yu. All rights reserved.
//


import UIKit
class eventCellVC: UITableViewCell {
    weak var cellDelegate: eventCellDelegate?
    @IBOutlet weak var editButton: UIButton!
    @IBAction func editPressed(_ sender: Any) {
        cellDelegate?.editEvent(sender: self)
    }
    
}
