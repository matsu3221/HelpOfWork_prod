//
//  memoViewController.swift
//  HelpOfWorkApp
//
//  Created by 松本唯尊 on 2019/07/27.
//  Copyright © 2019 松本唯尊. All rights reserved.
//

import UIKit
import RealmSwift

class memoViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
  
  @IBOutlet weak var memoListTable: UITableView!
  private var memoLists : Results<memo>!
  private var memos: [memo] = []
  var memoList_table = [memo]()
  
  //画面遷移で利用するindexPathの値を持つためのプロパティ
  var index: Int = 0
  
  override func viewDidLoad() {
        super.viewDidLoad()
    
        memoListTable.delegate = self
        memoListTable.dataSource = self
    
        //RealmSwiftインスタンスを生成する
        do{
          let realm = try Realm()
          memoLists = realm.objects(memo.self)
          //次画面に引き継ぐデータ
          memoList_table = Array(memoLists)
          print(memoLists)
          print(Realm.Configuration.defaultConfiguration.fileURL!)
        }catch{
          print("インスタンス生成失敗")
        }
  
  }

  //テーブルの表示数
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    print(memoLists.count)
    return memoLists.count
  }
  
  //テーブルのセル表示
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var cell = tableView.dequeueReusableCell(withIdentifier: "memoListTableCell", for: indexPath) as! memoTableViewCell2
    
    let formatter = DateFormatter()
    let memo: memo = self.memoLists[(indexPath as NSIndexPath).row];
    print("セル番号\(memoLists.count)")
    print(indexPath.row)
    cell.title.text = memo.title
    
    formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "ydMMM", options: 0, locale: Locale(identifier: "ja_JP"))
    
    cell.createDate.text = formatter.string(from: memo.addDate)
    print(memo.type)
    
    let image = UIImage.init(named: memo.type)
    //    image?.size.width = 48
    //    image?.size.height = 48
    
    //    cell.classImage.image = UIImage.init(named: "study")
    cell.classImage.image = image
    //    cell.classImage.contentMode = Scanner
    //    cell.classImage.image?.size.height = 48
    
    //imageViewを丸くする
    cell.classImage.layer.cornerRadius = cell.classImage.frame.size.width * 0.5
    cell.classImage.clipsToBounds = true
    
    return cell
  }
  
  //セルの高さ
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 77
  }
  
  @IBAction func addButtonAction(_ sender: Any) {
    self.performSegue(withIdentifier: "goCreateMemo", sender: nil)
  }
  
  //セルがタップされた際のイベント
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  
    index = indexPath.row
    //画面遷移
    performSegue(withIdentifier: "goEditMemo", sender: nil)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    if (segue.identifier == "goEditMemo"){
      let memo: memo = self.memoLists[index];
      let memoCreate = segue.destination as! memoCreateController
    
//      memoCreate.editTitle = memo.title
//      memoCreate.editType = memo.type
//      memoCreate.editMemo = memo.memo
      memoCreate.editmemo = memo
      memoCreate.editFlag = true
      memoCreate.memoList_table = memoList_table
      memoCreate.indexRow = index
    }
  }
  
  //画面がback、popViewControllerで戻ってきたときの再描写
  override func viewWillAppear(_ animated: Bool) {
      self.memoListTable.reloadData()
  }
  
  //tableView上のセルのスワイプ削除
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete{
      let deleteTableView:memo = memoList_table[indexPath.row]
      memoList_table.remove(at: indexPath.row)
      let realm = try! Realm()
      
      try! realm.write{
        realm.delete(deleteTableView)
      }
      
      tableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
    }
  }
  
}
