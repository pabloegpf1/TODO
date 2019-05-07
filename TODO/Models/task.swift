//
//  task.swift
//  TODO
//
//  Created by Pablo Escriva on 06/05/2019.
//  Copyright © 2019 Pablo Escriva. All rights reserved.
//

import Foundation

class task{
    var title: String
    var done: Bool
    
    public init(title: String, done:Bool){
        self.title = title
        self.done = done
    }
}

extension task{
    
    public class func getDummyTasks() -> [task]{
        return [
            task(title: "Milk",done: false),
            task(title: "Chocolate",done: false),
            task(title: "Light bulb",done: false),
            task(title: "Dog food",done: false),
            task(title: "Hello World",done: false),
            task(title: "Rent",done: false),
        ]
    }
}
