//
//  ToDoListViewController.swift
//  ToDoListCoreData
//
//  Created by Станислав Лемешаев on 03.03.2021.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    // MARK: - Properties
    
    var tasks: [String] = []
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // - MARK: Actions
    
    @IBAction func saveTask(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "New Task",
                                                message: "Please add a new task",
                                                preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { action in
            let textField = alertController.textFields?.first
            if let newTask = textField?.text {
                self.tasks.insert(newTask, at: 0)
                self.tableView.reloadData()
            }
        }
        alertController.addTextField { _ in }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { _ in }
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }

}

// MARK: - Table view data source

extension ToDoListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = tasks[indexPath.row]
        return cell
    }

}
