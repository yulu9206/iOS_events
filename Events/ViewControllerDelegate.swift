//
//  delegate.swift
//  Events
//
//  Created by Lu Yu on 7/21/17.
//  Copyright © 2017 Lu Yu. All rights reserved.
//


import Foundation

protocol ViewControllerDelegate: class {
    func itemSaved(by controller: ViewController, ttl:String, info:String, time:Date, at indexPath: NSIndexPath?)
    func cancelButtonPressed(by controller: ViewController)
}
