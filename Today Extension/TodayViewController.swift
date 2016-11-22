//
//  TodayViewController.swift
//  Today Extension
//
//  Created by Hijazi on 21/11/16.
//  Copyright © 2016 iReka Soft. All rights reserved.
//

import UIKit
import NotificationCenter
import RealmSwift

class TodayViewController: UIViewController, UITableViewDataSource, NCWidgetProviding {
  
  var realm : Realm!
  var todoList: Results<TodoItem> {
    get {
      return realm.objects(TodoItem.self)
    }
  }

  
  
  // MARK: - UITableViewDataSource
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return todoList.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    
    let item = todoList[indexPath.row]
    
    cell.textLabel!.text = item.detail
    cell.detailTextLabel!.text = "\(item.status)"
    
    return cell
    
  }

  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let directory: URL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: K_GROUP_ID)!
    
    let fileURL = directory.appendingPathComponent(K_DB_NAME)
    realm = try! Realm(fileURL: fileURL)
    
    print("todoList.count \(todoList.count)")
    
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {

    
    completionHandler(NCUpdateResult.newData)
  }
  
}
