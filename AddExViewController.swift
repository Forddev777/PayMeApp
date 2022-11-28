//
//  AddExViewController.swift
//  PayMeApp
//
//  Created by suriya taothongkom on 28/11/2565 BE.
//

import UIKit

class AddExViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 1.00, green: 0.26, blue: 0.26, alpha: 1.00)
        let label = UILabel(frame: CGRect(x: 0 , y: 0.05 * self.view.frame.size.width,
                                                  width: self.view.frame.size.width ,
                                                  height: 25))
            label.textAlignment = .center
            label.text = "เพิ่มรายการรายจ่าย"
            label.backgroundColor = .brown
            label.textColor = .white
            label.font = UIFont(name: "Halvetica", size: 17)
            self.view.addSubview(label)
//            text_fixld = UITextField.init(frame:
//                                            (CGRect(x: 0,
//                                                    y: 0.15 * self.view.frame.size.width,
//                                                    width: self.view.frame.size.width,
//                                                    height: 40)))
//            text_fixld?.placeholder = "ระบุเงิน"
//            text_fixld?.textColor = .black
//            text_fixld?.textAlignment = .center
//            text_fixld?.backgroundColor = .white
//            self.view.addSubview(text_fixld!)
    }
    

   
}
