//
//  memoTableViewCell.swift
//  HelpOfWorkApp
//
//  Created by 松本唯尊 on 2019/05/12.
//  Copyright © 2019 松本唯尊. All rights reserved.
//

import UIKit

class memoTableViewCell: UITableViewCell {

  
  @IBOutlet weak var memoTitle: UILabel!
  
  @IBOutlet weak var memoText: UITextView!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
