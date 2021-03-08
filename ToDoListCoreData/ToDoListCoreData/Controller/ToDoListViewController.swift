//
//  ToDoListViewController.swift
//  ToDoListCoreData
//
//  Created by Станислав Лемешаев on 03.03.2021.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    // MARK: - Properties
    
    var tasks: [Task] = []
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchTask()
    }
    
    // - MARK: Actions
    
    @IBAction func saveTask(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "New Task",
                                                message: "Please add a new task",
                                                preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { action in
            let textField = alertController.textFields?.first
            if let newTaskTitle = textField?.text {
                self.saveTask(withTitle: newTaskTitle)
                self.tableView.reloadData()
            }
        }
        alertController.addTextField { _ in }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { _ in }
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func removeAllTasks(_ sender: UIBarButtonItem) {
        removeAllTasks()
    }
    
    
    // MARK: - Helpers
    
    private func saveTask(withTitle title: String) {
        let context = getContext()
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Task", in: context) else {
            return print("Error get entity")
        }
        
        let taskObject = Task(entity: entity, insertInto: context)
        taskObject.title = title
        
        // save context
        do {
            try context.save()
            tasks.insert(taskObject, at: 0)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    private func fetchTask() {
        let context = getContext()
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        // change the order of output of tasks
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // fetch context
        do {
            tasks = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    private func removeAllTasks() {
        let context = getContext()
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        if let objects = try? context.fetch(fetchRequest) {
            for object in objects {
                context.delete(object)
            }
        }
        
        do {
            try context.save()
            self.tasks.removeAll()
            self.tableView.reloadData()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
    }
    
    private func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }

}

// MARK: - Table view data source

extension ToDoListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = tasks[indexPath.row].title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        let context = getContext()
        let task = tasks[indexPath.row]
        context.delete(task)
        
        do {
            try context.save()
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.reloadData()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }

}
