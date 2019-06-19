//
//  AddMemoController.swift
//  HelpOfWorkApp
//
//  Created by 松本唯尊 on 2019/05/08.
//  Copyright © 2019 松本唯尊. All rights reserved.
//

import UIKit

class AddMemoController: UIViewController,UITextFieldDelegate,UITextViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource{
  
  //メモタイトルプロパティの宣言
  var memoTitleList = [String]()
  
  //メモクラスプロパティの宣言
  var memoClassList = [String]()
  
  //メモテキストプロパティの宣言
  var memoTextList = [String]()
  
  //詳細表示かどうか判定する
  var detail: Bool = false
  
  //前画面から詳細表示が指定された際に実行
  var choseCell: Int?
  
  //classPicker用リスト
  let list = ["技術","仕事","その他"]
  
  //UIPickerインスタンス生成
  var classPicker:UIPickerView = UIPickerView()
  
  //タイトルテキスト
  @IBOutlet weak var titleText: UITextField!
  
  //メモテキスト
  @IBOutlet weak var memoText: UITextView!
  
  //クラステキスト
  @IBOutlet weak var classText: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    titleText.delegate = self
    memoText.delegate = self
    classPicker.delegate = self
    classPicker.dataSource = self
    classPicker.showsSelectionIndicator = true
    
    //toolbarを定義する
    let toolbar = UIToolbar(frame: CGRectMake(0,0,0,35))
    
    let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(AddMemoController.done))

    let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(AddMemoController.cancel))

    toolbar.setItems([cancelItem,doneItem], animated: true)
    
    //保存しているmemoTitleの読み込み処理
    let userDefaults = UserDefaults.standard
    if let storedMemoTitleList = userDefaults.array(forKey: "title") as? [String]{
      memoTitleList.append(contentsOf: storedMemoTitleList)
    }
    
    if let storedMemoClassList = userDefaults.array(forKey: "class") as? [String]{
      memoClassList.append(contentsOf: storedMemoClassList)
    }
    
    if let storedMemoTextList = userDefaults.array(forKey: "text") as? [String]{
      memoTextList.append(contentsOf: storedMemoTextList)
    }
    
    if let choseCell2: Int = choseCell{
      titleText.text = memoTitleList[choseCell2]
      classText.text = memoClassList[choseCell2]
      memoText.text = memoTextList[choseCell2]
    }
    
    self.classText.inputView = classPicker
    
    self.classText.inputAccessoryView = toolbar
  }
  
  //保存ボタンをタップした時の処理
  @IBAction func SaveButton(_ sender: Any) {
    //UserDefaultsの参照
    let userDefaults = UserDefaults.standard

    if(detail){
      memoTitleList[choseCell!] = titleText.text!
      memoClassList[choseCell!] = classText.text!
      memoTextList[choseCell!] = memoText.text!
    }else{
      memoTitleList.append(titleText.text!)
      memoClassList.append(classText.text!)
      memoTextList.append(memoText.text!)

    }
    //titleというキーでタイトルの値を保存する
    userDefaults.set(self.memoTitleList, forKey: "title")
    //classというキーでクラスの値を保存する
    userDefaults.set(self.memoClassList, forKey: "class")
    //textというキーでテキストの値を保存する
    userDefaults.set(self.memoTextList, forKey: "text")
    //UserDefaultsへの値の保存を明示的に行う
    userDefaults.synchronize()
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    // キーボードを閉じる
    titleText.resignFirstResponder()
    return true
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if (self.memoText.isFirstResponder) {
      self.memoText.resignFirstResponder()
    }
  }
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return list.count
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return list[row]
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    self.classText.text = list[row]
  }
  
  func CGRectMake(_ x:CGFloat, _ y:CGFloat, _ width:CGFloat, _ height:CGFloat)-> CGRect{
    return CGRect(x:x, y:y,width: width, height: height)
  }
  
  //toolbarのdone実行処理
  @objc func done(){
    self.classText.endEditing(true)
  }
  
  //toolbarのcancel実行処理
  @objc func cancel(){
    self.classText.text = "選択してください"
    self.classText.endEditing(true)
  }
  
}
