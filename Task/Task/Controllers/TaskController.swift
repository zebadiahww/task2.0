//
//  TaskController.swift
//  Task
//
//  Created by Zebadiah Watson on 9/25/19.
//  Copyright © 2019 Zebadiah Watson. All rights reserved.
//

import Foundation
import CoreData

class TaskController {
    // Singleton
    static let shared = TaskController()
    
    
 // NSFetch results controller
    var fetchresultsController: NSFetchedResultsController<Task>
    
    
    init() {
        //creates fetch request
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        // add the sort descriptors to the request. Sort Descriptors allow us to determine how we want the data organized from the fetch request
        request.sortDescriptors = [NSSortDescriptor(key: "isComplete", ascending: true)]
        // Initialize an NSFetchedResultsCOntroller using the Fetch Request we just created
        //fetch request is named above, MOC is CoreDataStack
        let resultsController: NSFetchedResultsController<Task> = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: "complete", cacheName: nil)
        // Set the initialized NSFetchRequestController to our property
        // use the name of your fetch controller  = your results controller
        fetchresultsController = resultsController
        //do try catch
        do{
           try fetchresultsController.performFetch()
            
        } catch {
            print("there was an error peforming the fetch. \(error.localizedDescription)")
        }
    }
        
    
    
    
    //Create
    func createTask(name: String, notes: String, due: Date) {
        _ = Task(name: name, notes: notes, due: due)
        saveToPersistentStore()
        
    }
    
    
    //Delete
    func deleteTask(task: Task) {
        CoreDataStack.context.delete(task)
        saveToPersistentStore()
        
        
    }
    
    //Update
    func updateTask(task: Task, name: String, notes: String, due: Date) {
        task.name = name
        task.notes = notes
        task.due = due
        
        
    }
    
    //Save
    func saveToPersistentStore() {
        // DO, TRY, CATCH
        do {
            try CoreDataStack.context.save()
        } catch {
            print("There was an error saving the Objects on \(#function): \(error.localizedDescription)")
        }
        
    }
    
    //is complete toggle
    func toggleIsComplete(task: Task) {
        task.isComplete = !task.isComplete
        saveToPersistentStore()
        
    }
    
} //End Of Class
