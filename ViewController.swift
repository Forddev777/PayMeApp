//
//  ViewController.swift
//  PayMeApp
//
//  Created by suriya taothongkom on 28/11/2565 BE.
//

import UIKit
import StickyButton
import RealmSwift
class ViewController: UIViewController  {

    var Model_data_Array = [Model_data]()
    @IBOutlet weak var Label_ToDate: UILabel!
    let date = Date()
    let dateFormatter = DateFormatter()
    let TimeFormatter = DateFormatter()
    let numberFormatter = NumberFormatter()
    @IBOutlet weak var Label_Time: UILabel!
    @IBOutlet weak var View_Grahp: UIView!
    @IBOutlet weak var TableView: UITableView!
    let MyCellId = "MyTableViewCell"
//    @IBOutlet weak var Label_text: UILabel!
    var Activity_Header = [Date:[String]]()
    var TodateSectionTitles = [String]()
    var dataIn_Exs: [String] = []
    var date_section: String = ""
   @IBOutlet weak var Button_action: StickyButton!
//    var barChart = BarChartView()
    
    let realm = try! Realm()
    var items: Results<Model_data>?
    var groupedItems = [Date:Results<Model_data>]()
    var itemDates = [Date]()
    
    override func viewDidLoad() {
        configuration()
        super.viewDidLoad()
        TableView.register(UINib.init(nibName: MyCellId  , bundle: nil), forCellReuseIdentifier: "DefaultCell")
        TableView.rowHeight = UITableView.automaticDimension
        TableView.separatorColor = UIColor.clear
        dateFormatter.dateFormat = "dd MMMM yyyy"
        TimeFormatter.dateFormat = "HH:mm"
        dateFormatter.locale = Locale(identifier: "th")
        Label_ToDate.text = "\u{00a0}\u{00a0}\(dateFormatter.string(from: date))\u{00a0}\u{00a0}"
        Label_ToDate.layer.shadowColor = UIColor.gray.cgColor
        Label_ToDate.layer.shadowRadius = 3.0
        Label_ToDate.layer.shadowOpacity = 2.0
        Label_ToDate.layer.shadowOffset = CGSize(width: 1, height: 4)
        Label_ToDate.layer.masksToBounds = false
        Label_Time.text = "\(TimeFormatter.string(from: date))"
        Label_Time.layer.shadowColor = UIColor.gray.cgColor
        Label_Time.layer.shadowRadius = 3.0
        Label_Time.layer.shadowOpacity = 2.0
        Label_Time.layer.shadowOffset = CGSize(width: 1, height: 4)
        Label_Time.layer.masksToBounds = false
        Button_action.addItem(title: "เพิ่มรายรับ", icon: UIImage(systemName: "dollarsign.circle" )){
            item in
            self.present(self.AddINView(forType: "Home"), animated: true, completion: nil)
        }
        Button_action.addItem(title: "เพิ่มรายจ่าย", icon: UIImage(systemName: "dollarsign.square")){
            item in
            self.present(self.AddExView(forType: "EX") , animated: true, completion: nil)
        }
        Button_action.addItem(title: "ตั้งค่า", icon: UIImage(systemName: "gearshape")){
            item in
            self.present(self.SetingView(forType: "Seting") , animated: true, completion: nil)
        }
        // pull to refesh in ios swift //
//        TableView.refreshControl = UIRefreshControl()
//        TableView.refreshControl?.addTarget(self, action: #selector(configuration), for: .valueChanged)
        
     
//        let vc = AddINViewController()
//            vc.callbackSuccess = {
//
//                     self.TableView.reloadData()
//            }
      
       
                  
        
    }
    
    func SortDay(){
                let items = DatabaseHelper.shared.getAllContacts()
                itemDates = items.reduce(into: [Date](), { results, currentItem in
                           let date = currentItem.expenses_Date!
                           let beginningOfDay = Calendar.current.date(from: DateComponents(year: Calendar.current.component(.year, from: date), month:                  Calendar.current.component(.month, from: date), day: Calendar.current.component(.day, from: date), hour: 0, minute: 0, second: 0))!
                           let endOfDay = Calendar.current.date(from: DateComponents(year: Calendar.current.component(.year, from: date), month: Calendar.current.component(.month, from: date), day: Calendar.current.component(.day, from: date), hour: 23, minute: 59, second: 59))!
                           //Only add the date if it doesn't exist in the array yet
                           if !results.contains(where: { addedDate->Bool in
                               return addedDate >= beginningOfDay && addedDate <= endOfDay
                           }) {
                               results.append(beginningOfDay)
                           }
                       })
                                    //Filter each Item in realm based on their date property and assign the results to the dictionary
                        groupedItems = itemDates.reduce(into: [Date:Results<Model_data>](),
                        { results, date in
                            let beginningOfDay = Calendar.current.date(from: DateComponents(year: Calendar.current.component(.year, from: date), month:                                          Calendar.current.component(.month, from: date), day: Calendar.current.component(.day, from: date), hour: 0, minute: 0, second: 0))!
                            let endOfDay =       Calendar.current.date(from: DateComponents(year: Calendar.current.component(.year, from: date), month:                                    Calendar.current.component(.month, from: date), day: Calendar.current.component(.day, from: date), hour: 23, minute: 59, second: 59))!
                            results[beginningOfDay] = realm.objects(Model_data.self).filter("expenses_Date >= %@ AND expenses_Date <= %@", beginningOfDay, endOfDay)
                           
                        })
        }
    
    
    @objc  func configuration(){
        TableView.delegate = self
        TableView.dataSource = self
        Model_data_Array = DatabaseHelper.shared.getAllContacts()
        self.TableView.reloadData()
//        self.TableView.refreshControl?.endRefreshing()
        self.SortDay()
        TableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    private func AddINView(forType type: String) -> UIViewController {
        let vc = AddINViewController()
            vc.callbackSuccess = {
                     self.Model_data_Array = DatabaseHelper.shared.getAllContacts()
                self.SortDay()
                     self.TableView.reloadData()
            }
            vc.modalPresentationStyle = .pageSheet
            navigationController?.pushViewController(vc, animated: true)
        return vc
    }
    private func AddExView(forType type: String) -> UIViewController {
        let vcEX = AddExViewController()
            vcEX.callbackSuccess = {
                self.Model_data_Array = DatabaseHelper.shared.getAllContacts()
                self.SortDay()
                self.TableView.reloadData()
            }
            vcEX.modalPresentationStyle = .pageSheet
            navigationController?.pushViewController(vcEX, animated: true)
        return vcEX
   }
    private func SetingView(forType type: String) -> UIViewController {
        let vcseting = AddSetingViewController()
        vcseting.modalPresentationStyle = .pageSheet
        navigationController?.pushViewController(vcseting , animated: true)
        return vcseting
    }
//
//    private func AddExView(){
////        let vcEX = AddExViewController()
////        navigationController?.pushViewController(vcEX, animated: true)
////        return vcEX
//
//        let story = UIStoryboard(name: "Main_In", bundle: nil)
//        let controller = story.instantiateViewController(withIdentifier: "AddExViewController") as!
//        AddExViewController
//        self.present(controller, animated: true, completion: nil)
//
//
//    }
//
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        barChart.frame  = CGRect(x: 0 ,
//                                 y: 0 ,
//                                 width:  self.View_Grahp.frame.size.width,
//                                 height: self.View_Grahp.frame.size.height  )
//
//
//        View_Grahp.addSubview(barChart)
//
//        var entries = [BarChartDataEntry]()
//
//        for x in 0..<5 {
//            entries.append(BarChartDataEntry(x: Double(x),
//                                             y: Double(x)))
//        }
//
//        let set = BarChartDataSet(entries: entries)
//
//        set.colors = [UIColor(red: 1.00, green: 0.26, blue: 0.26, alpha: 1.00)]
//       // FE4343
//        let data = BarChartData(dataSet: set)
//        barChart.data = data
//
//    }
    
    override func viewWillAppear(_ animated: Bool){
        self.TableView.reloadData()
    }
    
}

//    let sortedDates = self.grouped.keys.sorted(>)
//    Model_data_Array.self = sortedDates.map{Model_data(expenses_Date: $0)}


extension ViewController : UITableViewDelegate  , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
//        return Model_data_Array.count
        return   itemDates.count
        
       
      }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupedItems[itemDates[section]]!.count
        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath) as! MyTableViewCell
                    cell.selectionStyle = .none
                    numberFormatter.numberStyle = .decimal
//                    let formattedNumber = numberFormatter.string(from:NSNumber(value: Model_data_Array[indexPath.row].expenses_Salary))
//                    cell.number_label?.text = formattedNumber
//                    cell.type_header_label?.text = Model_data_Array[indexPath.row].expenses_Type
//                    cell.type_text_sta?.text = Model_data_Array[indexPath.row].expenses_text_hidden
//                    cell.time_label?.text = dateFormatter.string(from: Model_data_Array[indexPath.row].expenses_Date!)
       
                let itemsForDate = groupedItems[itemDates[indexPath.section]]!
                cell.time_label?.text =  dateFormatter.string(from:  Array(itemsForDate.sorted(byKeyPath: "expenses_Date"))[indexPath.row].expenses_Date!)
                cell.type_header_label?.text = Array(itemsForDate.sorted(byKeyPath: "expenses_Date"))[indexPath.row].expenses_Type
                let formattedNumber = numberFormatter.string(from:NSNumber(value: Array(itemsForDate.sorted(byKeyPath: "expenses_Date"))[indexPath.row].expenses_Salary))
                cell.number_label?.text = formattedNumber
                cell.type_text_sta?.text =  Array(itemsForDate.sorted(byKeyPath: "expenses_Date"))[indexPath.row].expenses_text_hidden
                if( cell.type_text_sta?.text  == "รายจ่าย") {
                    cell.number_label?.textColor = UIColor(red: 1.00, green: 0.26, blue: 0.26, alpha: 1.00)
                }else{
                    cell.number_label?.textColor = UIColor(red: 0.31, green: 0.76, blue: 0.59, alpha: 1.00)
                }
                    cell.layer.cornerRadius  =  15
                    cell.layer.shadowColor = UIColor.gray.cgColor
                    cell.layer.shadowRadius = 3.0
                    cell.layer.shadowOpacity = 2.0
                    cell.layer.shadowOffset = CGSize(width: 2, height: 4)
                    cell.layer.masksToBounds = false
                        return cell
            }

            func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
                return true
            }
            func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
                return .none
            }
            func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
                let deleteAction = UIContextualAction(style: .destructive , title: "DELETE") {(action, view, completion) in
                    self.TableView.deleteRows(at: [indexPath], with: .automatic)
                }
                deleteAction.backgroundColor = UIColor(red: 1.00, green: 0.00, blue: 0.00, alpha: 1.00)
                return UISwipeActionsConfiguration(actions: [deleteAction])
            }
   

//        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
//
//            let MyCell = TableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath ) as! MyTableViewCell
//            MyCell.type_header_label?.text = Model_data_Array[indexPath.row].expenses_Type
//            MyCell.time_label?.text = "เวลา"
//            MyCell.number_label?.text = String(Model_data_Array[indexPath.row].expenses_Salary)
//            MyCell.type_text_sta?.text = "จ่าย / รับ "
            
//            let Cell = TableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
//
//
            
//            guard var cell = tableView.dequeueReusableCell(withIdentifier: "Cell") else{
//                return UITableViewCell()
//            }
            
        
//            let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
//            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
            
//            cell.text_H_label?.text = Model_data_Array[indexPath.row].expenses_Type
//             cell.detailTextLabel?.text = Model_data_Array[indexPath.row].expenses_Description
            
//            cell.input_number?.text = String(Model_data_Array[indexPath.row].expenses_Salary)
//            cell.type_Label?.text = "จ่าย / รับ "
//
//
                                                              
                        
//            Cell.layer.cornerRadius  =  15
//            Cell.layer.shadowColor = UIColor.gray.cgColor
//            Cell.layer.shadowRadius = 3.0
//            Cell.layer.shadowOpacity = 2.0
//            Cell.layer.shadowOffset = CGSize(width: 2, height: 4)
//            Cell.layer.masksToBounds = false
//           return MyCell
//       }
       
         func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//
             //let itemsForDate = groupedItems[itemDates[indexPath.section]]!
                    let sectionDay = "Section"
//               let date = section.month
//               let dateFormatter = DateFormatter()
//               dateFormatter.dateFormat = "MMMM yyyy"
//               return dateFormatter.string(from: date)
             return "Section \(sectionDay)"
             
        }
    
//        func sectionIndexTitles(for tableView: UITableView) -> [String]? {
//           return TodateSectionTitles
//       }

}

