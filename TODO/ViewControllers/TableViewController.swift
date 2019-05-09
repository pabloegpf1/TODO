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
    
    //All different "views"
    enum DisplayView {
        case all    // show done + todo tasks
        case todo   // show only todo tasks
        case done   // show only done tasks
    }
    
    private var taskList = [Task]()
    
    var displayView = DisplayView.all //Default "view" is "All"
    
    func getCurrentTaskList() -> [Task]{ //Filters the task list depending on the "view"
        switch displayView {
            case .all: return taskList
            case .todo: return taskList.filter({ (task) -> Bool in task.done == false })
            case .done: return taskList.filter({ (task) -> Bool in task.done == true })
        }
    }
    
    //Segmented control changes the "view"
    @IBAction func segmentedControlChange(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0: displayView = .all
        case 1: displayView = .todo
        case 2: displayView = .done
        default: displayView = .all
        }
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        loadState() //Load from user defaults
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int{
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return getCurrentTaskList().count
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
    
    //Mark Task as done / todo
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
            self.saveState()
        }
    }
    
    //Delete Task
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.taskList.remove(at: indexPath.row)
            self.saveState()
            self.tableView.deleteRows(at: [indexPath as IndexPath], with: .fade)
        }
    }
    
    //Move Task
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath){
        let rowToMove = taskList[sourceIndexPath.row]
        taskList.remove(at: sourceIndexPath.row)
        taskList.insert(rowToMove, at: destinationIndexPath.row)
        self.saveState()
    }
    
    //Add Task
    @IBAction func addNewTask(_ sender: Any) {
        let alert = UIAlertController(title: "New Task", message: "Enter the title", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = ""
        }
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak alert] (_) in
            let newTask = Task(title: alert!.textFields![0].text!)
            self.taskList.append(newTask)
            self.saveState()
            self.tableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    //Save current list to user defaults
    func saveState(){
        Task.saveTaskList(taskList: self.taskList)
    }
    
    //Load list from user defaults
    func loadState(){
        self.taskList = Task.loadTaskList()!
    }
    
}
