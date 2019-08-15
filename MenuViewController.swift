//
//  MenuViewController.swift
//  HelpOfWorkApp
//
//  Created by 松本唯尊 on 2019/07/16.
//  Copyright © 2019 松本唯尊. All rights reserved.
//

import UIKit
import CircleMenu

class MenuViewController: UIViewController,CircleMenuDelegate {
  
  let menuButtons:[(icon:String,color:UIColor)]=[
    ("ToDo",UIColor(red: 0.878, green: 0.352, blue:0.352,alpha: 1)),
    ("Note",UIColor(red: 0.286, green: 0.450, blue:0.905, alpha: 1)),
    ("WeatherCheck",UIColor(red: 0.901, green: 0.662, blue:0.478, alpha: 1)),
    ("News",UIColor(red: 0.478, green: 0.901, blue:0.588, alpha: 1)),
  ]
  
  
  let button = CircleMenu(
    frame: CGRect(x: 162, y: 296, width: 50, height: 50),
    normalIcon:"Menu-1",
    selectedIcon:"Menu-1",
    buttonsCount: 4,
    duration: 1.5,
    distance: 120)
  
  func circleMenu(_: CircleMenu, willDisplay button: UIButton, atIndex: Int) {
    button.backgroundColor = menuButtons[atIndex].color
    
    button.setImage(UIImage(named: menuButtons[atIndex].icon), for: .normal)

    button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
  }
  
  private func circleMenu(circleMenu: CircleMenu, buttonDidSelected button: UIButton, atIndex: Int){
    self.performSegue(withIdentifier: "goToDo", sender: nil)
  }
  
  func circleMenu(_: CircleMenu, buttonDidSelected _: UIButton, atIndex: Int) {
    print("button did selected: \(menuButtons[atIndex].icon)")
    if(menuButtons[atIndex].icon=="ToDo"){
      performSegue(withIdentifier: "goToDo", sender: nil)
    }else if(menuButtons[atIndex].icon=="Note"){
      performSegue(withIdentifier: "goNote", sender: nil)
    }else if(menuButtons[atIndex].icon == "WeatherCheck"){
      performSegue(withIdentifier: "goWeatherCheck", sender: nil)
    }
  }
  
    override func viewDidLoad() {
        super.viewDidLoad()
      button.delegate = self
      button.layer.cornerRadius = button.frame.size.width / 1.0
      view.addSubview(button)
    }

}
