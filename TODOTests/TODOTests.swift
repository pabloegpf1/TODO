//
//  TODOTests.swift
//  TODOTests
//
//  Created by Pablo Escriva on 30/04/2019.
//  Copyright © 2019 Pablo Escriva. All rights reserved.
//

import XCTest
@testable import TODO

class TODOTests: XCTestCase {
    
    var testClass = TableViewController()
    

    override func setUp() {
        self.testClass = TableViewController()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAddNewTask() {
        let initialTaskCount = testClass.getCurrentTaskList().count
        
        let newTask = Task(title: "Hello World")
        testClass.addTaskToList(task:newTask)
        let finalTaskCount = testClass.getCurrentTaskList().count
        
        XCTAssert(initialTaskCount == (finalTaskCount-1), "Initial: \(initialTaskCount) Final: \(finalTaskCount)")
    }
    
    func testChangeTaskStatus() {
        let newTask = Task(title: "Hello World")
        testClass.addTaskToList(task:newTask)
        let initialTaskStatus = testClass.getCurrentTaskList().last?.done
        
        testClass.getCurrentTaskList().first?.done = true
        let finalTaskStatus = testClass.getCurrentTaskList().last?.done

        // Check that task is not done by default
        XCTAssert(initialTaskStatus == false)
        
        // Check that task has changed state to "done" correctly
        XCTAssert(finalTaskStatus == true)

    }
    
    func testDataSource(){
        
        let doneTask = Task(title: "Done")
        doneTask.done = true
        let todoTask1 = Task(title: "Todo1")
        let todoTask2 = Task(title: "Todo2")
        
        // Add one "done" task and 2 "todo" tasks
        testClass.addTaskToList(task: doneTask)
        testClass.addTaskToList(task: todoTask1)
        testClass.addTaskToList(task: todoTask2)
        print(testClass.displayView)
        
        // Checked number of tasks shown when view type is changed
        testClass.displayView = .all // Changed to "All" view
        XCTAssert(testClass.getCurrentTaskList().count == 3)
        
        testClass.displayView = .todo // Changed to "To do" view
        XCTAssert(testClass.getCurrentTaskList().count == 2)
        
        testClass.displayView = .done // Changed to "Done" view
        XCTAssert(testClass.getCurrentTaskList().count == 1)
    }
    
    func testSaveToUserDefaults(){
        
        // Insert one task to the task list
        let newTask = Task(title: "Example")
        testClass.addTaskToList(task: newTask)
        
        // Save to User Defaults
        testClass.saveState()
        // Empty the task list
        testClass.removeAllTasks()
        // Load from User Defaults
        testClass.loadState()
        
        // Check that 1 task was loaded from User Defaults
        XCTAssert(testClass.getCurrentTaskList().count == 1)
    }

}
