//
//  memo.swift
//  HelpOfWorkApp
//
//  Created by 松本唯尊 on 2019/07/28.
//  Copyright © 2019 松本唯尊. All rights reserved.
//

//import Foundation
import RealmSwift

class memo: Object{
  @objc dynamic var title: String = ""
  @objc dynamic var type: String = "home"
  @objc dynamic var memo: String = ""
  @objc dynamic var addDate = Date()
}
