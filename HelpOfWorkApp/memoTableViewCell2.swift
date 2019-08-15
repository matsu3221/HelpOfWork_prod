//
//  memoTableViewCell2.swift
//  HelpOfWorkApp
//
//  Created by 松本唯尊 on 2019/07/27.
//  Copyright © 2019 松本唯尊. All rights reserved.
//

import UIKit

class memoTableViewCell2: UITableViewCell {

   @IBOutlet weak var classImage: UIImageView!
  
  @IBOutlet weak var title: UILabel!
  
  @IBOutlet weak var createDate: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
