//
//  task.swift
//  TODO
//
//  Created by Pablo Escriva on 06/05/2019.
//  Copyright © 2019 Pablo Escriva. All rights reserved.
//

import Foundation

class Task: Codable{
    var title: String
    var done: Bool
    
    public init(title: String){
        self.title = title
        self.done = false
    }
}

extension Task{
    
    public static func saveTaskList(taskList: [Task]){
        let taskData = try! JSONEncoder().encode(taskList)
        UserDefaults.standard.set(taskData, forKey: "tasks")
    }
    
    public static func loadTaskList() -> [Task]?{
        let taskData = UserDefaults.standard.data(forKey: "tasks")
        var taskList = [Task]()
        if(taskData != nil){
            taskList = try! JSONDecoder().decode([Task].self, from: taskData!)
        }else{
            //If no user defaults for "tasks" are found, load default values
            var dummyList = [Task]()
            let task1 = Task(title: "Download my app")
            let task2 = Task(title: "Delete previous task")
            let task3 = Task(title: "Create new task")
            let task4 = Task(title: "Mark a task as completed")
            let task5 = Task(title: "Enjoy!")
            task1.done = true
            dummyList.append(task1)
            dummyList.append(task2)
            dummyList.append(task3)
            dummyList.append(task4)
            dummyList.append(task5)
            taskList = dummyList
        }
        return taskList
    }
    
}
