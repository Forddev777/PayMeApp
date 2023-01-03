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
class SettingViewController: UIViewController{
    private let mytableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    
    private let data:[Catagoitems] = [
        Catagoitems(title: "ประเภทรายรับ" , items: ["a" , "b" , "c"]),
        Catagoitems(title: "ประเภทรายจ่าย" , items: ["x" , "y" , "z"]),
        Catagoitems(title: "Three" , items: ["g" , "g" , "g"])
        ]

//    private var myTableView: UITableView!
    override func viewDidLoad() {
        view.backgroundColor = .blue
        super.viewDidLoad()
        let label = UILabel(frame: CGRect(x: 0 ,
                                          y: 0.05 * self.view.frame.size.width,
                                          width: self.view.frame.size.width ,
                                          height: 25))
        label.textAlignment = .center
        label.text = "ตั้งค่า"
        label.textColor = .white
        label.font = UIFont(name: "Halvetica", size: 25)
        self.view.addSubview(label)
    
        self.view.addSubview(mytableView)
       
        mytableView.dataSource = self
        mytableView.delegate = self
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mytableView.frame = view.bounds
    }
    
}

extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mytableView.deselectRow(at: indexPath, animated: true)
        let catagory =  data[indexPath.row]
        let vc =  ListViewController(items: catagory.items)
        vc.title = catagory.title
        print(catagory)
        navigationController?.pushViewController(vc, animated: true)
      }
}

extension SettingViewController: UITableViewDataSource {
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return data.count
      }
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = mytableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
          cell.textLabel!.text = data[indexPath.row].title
          cell.accessoryType = .disclosureIndicator
          return cell
      }

}
