//
//  SettingViewController.swift
//  PayMeApp
//
//  Created by suriya taothongkom on 3/1/2566 BE.
//

import UIKit

struct Catagoitems {
    
    let title: String
    let items: [String]
    
}

class SettingViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {
    private let myArray: NSArray = ["เพิ่มข้อมูลรายรับ","เพิ่มข้อมูลรายจ่าย","แก้ไขประเภทข้อมูล"]
    private var myTableView: UITableView!
    var Model_data_Array = [Model_data]()
    var Model_Setting_Array = [Model_Setting]()
    var callbackSuccess: (() -> ())?
    override func viewDidLoad() {
       
        view.backgroundColor = .gray
        super.viewDidLoad()
//        self.navigationController?.navigationBar.barTintColor = .blue
       

        let label = UILabel(frame: CGRect(x: 0 ,
                                          y: 0.05 * self.view.frame.size.width,
                                          width: self.view.frame.size.width ,
                                          height: 25))
        label.textAlignment = .center
        label.text = "ตั้งค่า"
        label.textColor = .white
        label.font = UIFont(name: "Halvetica", size: 25)
        self.view.addSubview(label)
        
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
              let displayWidth: CGFloat = self.view.frame.width
              let displayHeight: CGFloat = self.view.frame.height

        myTableView = UITableView(frame: CGRect(x: 0, y: 50, width: displayWidth, height: displayHeight - barHeight))
              myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
              myTableView.dataSource = self
              myTableView.delegate = self
              self.view.addSubview(myTableView)
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          print("Num: \(indexPath.row)")
          print("Value: \(myArray[indexPath.row])")
        let liveAlbums = indexPath.row

        switch liveAlbums {
        case 0:
            print("รายรับ")
            let vcpass = SettingIncomedetailViewController()
            vcpass.modalPresentationStyle = .overFullScreen
            self.navigationController?.pushViewController( vcpass, animated:   true)
            
        case 1:
            print("รายจ่าย")
            let vcpass = SettingExpensesdetailViewController()
            vcpass.modalPresentationStyle = .overFullScreen
            self.navigationController?.pushViewController( vcpass, animated:   true)
        case 2:
            print("TypeList")
            let vcpass = ListTypeViewController()
                self.myTableView.reloadData()
            vcpass.modalPresentationStyle = .overFullScreen
            self.navigationController?.pushViewController( vcpass, animated:   true)
        default:
            print("default")
        }
      }

      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return myArray.count
      }

      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
          cell.textLabel!.text = "\(myArray[indexPath.row])"
          cell.accessoryType = .disclosureIndicator
          return cell
      }
    
}
