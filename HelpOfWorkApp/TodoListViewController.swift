//
//  TodoListViewController.swift
//  HelpOfWorkApp
//
//  Created by 松本唯尊 on 2019/05/31.
//  Copyright © 2019 松本唯尊. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController{

  private var realm : Realm!
  private var todoLists : Results<TodoList>!
  private var list:[String] = []
  private var privateToken: NotificationToken!
  
  @IBOutlet weak var todoList: UITableView!
  
  override func viewDidLoad() {
        super.viewDidLoad()

      todoList.delegate = self
      todoList.dataSource = self
      let realm  = try! Realm()
    
      var todoLists = realm.objects(TodoList.self)
        // Do any additional setup after loading the view.
    }
    
  override func awakeFromNib() {
    super.awakeFromNib()
    realm = try! Realm()
    todoLists = realm.objects(TodoList.self)
    privateToken = todoLists.observe{
      [weak self] _ in
      self?.reload()
    }
  }
  
  func reload(){
    todoList.reloadData()
  }
  
  func addTodoItem(title :String){
    try! realm.write{
      realm.add(TodoList(value: ["title":title]))
    }
  }

  func deleteTodoItem(at index : Int){
    try! realm.write{
      realm.delete(todoLists[index])
    }
  }
  
  @IBAction func addButton(_ sender: Any) {
        let alertController = UIAlertController(title:"ToDo追加",message:"ToDoを入力してください",preferredStyle:UIAlertController.Style.alert)
    
    //テキストエリアを追加
    alertController.addTextField(configurationHandler: nil)
    //OKボタンを追加
    let okAction = UIAlertAction(title:"OK", style:UIAlertAction.Style.default){
      (action:UIAlertAction) in
      //OKボタンがタップされた時の処理
      if let textField = alertController.textFields?.first{
        //ToDoの配列に入力値を挿入。先頭に挿入する
        let myTodo = TodoList()
        myTodo.title = textField.text!
        self.addTodoItem(title: myTodo.title)
        //テーブルに行が追加されたことをテーブルに通知
        self.todoList.insertRows(at: [IndexPath(row:0,section:0)], with: UITableView.RowAnimation.right)
      }
    }
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.todoLists.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    // TodoModelクラス型の変数を宣言
    let todoListsCell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath)
    
    // 取得したTodoリストからn番目を変数に代入
    let todo: TodoList = self.todoLists[(indexPath as NSIndexPath).row];
    
    // 取得した情報をセルに反映
    todoListsCell.textLabel?.text = todo.title
    
    return todoListsCell
  }

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    // ここから追加
    let config = Realm.Configuration(
      schemaVersion: 1,
      migrationBlock: { migration, oldSchemaVersion in
        if (oldSchemaVersion < 1) {}
    })
    Realm.Configuration.defaultConfiguration = config
    // ここまで
    
    return true
  }
  
}
