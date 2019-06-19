//
//  TodoList_Calendar_Realm.swift
//  HelpOfWorkApp
//
//  Created by 松本唯尊 on 2019/06/11.
//  Copyright © 2019 松本唯尊. All rights reserved.
//

import Foundation
import RealmSwift

class todo:Object{
  @objc dynamic var title:String = ""
  @objc dynamic var addDay:Date?
  @objc dynamic var done:Bool = false
  @objc dynamic var time:Int = 0
}
