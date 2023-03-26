//
//  ListTypeViewController.swift
//  PayMeApp
//
//  Created by suriya taothongkom on 13/1/2566 BE.
//

import UIKit
import RealmSwift
class ListTypeViewController: UIViewController   , UITableViewDelegate , UITableViewDataSource   {
  
    var Model_data_Array = [Model_data]()
    var Model_Setting_Array = [Model_Setting]()
    var Model_Setting_ArrayForDelete = [Model_Setting]()
    var IndexItem : Results<Model_Setting>!
    var myTableView: UITableView!
    let MyCellId = "ListTypeTableViewCell"
//    let realm = try! Realm()
    
    
    var RowofModelSetting : Results<Model_Setting>?
    var item:Model_Setting?
 
    override func viewDidLoad() {
        
        super.viewDidLoad()
        navigationItem.title = "แก้ไขข้อมูล"
        view.backgroundColor =  .green
//        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
//              let displayWidth: CGFloat = self.view.frame.width
//              let displayHeight: CGFloat = self.view.frame.height
        myTableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width , height: view.frame.size.height ))
              myTableView.register(UINib.init(nibName: MyCellId  , bundle: nil), forCellReuseIdentifier: "DefaultCell")
              myTableView.dataSource = self
              myTableView.delegate = self
              self.view.addSubview(myTableView)
//        let getdataExpen = DatabaseHelper.shared.getAllType()
//        print(getdataExpen)
        
        self.Model_Setting_Array =  DatabaseHelper.shared.getAllModelSetting()
        self.Model_data_Array =  DatabaseHelper.shared.getAllModeldata()
        self.Model_Setting_ArrayForDelete =  DatabaseHelper.shared.getAllModelSetting()
    }
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 5
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  Model_Setting_Array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath) as! ListTypeTableViewCell
//        let itemsForDate = groupedItems[itemDates[indexPath.section]]!
//        SectionDay = dateFormatter.string(from:  Array(itemsForDate.sorted(byKeyPath: "expenses_Date"))[indexPath.row].expenses_Date!)
//        cell.time_label?.text = SectionDay.self
//        cell.type_header_label?.text = Array(itemsForDate.sorted(byKeyPath: "expenses_Date"))[indexPath.row].expenses_Type
//        let formattedNumber = numberFormatter.string(from:NSNumber(value: Array(itemsForDate.sorted(byKeyPath: "expenses_Date"))[indexPath.row].expenses_Salary))
//        cell.number_label?.text = formattedNumber
//        cell.type_text_sta?.text =  Array(itemsForDate.sorted(byKeyPath: "expenses_Date"))[indexPath.row].expenses_text_hidden
        
//        cell.HeaderType.text  =  Model_data_Array[indexPath.row].setting_type
//        cell.DetailType.text = Model_data_Array[indexPath.row].setting_type_in_ex
//        print(Model_Setting_Array[indexPath.row])
       
        cell.Header.text  = Model_Setting_Array[indexPath.row].setting_type
        cell.Detail.text    = Model_Setting_Array[indexPath.row].setting_type_in_ex
//        cell.layer.cornerRadius  =  15
//        cell.layer.shadowColor = UIColor.gray.cgColor
//        cell.layer.shadowRadius = 3.0
//        cell.layer.shadowOpacity = 2.0
//        cell.layer.shadowOffset = CGSize(width: 2, height: 4)
//        cell.layer.masksToBounds = false
        if( cell.Header?.text  == "รายจ่าย") {
            cell.Header?.textColor = UIColor(red: 1.00, green: 0.26, blue: 0.26, alpha: 1.00)
        }else{
            cell.Header?.textColor = UIColor(red: 0.31, green: 0.76, blue: 0.59, alpha: 1.00)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//
        let deleteAction = UIContextualAction(style: .destructive , title: "DELETE") { (action, view, completion) in
            let ModelSettingIndex = self.Model_Setting_Array[indexPath.row]
            print(ModelSettingIndex)
            let alertController = UIAlertController(title: "Default Style", message: "A standard alert.", preferredStyle: .alert)
            let ModelSetting = DatabaseHelper.shared.getAllModelSetting()
            let Modeldata = DatabaseHelper.shared.getAllModeldata()
            var ResultArrayModelData: [String] = []
            var ResultArrayModelSetting: [String] = []
            for ForModeldata in Modeldata {
                ResultArrayModelData.append(ForModeldata.expenses_Type)
            }
            for ForModelSetting in ModelSetting {
                ResultArrayModelSetting.append(ForModelSetting.setting_type_in_ex )
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            }
            alertController.addAction(cancelAction)
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            let meldArraySet  = Array(Set(ResultArrayModelData).intersection(Set(ResultArrayModelSetting)))
                if meldArraySet.firstIndex(of: ModelSettingIndex.setting_type_in_ex ) != nil {
                    print(" ไม่สามารถลบข้อมูลได้")
                } else {
                    print("ลบข้อมูลได้")
                        let realm = try! Realm()
                        print(ModelSettingIndex)
                        try! realm.write {
                            realm.delete(ModelSettingIndex)
                        }
                        self.Model_Setting_Array.remove(at: indexPath.row)
                       self.myTableView.deleteRows(at: [indexPath], with: .automatic)
                        self.myTableView.reloadData()
                }
            }
            alertController.addAction(OKAction)
            self.present( alertController , animated: true )
        }
        deleteAction.backgroundColor = UIColor(red: 1.00, green: 0.00, blue: 0.00, alpha: 1.00)
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

    override func viewWillAppear(_ animated: Bool){
        self.myTableView.reloadData()
    }

}
