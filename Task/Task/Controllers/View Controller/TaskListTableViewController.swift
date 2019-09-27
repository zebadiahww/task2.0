//
//  TaskListTableViewController.swift
//  Task
//
//  Created by Zebadiah Watson on 9/25/19.
//  Copyright © 2019 Zebadiah Watson. All rights reserved.
//

import UIKit
import CoreData

class TaskListTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TaskController.shared.fetchresultsController.delegate = self
        
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return TaskController.shared.fetchresultsController.sectionIndexTitles[section] == "1" ? "complete" : "incomplete"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return TaskController.shared.fetchresultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return TaskController.shared.fetchresultsController.sections?[section].numberOfObjects ?? 0
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as? ButtonTableViewCell else { return UITableViewCell() }
        cell.delegate = self
        
        
        let task = TaskController.shared.fetchresultsController.object(at: indexPath)
        cell.updateWith(task: task)
        
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let taskIndex = TaskController.shared.fetchresultsController.object(at: indexPath)
            TaskController.shared.deleteTask(task: taskIndex)
        }
    }
    
    
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toTaskDetailVC" {
            guard let indexPathForTheCell = tableView.indexPathForSelectedRow,
                let destinationVC = segue.destination as? TaskDetailTableViewController else { return }
            let taskToSend = TaskController.shared.fetchresultsController.object(at: indexPathForTheCell)
            destinationVC.task = taskToSend
            destinationVC.dueDateValue = taskToSend.due 
        }
        
    }
    
    
}
// create extension that conforms the TaskListTableVC to the delegate
extension TaskListTableViewController: ButtonTableViewCellDelegate {
    //conform to the button delegate
    func cellButtonTapped(_ sender: ButtonTableViewCell) {
        //get the index path of the sender
        guard let indexPath = tableView.indexPath(for: sender) else { return }
        //use that index to pull out the Task that lives on that cell. access the controller, to access the shared instance to access the fetchresultsController to access the object that lives at this indexPath
        let task = TaskController.shared.fetchresultsController.object(at: indexPath)
        //use our model controller to handle the isComplete property update
        TaskController.shared.toggleIsComplete(task: task)
        //update the cell
        sender.updateButton(task.isComplete)
        
    }
    
}

extension TaskListTableViewController: NSFetchedResultsControllerDelegate {
    // Conform to the NSFetchedResultsControllerDelegate
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    //sets behavior for cells
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
            
        case .delete:
            guard let indexPath = indexPath else {return}
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        case .insert:
            guard let newIndexPath = newIndexPath else {return}
            tableView.insertRows(at: [newIndexPath], with: .automatic)
            
        case .move:
            guard let oldIndexPath = indexPath, let newIndexPath = newIndexPath else {return}
            tableView.moveRow(at: oldIndexPath, to: newIndexPath)
            
        case .update:
            guard let indexPath = indexPath else {return}
            tableView.reloadRows(at: [indexPath], with: .automatic)
        @unknown default:
            fatalError()
        }
    }
    
    //additional behavior for cells
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        case .move:
            break
        case .update:
            break
        @unknown default:
            fatalError()
        }
    }
}
