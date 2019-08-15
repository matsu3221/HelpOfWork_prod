//
//  WeatherCheckTableViewCell.swift
//  HelpOfWorkApp
//
//  Created by 松本唯尊 on 2019/07/21.
//  Copyright © 2019 松本唯尊. All rights reserved.
//

import UIKit

class WeatherCheckTableViewCell: UITableViewCell {

  //天気を表示する日
  @IBOutlet weak var displayDay: UILabel!
  //天気の画像
  @IBOutlet weak var weatherImage: UIImageView!
  //最高気温を表示
  @IBOutlet weak var highTemperature: UITextField!
  //最低気温を表示
  @IBOutlet weak var lowTemperature: UITextField!
  
  
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
