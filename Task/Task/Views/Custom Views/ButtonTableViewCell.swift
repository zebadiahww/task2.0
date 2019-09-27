//
//  ButtonTableViewCell.swift
//  Task
//
//  Created by Zebadiah Watson on 9/26/19.
//  Copyright © 2019 Zebadiah Watson. All rights reserved.
//

import UIKit

protocol ButtonTableViewCellDelegate {
    func cellButtonTapped(_ sender: ButtonTableViewCell)
}
class ButtonTableViewCell: UITableViewCell {
    
    var delegate: ButtonTableViewCellDelegate?
    
    
    
    //Private
    func updateButton(_ isComplete: Bool) {
        let imageName = isComplete ? "complete" : "incomplete"
        completeButton.setImage(UIImage(named: imageName), for: .normal)
    }
    
    //update
    
    func updateWith(task: Task) {
        primaryLabel.text = task.name
        dueDateLabel.text = task.due?.stringValue()
        updateButton(task.isComplete)
        
        
    }
    //Outlets
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var primaryLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    
    //Actions
    
    @IBAction func buttonTapped(_ sender: Any) {
        delegate?.cellButtonTapped(self) 
        
    }
}
