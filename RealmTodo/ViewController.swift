//
//  ViewController.swift
//  RealmTodo
//
//  Created by Hijazi on 9/11/16.
//  Copyright © 2016 iReka Soft. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  @IBOutlet weak var tableView: UITableView!
  
  var realm : Realm!
  
  
  var todoList: Results<TodoItem> {
    get {
      return realm.objects(TodoItem.self)
    }
  }
  
  
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    let directory: URL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: K_GROUP_ID)!

    let fileURL = directory.appendingPathComponent(K_DB_NAME)

    realm = try! Realm(fileURL: fileURL)
    
    print("file url \(realm.configuration.fileURL)")
    
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: UITableViewDataSource
  // [2]
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    
    let item = todoList[indexPath.row]
    
    cell.textLabel!.text = item.detail
    cell.detailTextLabel!.text = "\(item.status)"
    
    return cell
  }
  
  // [3]
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  // [4]
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return todoList.count
  }

  @IBAction func addNew(_ sender: Any) {
    
    let alertController : UIAlertController = UIAlertController(title: "New Todo", message: "What do you plan to do?", preferredStyle: .alert)
    
    alertController.addTextField { (UITextField) in
      
    }
    
    let action_cancel = UIAlertAction.init(title: "Cancel", style: .cancel) { (UIAlertAction) -> Void in
      
    }
    alertController.addAction(action_cancel)
    
    let action_add = UIAlertAction.init(title: "Add", style: .default) { (UIAlertAction) -> Void in
      
      let textField_todo = (alertController.textFields?.first)! as UITextField
      
      print("You entered \(textField_todo.text)")
      
      let todoItem = TodoItem() // [1]
      todoItem.detail = textField_todo.text!
      todoItem.status = 0
      
      try! self.realm.write({ // [2]
        self.realm.add(todoItem)

        self.tableView.insertRows(at: [IndexPath.init(row: self.todoList.count-1, section: 0)], with: .automatic)
      })
      
    }
    
    alertController.addAction(action_add)
    
    present(alertController, animated: true, completion: nil)
    
  }

  // MARK: UITableViewDelegate
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let item = todoList[indexPath.row]
    try! self.realm.write({
      if (item.status == 0){
        item.status = 1
      }else{
        item.status = 0
      }
    })
    tableView.reloadRows(at: [indexPath], with: .automatic)

  }
  // [1]
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  // [2]
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    
    if (editingStyle == .delete){
      let item = todoList[indexPath.row]
      try! self.realm.write({
        self.realm.delete(item)
      })
      
      tableView.deleteRows(at:[indexPath], with: .automatic)
      
    }
    
  }

}

