//
//  TaskDetailTableViewController.swift
//  Task
//
//  Created by Zebadiah Watson on 9/25/19.
//  Copyright © 2019 Zebadiah Watson. All rights reserved.
//

import UIKit

class TaskDetailTableViewController: UITableViewController {
    
    var task: Task? {
        didSet {
            loadViewIfNeeded()
            updateViews()
        }
    }
    
    var dueDateValue: Date?
    
    private func updateViews() {
        guard let task = task else { return }
        
        taskNameField.text = task.name
        DateField.text =  task.due?.stringValue()
        noteTextField.text = task.notes
    }
    
    //Outlets
    @IBOutlet var datePicker: UIDatePicker!
    
    @IBOutlet weak var DateField: UITextField!
    @IBOutlet weak var taskNameField: UITextField!
    @IBOutlet weak var noteTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        DateField.inputView = datePicker
    }
    //Actions
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        guard let name = taskNameField.text, let notes = noteTextField.text, let due = dueDateValue else { return }
        
        if let task = task {
            // update
            TaskController.shared.updateTask(task: task, name: name, notes: notes, due: due)
        } else {
            // create
            TaskController.shared.createTask(name: name, notes: notes, due: due)
        }
        navigationController?.popViewController(animated: true)
        }
    
    @IBAction func datePickerSelected(_ sender: UIDatePicker) {
        DateField.text = sender.date.stringValue()
        self.dueDateValue = sender.date 
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        let _ = navigationController?.popViewController(animated: true)
        
    }
}
