//
//  TodoList_Calendar.swift
//  HelpOfWorkApp
//
//  Created by 松本唯尊 on 2019/06/11.
//  Copyright © 2019 松本唯尊. All rights reserved.
//

import UIKit
import FSCalendar
import CalculateCalendarLogic
import RealmSwift

class TodoList_Calendar: UIViewController,FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance,UITableViewDelegate,UITableViewDataSource {

  @IBOutlet weak var todoCalendar: FSCalendar!

  //CalculateCalendarLogicインスタンス生成
  let holiday = CalculateCalendarLogic()
  
  //ToDoプロパティの宣言
  var todoList:Results<todo>!
  
  //ToDoTable用配列
  var todoList_table = [todo]()
  
  //tableViewの宣言
  @IBOutlet weak var todoLists: UITableView!
  
  //今日日付を取得
  let today = Date()
  
  override func viewDidLoad() {
        super.viewDidLoad()

        //FSCalendarのデリゲート定義
      self.todoCalendar.delegate = self
      self.todoCalendar.dataSource = self
    
      //TableViewのデリゲート定義
      self.todoLists.delegate = self
      self.todoLists.dataSource = self
    
      //今日の日付を取得
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy-MM-dd"
    
      let now = formatter.string(from: self.today)
      let split:[String] = now.components(separatedBy: "-")
    
      //splitを使って当日の日付を"-"で区切る
      let year:Int = Int(split[0])!
      let month:Int = Int(split[1])!
      let day:Int = Int(split[2])!
    
      let calendar = Calendar.current
      let selectDate = calendar.date(from: DateComponents(year:year,month: month, day: day))
      todoCalendar.select(selectDate)
          // Do any additional setup after loading the view.
      //RealmDBからの値の取得
      let realm = try! Realm()
      //todoを取得する
    todoList = realm.objects(todo.self)
    
    print(now)
    let yesterday = Date(timeIntervalSinceNow: -60 * 60 * 24)

    let result = todoList.filter( "addDay >=%@ AND addDay <= %@", yesterday,today)
//      self.todoList_table = Array(todoList)
      self.todoList_table = Array(result)
    
      print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
  
  //日付を取得する
  func getDay(_ date:Date)->(Int,Int,Int){
    let tmpCalendar = Calendar(identifier: .gregorian)
    let year = tmpCalendar.component(.year, from: date)
    let month = tmpCalendar.component(.month, from: date)
    let day = tmpCalendar.component(.day, from: date)
    return (year,month,day)
  }
  
  //祝日判定する(日曜日:1 〜 土曜日:7)
  func judgeHoliday(_ date:Date)->Bool{
    let tmpCalendar = Calendar(identifier: .gregorian)
    let year = tmpCalendar.component(.year, from: date)
    let month = tmpCalendar.component(.month, from: date)
    let day = tmpCalendar.component(.day, from: date)
    
    var judge = CalculateCalendarLogic()

    return judge.judgeJapaneseHoliday(year: year, month: month, day: day)
  }
  
  func weekIdx(_ date:Date)->Int{
    let tmpCalendar = Calendar(identifier: .gregorian)
    return tmpCalendar.component(.weekday, from: date)
  }
  
  //祝日・土日の場合、カレンダーの色を変更する(祝日⇨赤、土日⇨青)
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
      
      let selectedDay = getDay(date)
      //祝日を判定する
      if(judgeHoliday(date)){
        return UIColor.red
      }
      
      //土日を判定する
      let weekday = self.weekIdx(date)
      if(weekday == 7){
        return UIColor.blue
      }
      if(weekday == 1){
        return UIColor.red
      }
      
      return nil
    }
  
  //テーブルビューに表示するデータの行数を取得
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    print(todoList_table.count)
    return todoList_table.count
//    print(self.todoList.count)
//    return self.todoList.count
  }
  
  //テーブルビューに表示するCellを取得
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "todoListsCell") as! todoListsCell
    //UISwitchをcellのアクセサリービューに追加する
    let switchView = UISwitch()
//    let textField = UITextField()
    cell.accessoryView = switchView
//    cell.accessoryView = textField
    
    print(todoList_table[indexPath.row])
    print(indexPath.row)
  
    cell.title.text = todoList_table[indexPath.row].title
    cell.time.text = String(todoList_table[indexPath.row].time)
    switchView.tag = indexPath.row
    if(todoList_table[indexPath.row].done){
      switchView.isOn = true
    }else{
      switchView.isOn = false
    }
    //スイッチが押されたときの動作
    switchView.addTarget(self, action: #selector(switchChange(_:)), for: UIControl.Event.valueChanged)
    
    return cell
  }
  
  //+ボタンをタップした時の処理
  @IBAction func addButtonTap(_ sender: Any) {
    //アラートダイアログを生成する
    let alertController = UIAlertController(title: "ToDo追加", message: "ToDoを追加してください", preferredStyle: UIAlertController.Style.alert)
    
    //テキストエリアに追加
    alertController.addTextField(configurationHandler: nil)
    //OKボタンを追加
    let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default){(action:UIAlertAction) in
        //OKボタンがタップされた時の処理
      if let textField = alertController.textFields?.first{
        let new_todo = todo()
        new_todo.title = textField.text!
        new_todo.addDay = self.today
        //ToDoの配列に入力値を挿入。先頭に挿入する
        self.todoList_table.append(new_todo)
        let realm = try! Realm()
        
        try! realm.write(){
          realm.add(new_todo)
        }
        
//        //todoを再度取得する(取得しなければ削除後の追加で前のセルが復活してしまう。)
//        self.todoList = realm.objects(todo.self)
//        self.todoList_table = Array(self.todoList)
        //なぜ-1するのか要確認！！おまじないになってしまっている
        //2019年6月17日
        self.todoLists.insertRows(at: [IndexPath(row: self.todoList_table.count-1, section: 0)], with: UITableView.RowAnimation.right)
      }
    }
    
    //OKボタンがタップされた時の処理
    alertController.addAction(okAction)
    //CANCELLボタンを追加
    let cancelAction = UIAlertAction(title: "CANCEL", style: UIAlertAction.Style.cancel,handler: nil)
    //CANCELボタンがタップされた時の処理
    alertController.addAction(cancelAction)
    //アラートダイアログを表示
    present(alertController, animated: true, completion: nil)
  }
  //tableViewのセル削除
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == UITableViewCell.EditingStyle.delete{
      
      let deleteTableView:todo = todoList_table[indexPath.row]
      todoList_table.remove(at: indexPath.row)
      let realm = try! Realm()
      
      try! realm.write{
        realm.delete(deleteTableView)
      }
      
      tableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
    }
  }
  
  //cellのswitchを変更(todoList_tableでTableViewを表示しているため、todoListの更新ではなく、todoList_tableでオブジェクトを指定して更新する)
  @IBAction func switchChange(_ sender: UISwitch) {
    print(sender.tag)
    print(sender.isOn)
    
    let realm = try! Realm()
    try! realm.write {
      if(sender.isOn){
//        self.todoList[sender.tag].done = true
          todoList_table[sender.tag].setValue(true, forKey: "done")
      }else{
//        self.todoList[sender.tag].done = false
          todoList_table[sender.tag].setValue(false, forKey: "done")
      }

      print(self.todoList[sender.tag].done)
//      todoList[sender.tag].setValue(self.todoList[sender.tag].done, forKey: "done")
    }
  }
  
  //日付タップ時のイベント
  func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
    //取得するdateは1日前を指している
    let oneDayAfter = date + 60 * 60 * 24
    print(oneDayAfter)
    print(date)
    let result = todoList.filter( "addDay >=%@ AND addDay <= %@", date,oneDayAfter)
    //      self.todoList_table = Array(todoList)
    self.todoList_table = Array(result)
    print(todoList)
    print(todoList_table)
    todoLists.reloadData()
  }
  
  
}
