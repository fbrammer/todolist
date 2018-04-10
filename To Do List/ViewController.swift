//
//  ViewController.swift
//  To Do List
//
//  Created by Frank Brammer on 4/9/18.
//  Copyright © 2018 BrammerIS. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    @IBOutlet weak var textField: NSTextField!
    @IBOutlet weak var importantCheckbox: NSButton!
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var deleteButton: NSButton!

    var toDoItems : [ToDoItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        getToDoItems()
    }

    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    func getToDoItems() {
        // Get the todoItems from coredata
        if let context = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            do {
                toDoItems = try context.fetch(ToDoItem.fetchRequest())
            } catch {}
        }

        // set them to the class property
        
        // Update the table
        tableView.reloadData()
    }
    
    @IBAction func addButton(_ sender: Any) {
        
        if textField.stringValue != "" {
            if let context = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                
                let toDoItem = ToDoItem(context: context)
                
                toDoItem.name = textField.stringValue
                if importantCheckbox.state.rawValue == 0 {
                    // Not Important
                    toDoItem.important = false
                } else {
                    // Important
                    toDoItem.important = true
                }
                
                (NSApplication.shared.delegate as? AppDelegate)?.saveAction(nil)
                
                textField.stringValue = ""
                importantCheckbox.state = .off
                
                getToDoItems()
            }
        }
    }
    

    @IBAction func deleteClicked(_ sender: Any) {
       if let context = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
        context.delete(toDoItems[tableView.selectedRow])
        (NSApplication.shared.delegate as? AppDelegate)?.saveAction(nil)
        getToDoItems()
        deleteButton.isHidden = true
        }
    }
    
    // MARK: - TableView Stuff
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return toDoItems.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let toDoItem = toDoItems[row]

        if (tableColumn?.identifier)!.rawValue == "importantColumn" {
            // Important Cell
            if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "importantCell"), owner: self) as? NSTableCellView {
                if toDoItem.important {
                    cell.textField?.stringValue = "  ❗️"
                } else {
                    cell.textField?.stringValue = ""
                }
                
                return cell
            }
        } else {
            // To Do Cell
            if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "todoCell"), owner: self) as? NSTableCellView {
                
                cell.textField?.stringValue = toDoItem.name!
                return cell
            }
        }
        
        return nil
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        deleteButton.isHidden = false
    }
    
}

