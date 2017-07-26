//
//  ViewController.swift
//  Events
//
//  Created by Lu Yu on 7/21/17.
//  Copyright © 2017 Lu Yu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var theEvent: Event?
    var indexPath: NSIndexPath?
    var eventTime = Date()

    @IBOutlet weak var ttl: UITextField!
    @IBOutlet weak var info: UITextField!
    @IBOutlet weak var time: UIDatePicker!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var Button: UIButton!
    
    func populateEvent() {
        if let event = theEvent {
            ttl.text = event.ttl
            info.text = event.info
            time.date = (event.time!) as Date
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        populateEvent()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func timeChange(_ sender: UIDatePicker) {
        eventTime = sender.date
//        print (eventTime)
        
    }
//    @IBAction func cancelPressed(_ sender: Any) {
//        print("cancel pressed")
//        delegate?.cancelButtonPressed(by: self)
//    }
//    @IBAction func savePressed(_ sender: Any) {
//        let ttl = self.ttl.text!
//        let info = self.info.text!
//        let time = eventTime
//        delegate?.itemSaved(by: self, ttl:ttl, info: info, time: time, at: indexPath)
//    }


}

