//
//  allEventsTableViewController.swift
//  Events
//
//  Created by Lu Yu on 7/22/17.
//  Copyright © 2017 Lu Yu. All rights reserved.
//

import UIKit
import CoreData

class allEventsTableViewController: UITableViewController, eventCellDelegate {
//    var ttl:String?
//    var info: String?
//    var evenTime: Date?
//    var cmp: Bool = false
    let sectionTitles = ["Incomplete", "Complete"]
    var incomEvents = [Event]()
    var cmpEvents = [Event]()
    var allEvents = [Event]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var event:Event?
        if indexPath.section == 0 {
            event = incomEvents[indexPath.row]
            event?.cmp = true
        }
        do {
            try context.save()
            print("\(String(describing: event)) completed")
        } catch {
            print("Error in completing \(String(describing: event))")
        }
        fetchAllEvents()
        diffEvents()
        tableView.reloadData()

    }
    
    func fetchAllEvents() {
        let fec:NSFetchRequest = Event.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "time", ascending: true)
        fec.sortDescriptors = [sortDescriptor]
        do {
            let results = try context.fetch(fec)
            allEvents = results 
            print("fetched", allEvents)
        } catch {
            print(error)
        }

    }
    func diffEvents() {
        cmpEvents = [Event]()
        incomEvents = [Event]()
        for event in allEvents {
            if event.cmp == false {
                incomEvents.append(event)
            } else {
                cmpEvents.append(event)
            }
        }
    }
    func editEvent(sender: eventCellVC){
        let indexPath = tableView.indexPath(for: sender)
        performSegue(withIdentifier: "editSegue", sender: indexPath)
//        print("perform run")
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewController = segue.destination as! ViewController
        if segue.identifier == "editSegue" {
            let indexPath = sender as! NSIndexPath
            if indexPath.section == 0 {
                viewController.theEvent = incomEvents[indexPath.row]
            } else {
                viewController.theEvent = cmpEvents[indexPath.row]
            }
            viewController.indexPath = indexPath
        }
    }

    
    @IBAction func saveSegue(_ segue: UIStoryboardSegue) {
        let controller = segue.source as! ViewController
        var theEvent: Event?
        if let indexPath = controller.indexPath {
            if indexPath.section == 0 {
                theEvent = incomEvents[indexPath.row]
            } else {
                theEvent = cmpEvents[indexPath.row]
            }
        } else {
            theEvent = NSEntityDescription.insertNewObject(forEntityName: "Event", into: context) as? Event
            theEvent?.cmp = false
        }
        do {
            theEvent?.setValue(controller.ttl.text, forKey: "ttl")
            theEvent?.setValue(controller.info.text, forKey: "info")
            theEvent?.setValue(controller.eventTime, forKey: "time")
//            theEvent?.setValue(false, forKey: "cmp")
//            print("Success, \(newEvent) added!")
            try context.save()
        } catch {
            print("Failure to save: \(error)")
        }
        fetchAllEvents()
        diffEvents()
        tableView.reloadData()
       print ("inside save unwind")
    }
//    func justBeastItViewController(_ controller: JustBeastItTableViewController, didFinishAddingBeast task: String, date: Date, beasted: Bool) {
//        dismiss(animated: true, completion: nil)
//        let newBeast = NSEntityDescription.insertNewObject(forEntityName: "Beast", into: context)
//        do {
//            newBeast.setValue(task, forKey: "task")
//            newBeast.setValue(date, forKey: "date")
//            newBeast.setValue(beasted, forKey: "beasted")
//            try context.save()
//            print("Success, \(newBeast) added!")
//            unBeastedBeasts.append(newBeast as! Beast)
//        } catch {
//            print("Failure to save: \(error)")
//        }
//        fetchUnBeastedBeasts()
//        tableView.reloadData()
//        
//    }
    @IBAction func cancelSegue(_ segue: UIStoryboardSegue) {
        print ("inside cancel unwind")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAllEvents()
        diffEvents()
//        tableView.reloadData()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return incomEvents.count
        } else {
            return cmpEvents.count
        }
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! eventCellVC
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        var data = [Event]()
        if indexPath.section == 0 {
            data = incomEvents
        } else {
            data = cmpEvents
        }
        let eventTime = formatter.string(from: data[indexPath.row].time! as Date)
        let cellText = eventTime + " " + data[indexPath.row].ttl!
        cell.textLabel?.text = cellText
        cell.cellDelegate = self
        cell.contentView.bringSubview(toFront: cell.editButton)
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        var deleteEvent: Event?
        if indexPath.section == 0 {
            deleteEvent = incomEvents.remove(at: indexPath.row)
        } else {
            deleteEvent = cmpEvents.remove(at: indexPath.row)
        }
        context.delete(deleteEvent!)
        do {
            try context.save()
            print("\(String(describing: deleteEvent)) deleted")
        } catch {
            print("Error in deleting \(String(describing: deleteEvent))")
        }
        tableView.deleteRows(at: [indexPath], with: .fade)
        fetchAllEvents()
        diffEvents()
        tableView.reloadData()
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }    
    }


    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
