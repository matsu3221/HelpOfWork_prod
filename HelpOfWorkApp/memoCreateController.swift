//
//  memoCreateController.swift
//  HelpOfWorkApp
//
//  Created by 松本唯尊 on 2019/07/29.
//  Copyright © 2019 松本唯尊. All rights reserved.
//

import UIKit
import RealmSwift

class memoCreateController: UIViewController,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITextViewDelegate {
  
  @IBOutlet weak var titleTextField: UITextField!
  @IBOutlet weak var typeTextField: UITextField!
  @IBOutlet weak var memoTextView: UITextView!
  private var memoLists: Results<memo>!
  var date = Date()
  let formatter = DateFormatter()
  var pickerView: UIPickerView = UIPickerView()
  //前画面からのデータ選択時にデータを受け取るためのプロパティ
  var editTitle: String?
  var editType: String?
  var editMemo: String?
  var editmemo: memo!
  var editFlag: Bool = false
  var memoList_table = [memo]()
  var indexRow: Int? = nil
  
  //データピッカー用
  let typeList = ["home","work","study"]
  
    override func viewDidLoad() {
        super.viewDidLoad()
        //デリゲートの設定
        titleTextField.delegate = self
        typeTextField.delegate = self
        memoTextView.delegate = self
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.showsSelectionIndicator = true
        //toolbarを定義する
        let toolbar = UIToolbar(frame: CGRect(x:0,y:0,width:0,height:35))
      
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(AddMemoController.done))
      
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(AddMemoController.cancel))
      
        toolbar.setItems([cancelItem,doneItem], animated: true)
      
        do{
          let realm = try Realm()
          memoLists = realm.objects(memo.self)
          print(Realm.Configuration.defaultConfiguration.fileURL!)
        }catch{
          print("realmエラー")
        }
        self.typeTextField.inputView = pickerView
      
        self.typeTextField.inputAccessoryView = toolbar
      
//        titleTextField.text = editTitle
//        typeTextField.text = editType
//        memoTextView.text = editMemo
          titleTextField.text = editmemo?.title
          typeTextField.text = editmemo?.type
          memoTextView.text = editmemo?.memo

    }
    
  @IBAction func tapSaveButton(_ sender: Any) {
    let addMemo = memo()
    formatter.dateFormat = "yyyy-MM-dd"
    formatter.locale = Locale(identifier: "ja_JP")
    addMemo.title = titleTextField.text!
    addMemo.type = typeTextField.text!
    addMemo.memo = memoTextView.text!
    let formatterDate = formatter.string(from: date)
    print(formatterDate)
    date = formatter.date(from: formatterDate)!

    addMemo.addDate = date
    
      do{
        let realm = try Realm()
        try! realm.write{
          if(editFlag == false){
            realm.add(addMemo)
          }else{
//            let predicate: NSPredicate = NSPredicate(format: "title = %@", editmemo.title)
//            print(editmemo.title)
//            let results = realm.objects(memo.self).filter(predicate)
//            print(results)
//            results[0].title = addMemo.title
//
//            print(typeTextField.text)
//            if(typeTextField.text != ""){
//              print(typeTextField.text)
//              results[0].type = typeTextField.text!
//            }else{
//              results[0].type = editmemo.type
//            }
//            print(addMemo.type)
//            results[0].memo = addMemo.memo
//            print(results[0].memo)
            memoList_table[indexRow!].setValue(titleTextField.text, forKeyPath: "title")
            memoList_table[indexRow!].setValue(typeTextField.text, forKey: "type")
            memoList_table[indexRow!].setValue(memoTextView.text, forKey: "memo")
            editFlag = false
          }
        }
      }catch{
          print("Realm Writeエラー")
      }
      self.navigationController?.popViewController(animated: true)
    }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    // キーボードを閉じる
    titleTextField.resignFirstResponder()
    typeTextField.resignFirstResponder()
    return true
  }
  
  //UITextViewで他の場所をタップした際にキーボードを閉じる
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if(self.memoTextView.isFirstResponder){
      self.memoTextView.resignFirstResponder()
    }
  }
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return typeList.count
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return typeList[row]
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    self.typeTextField.text = typeList[row]
  }

  //toolbarのdone実行処理
  @objc func done(){
    self.typeTextField.endEditing(true)
  }
  
  //toolbarのcancel実行処理
  @objc func cancel(){
    self.typeTextField.text = "選択してください"
    self.typeTextField.endEditing(true)
  }
  
}
