//
//  WeatherCheckControllerVIewViewController.swift
//  HelpOfWorkApp
//
//  Created by 松本唯尊 on 2019/07/21.
//  Copyright © 2019 松本唯尊. All rights reserved.
//

import UIKit

class WeatherCheckControllerVIewViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,UITextViewDelegate {
  
  //天気を表示するテーブル
  @IBOutlet weak var weatherTable: UITableView!
  
  //検索場所を選択するsearchView
  @IBOutlet weak var selectPlace: UITextField!
  
  //検索場所のリスト
  var searchPlaceList = ["広島","東京","大阪","名古屋"]
  
  var searchPlacePicker: UIPickerView = UIPickerView()
  
  //表示テーブル行の情報
  let tableCellBI = ["今日","明日","明後日"]
  let imageName = ["sunny","rain","snow"]
  var tenkiList : [(date:String, telop:String, imageUrl:String, temperatureMaxCelsius:String, temperatureMinCelsius:String)] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    weatherTable.delegate = self
    weatherTable.dataSource = self
    
    self.weatherTable.separatorColor = UIColor(named:"969696")
    self.weatherTable.allowsSelection = false
    selectPlace.delegate = self
    
    //検索用dataPickerView
    searchPlacePicker.delegate = self
    searchPlacePicker.dataSource = self
    searchPlacePicker.showsSelectionIndicator = true
    
    //toolbarを定義する
    let toolbar = UIToolbar(frame: CGRect(x: 0,y: 0,width: 0,height: 35))
    
    //ToolBarを閉じるボタンを追加
    let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(WeatherCheckControllerVIewViewController.done))
    
    let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(WeatherCheckControllerVIewViewController.cancel))
    
    toolbar.setItems([cancelItem,doneItem], animated: true)
    
    selectPlace.inputView = searchPlacePicker
    selectPlace.inputAccessoryView = toolbar
    
    }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    print(tableCellBI.count)
    return tenkiList.count
    
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    // セルを取得する
    let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCheckTableViewCell", for: indexPath) as! WeatherCheckTableViewCell
    print(indexPath)
    if(tenkiList.count != 0 && indexPath.row <= 2){
      print(indexPath.row)
      print(tenkiList[indexPath.row])
      cell.displayDay.text = tenkiList[indexPath.row].date
      print(tenkiList[indexPath.row].imageUrl)
      cell.highTemperature.text = tenkiList[indexPath.row].temperatureMaxCelsius
      cell.lowTemperature.text = tenkiList[indexPath.row].temperatureMinCelsius
      var url = URL(string: tenkiList[indexPath.row].imageUrl)
      do{
        var data = try Data(contentsOf: url!)
        cell.weatherImage.image = UIImage(data: data)
      }catch{
        print("画像取得に失敗しました")
      }

    }else{
        cell.displayDay.text = ""
        cell.highTemperature.text = ""
        cell.lowTemperature.text = ""
        cell.weatherImage.image = nil
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 170
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  @IBAction func searchButtonTapAction(_ sender: Any) {

    //tenkiListリセット
    self.tenkiList = []
    
    //デフォルトは広島に設定しておく
    var placePalm = "340010"

    if(selectPlace.text == "東京"){
      placePalm = "130010"
    }else if(selectPlace.text == "大阪"){
      placePalm = "270000"
    }else if(selectPlace.text == "名古屋"){
      placePalm = "230010"
    }
    
    //URLを設定
    let URL = Foundation.URL(string:"http://weather.livedoor.com/forecast/webservice/json/v1?city=\(placePalm)")
    print(URL)
    
    //リクエストオブジェクト作成
    let req = URLRequest(url: URL!)
    
    //セッションの接続をカスタマイズ（デフォルトでOK）
    let configuration = URLSessionConfiguration.default
    
    //セッション情報を取り出す
    let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
    
    //リクエストをタスクとして登録
    let task = session.dataTask(with: req, completionHandler: {
      (data, response , error ) in
      do{
        let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String:Any]

        if let datas = json["forecasts"] as? [[String:Any]]{
          print(json)
          print(datas)
          print(datas.count)
          for i in 0...(datas.count-1){
            let date = datas[i]["date"] as! String
            let telop = datas[i]["telop"] as! String
            let image = datas[i]["image"] as! [String:Any]
            let imageUrl = image["url"] as! String
            var temperature = datas[i]["temperature"] as! [String:Any]
            var temperatureMinCelsius = ""
            var temperatureMaxCelsius = ""
            if (temperature["min"] as? [String:Any]) != nil {
              let temperatureMin = temperature["min"] as! [String:Any]
              temperatureMinCelsius = temperatureMin["celsius"] as! String
            }

            if(temperature["min"] as? [String:Any]) != nil{
              let temperatureMax = temperature["max"] as! [String:Any]
              temperatureMaxCelsius =  temperatureMax["celsius"] as! String
            }
            let tenki = (date,telop,imageUrl,temperatureMaxCelsius,temperatureMinCelsius)
            print(tenki)
            self.tenkiList.append(tenki)
          }
        }
        print(self.tenkiList.count)
        print(self.tenkiList)
        self.weatherTable.reloadData()
//        self.tenkiList = []
      }catch{
        print("エラーが発生！")
      }
    })
    task.resume()
  }
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return searchPlaceList.count
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return searchPlaceList[row]
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    self.selectPlace.text = searchPlaceList[row]
  }
  
  //toolbarのdone実行処理
  @objc func done(){
    self.selectPlace.endEditing(true)
  }
  //toolbarのcancel実行処理
  @objc func cancel(){
    self.selectPlace.text = "選択してください"
    self.selectPlace.endEditing(true)
  }
  //searchPlace用ピッカーメソッド(ここまで)
}
