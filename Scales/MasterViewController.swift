//
//  MasterViewController.swift
//  Scales
//
//  Created by Jenny Swift on 17/12/18.
//  Copyright © 2018 Jenny Swift. All rights reserved.
//

import UIKit

struct Food {
    let name: String
    var amount: Int
}

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
//    var objects = [Any]()
//    var objects = [Food]()
    var objects: [Food] = [
        Food(name: "Potatoes", amount: 0),
        Food(name: "Sweet Potatoes", amount: 0),
        Food(name: "Corn", amount: 0),
        Food(name: "Bananas", amount: 0),
        Food(name: "Pumpkin", amount: 0),
        Food(name: "Mango", amount: 0),
        Food(name: "Watermelon", amount: 0)
    ]
    
    func reloadData() {
        self.tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = editButtonItem

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
        reloadData()
    }

    @objc
    func insertNewObject(_ sender: Any) {
        objects.insert(Food(name: "Oats", amount: 0), at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.delegate = self
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let object = objects[indexPath.row]
        cell.textLabel!.text = object.name
        cell.detailTextLabel!.text = String(object.amount)
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }

}

extension MasterViewController: DetailViewControllerDelegate {
    func didUpdateFood(_ food: Food) {
        if let indexPath = tableView.indexPathForSelectedRow {
            let index = indexPath[1]
            objects[index].amount += 1
        }
        
//        tableView.reloadData()
    }
}

