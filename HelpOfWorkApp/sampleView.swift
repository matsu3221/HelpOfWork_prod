//
//  sampleView.swift
//  HelpOfWorkApp
//
//  Created by 松本唯尊 on 2019/07/21.
//  Copyright © 2019 松本唯尊. All rights reserved.
//

import UIKit
import PMSuperButton

class sampleView: UIViewController {

  @IBOutlet weak var sampleButton: PMSuperButton!
  
  @IBOutlet weak var sampleButton2: PMSuperButton!
  
    override func viewDidLoad() {
        super.viewDidLoad()

      sampleButton.touchUpInside {
        print("Hello World")
      }
      
//     sampleButton.showLoader(userInteraction: true)
     
      sampleButton.hideLoader()
      sampleButton2.touchUpInside {
      }
      
        // Do any additional setup after loading the view.
    }
  
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
}
