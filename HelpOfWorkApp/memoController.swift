//
//  memoController.swift
//  HelpOfWorkApp
//
//  Created by 松本唯尊 on 2019/05/08.
//  Copyright © 2019 松本唯尊. All rights reserved.
//

import UIKit

class memoController: UIViewController,UITableViewDataSource,UITableViewDelegate {
  
  //メモタイトルプロパティの宣言
  var memoTitleList = [String]()
  
  //メモテキストプロパティの宣言
  var memoTextList = [String]()
  
  //テーブルのセルをタップした時のセルの位置を記憶する
  var choseCell: Int = 0
  
  //メモテーブルViewのOutlet定義
  @IBOutlet weak var memoTableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //保存しているmemoTitleの読み込み処理
    let userDefaults = UserDefaults.standard
    if let storedMemoTitleList = userDefaults.array(forKey: "title") as? [String]{
      memoTitleList.append(contentsOf: storedMemoTitleList)
    }
    if let storedMemoTextList = userDefaults.array(forKey: "text") as? [String]{
      memoTextList.append(contentsOf: storedMemoTextList)
    }
    
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
    tableView.estimatedRowHeight = 100
    return 100
  }
  
  //テーブルの行数を返却する
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //ToDoの配列の長さを返却する
    print(memoTitleList.count)
    return memoTitleList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //Storyboardで指定したmemoListCell識別子を利用して再利用可能なセルを取得する
    let cell = memoTableView.dequeueReusableCell(withIdentifier: "memoList", for: indexPath)
    
    //行番号に合ったmemoタイトルを取得
    let memoTitle = memoTitleList[indexPath.row]
    
    //行番号に合ったmemoテキストを取得
    let memoText = memoTextList[indexPath.row]
    
    //セルのラベルにメモタイトルをセット
    cell.textLabel?.text = memoTitle
    
    //セルのテキストにメモテキストをセット
    cell.detailTextLabel?.text = memoText
    
    return cell
  }

  //セルが編集可能であるかどうかを返却する
  func tableView(_ tableView: UITextView,canEditRowAt indexPath: IndexPath) -> Bool{
    return true
  }
  
  //セルを削除した時の処理
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    //削除処理かどうか
    if editingStyle == UITableViewCell.EditingStyle.delete{
      //メモタイトルリストから削除
      memoTitleList.remove(at: indexPath.row)
      //メモテキストリストから削除
      memoTextList.remove(at: indexPath.row)
      //セルを削除
      memoTableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
      //データ保存
      let userDefaults = UserDefaults.standard
      userDefaults.set(memoTitleList, forKey: "title")
      userDefaults.set(memoTextList, forKey: "text")
    }
  }
  
  // セルが選択された時に呼ばれる
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // 選択されたcellの番号を記憶
    choseCell = indexPath.row
    // 画面遷移の準備
    performSegue(withIdentifier: "toDetail",sender: nil)
  }
  
  // Segue 準備
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if(segue.identifier == "toDetail"){
      let addMemoController = segue.destination as? AddMemoController
      addMemoController?.choseCell = self.choseCell
      print(self.choseCell)
      addMemoController?.detail = true
    }
  }
}
