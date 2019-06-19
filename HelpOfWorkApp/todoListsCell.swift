//
//  todoListsCell.swift
//  HelpOfWorkApp
//
//  Created by 松本唯尊 on 2019/06/14.
//  Copyright © 2019 松本唯尊. All rights reserved.
//

import UIKit

class todoListsCell: UITableViewCell,UITextViewDelegate {

  @IBOutlet weak var title: UILabel!
  
  @IBOutlet weak var time: UITextField!
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

  override func setSelected(_ selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)

      // Configure the view for the selected state
  }
 
  func textFieldShouldReturn(_ textField:UITextField) -> Bool{
    time.resignFirstResponder()
    return true
  }
  
}
