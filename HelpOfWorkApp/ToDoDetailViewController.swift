//
//  ToDODetailViewController.swift
//  HelpOfWorkApp
//
//  Created by 松本唯尊 on 2019/06/23.
//  Copyright © 2019 松本唯尊. All rights reserved.
//

import UIKit
import TextFieldEffects
import RealmSwift

class ToDoDetailViewController: UIViewController,UITextFieldDelegate {

  @IBOutlet weak var titleTextField: AkiraTextField!
  
  @IBOutlet weak var addDayTextField: AkiraTextField!
  
  @IBOutlet weak var timeTextField: AkiraTextField!
  
  @IBOutlet weak var doneSwitch: UISwitch!
  
  //Realm用
    var tableLists:Results<todo>!
  
    //画面遷移時に渡される
    //table_List(テーブルに実際に表示する)
    var todoList_table = [todo]()
    //前画面から引き継いだtitle
    var todoTitle:String!
    //前画面から引き継いだDone
    var done:Bool?
    //前画面から引き継いだaddDay
    var addDay:Date?
    //当画面で登録する用のtime
    var time:Int!
    //選択したToDoの番号を保持
    var indexRow:Int! = nil
  
    override func viewDidLoad() {
        super.viewDidLoad()
      titleTextField.text = todoTitle
      
      let dateFormatter = DateFormatter()
      dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP") as Locale
      dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
      addDayTextField.text = dateFormatter.string(from: addDay!)
      
      doneSwitch.isOn = done!
      
      print(time)
      timeTextField.text = String(time)
      
      //Titleのテキストフィールドのプロパティ
      titleTextField.borderColor = UIColor.lightGray
      titleTextField.placeholderColor = UIColor.purple
      titleTextField.placeholderFontScale = 1.0
      
      //AddDayのテキストフィールドのプロパティ
      addDayTextField.borderColor = UIColor.lightGray
      addDayTextField.placeholderColor = UIColor.purple
      addDayTextField.placeholderFontScale = 1.0
      
      //Timeのテキストフィールドのプロパティ
      timeTextField.borderColor = UIColor.lightGray
      timeTextField.placeholderColor = UIColor.purple
      timeTextField.placeholderFontScale = 1.0
      
      titleTextField.delegate = self
      addDayTextField.delegate = self
      timeTextField.delegate = self
      
    }

  @IBAction func saveButtonAction(_ sender: Any) {
    let realm = try! Realm()
    
    try! realm.write() {
      todoList_table[indexRow!].setValue(titleTextField.text, forKeyPath: "title")
      let dateFormatter = DateFormatter()
      dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP") as Locale
      dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        addDay = dateFormatter.date(from: addDayTextField.text!)
        todoList_table[indexRow!].setValue(addDay, forKeyPath: "addDay")
      todoList_table[indexRow!].setValue(timeTextField.text, forKeyPath: "time")
      todoList_table[indexRow!].setValue(doneSwitch.isOn, forKeyPath: "done")
    }
    self.navigationController?.popViewController(animated: true)

//    self.performSegue(withIdentifier: "toToDoList", sender: nil)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    // キーボードを閉じる
    titleTextField.resignFirstResponder()
    addDayTextField.resignFirstResponder()
    timeTextField.resignFirstResponder()
    return true
  }
}
