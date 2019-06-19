//
//  ToDoController.swift
//  HelpOfWorkApp
//
//  Created by 松本唯尊 on 2019/05/30.
//  Copyright © 2019 松本唯尊. All rights reserved.
//

import UIKit
import FSCalendar
import CalculateCalendarLogic
import RealmSwift

class ToDoController: UIViewController,UITableViewDataSource,UITableViewDelegate {

  @IBOutlet weak var calendar: FSCalendar!
  
  private var realm : Realm!
  private var todoLists : Results<TodoList>!
  private var list:[TodoList] = []
  private var privateToken: NotificationToken!
  private let formatter = DateFormatter()
  
  @IBOutlet weak var todoList: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    todoList.delegate = self
    todoList.dataSource = self
    let config = Realm.Configuration(schemaVersion: 2)
    let realm  = try! Realm(configuration: config)
    print(Realm.Configuration.defaultConfiguration.fileURL!)
    
    todoLists = realm.objects(TodoList.self)
    // Do any additional setup after loading the view.
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    let config = Realm.Configuration(schemaVersion: 2)
    let realm  = try! Realm(configuration: config)
    todoLists = realm.objects(TodoList.self)
    privateToken = todoLists.observe{
      [weak self] _ in
      //      self?.reload()
    }
  }
  
  //  func reload(){
  //    if(todoList == nil){
  //      todoList.reloadData()
  //    }
  //  }
  
  func addTodoItem(todo: TodoList){
    let config = Realm.Configuration(schemaVersion: 1)
    let realm  = try! Realm(configuration: config)
    try! realm.write{
      realm.add(todo)
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
        //登録日の日付を取得
        let now = Date()
        self.formatter.dateFormat = "yyyy/mm/dd"
        myTodo.addDay = self.formatter.string(from: now)
        //        self.list.insert(myTodo, at: 0)
        self.addTodoItem(todo: myTodo)
        //テーブルに行が追加されたことをテーブルに通知
        //        self.todoList.insertRows(at: [IndexPath(row:0,section:0)], with: UITableView.RowAnimation.right)
        self.todoList.reloadData()
      }
    }
    //OKボタンがタップされた時の処理
    alertController.addAction(okAction)
    //CANCELボタンがタップされた時の処理
    let cancelButton = UIAlertAction(title:"CANCEL",style: UIAlertAction.Style.cancel, handler:nil)
    //CANCELボタンを追加
    alertController.addAction(cancelButton)
    //アラートダイアログを表示
    present(alertController,animated: true,completion:  nil)
  }
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return todoLists.count
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    // TodoModelクラス型の変数を宣言
    let todoListsCell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath)
    // 取得したTodoリストからn番目を変数に代入
    let todo: TodoList = self.todoLists[(indexPath as NSIndexPath).row];
    // 取得した情報をセルに反映
    todoListsCell.textLabel?.text = todo.title
    return todoListsCell
  }
  
  
  //    func numberOfSections(in tableView: UITableView) -> Int {
  //        return 0
  //    }

}
