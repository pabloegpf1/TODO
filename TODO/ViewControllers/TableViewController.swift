//
//  TableViewController.swift
//  TODO
//
//  Created by Pablo Escriva on 06/05/2019.
//  Copyright © 2019 Pablo Escriva. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    private var taskList = task.getDummyTasks()
    
    enum DisplayView {
        case all
        case todo
        case done
    }
    
    var displayView = DisplayView.all
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func getCurrentTaskList() -> [task]{
        switch displayView {
        case .all:
            return taskList
        case .todo:
            return taskList.filter({ (task) -> Bool in
                task.done == false
            })
        case .done:
            return taskList.filter({ (task) -> Bool in
                task.done == true
            })
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int{
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return getCurrentTaskList().count
    }
    
    @IBAction func segmentedControlChange(_ sender: Any) {
        if(segmentedControl.selectedSegmentIndex == 0){ //TODO
            displayView = .all
        }else if(segmentedControl.selectedSegmentIndex == 1){
            displayView = .todo
        }else if(segmentedControl.selectedSegmentIndex == 2){
            displayView = .done
        }
        tableView.reloadData()
    }
    
    @IBAction func editMode(_ sender: Any) {
        self.tableView.setEditing(self.tableView.isEditing, animated: true)
        self.editButton.title = self.tableView.isEditing ? "Done" : "Edit"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "task_cell", for: indexPath)
        
        if indexPath.row < getCurrentTaskList().count{
            let item = getCurrentTaskList()[indexPath.row]
            cell.textLabel?.text = getCurrentTaskList()[indexPath.row].title
            let accessory: UITableViewCell.AccessoryType = item.done ? .checkmark : .none
            cell.accessoryType = accessory
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        tableView.deselectRow(at: indexPath, animated: true)

        if indexPath.row < getCurrentTaskList().count{
            let item = getCurrentTaskList()[indexPath.row]

            item.done = !item.done
            
            if(displayView == .all){
                self.tableView.reloadData()
            }else{
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            }

        }

    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.taskList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath as IndexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath){
        let rowToMove = taskList[sourceIndexPath.row]
        taskList.remove(at: sourceIndexPath.row)
        taskList.insert(rowToMove, at: destinationIndexPath.row)
    }
    
}