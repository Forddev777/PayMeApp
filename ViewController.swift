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
//, ChartViewDelegate
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
    var sections = [MonthSection]()
   @IBOutlet weak var Button_action: StickyButton!
//    var barChart = BarChartView()
    
    private func firstDayOfMonth(date: Date) -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: date)
        return calendar.date(from: components)!
    }
    
    struct MonthSection : Comparable  {
        var month: Date
        var headlines: [Model_data]
        static func < (lhs: MonthSection, rhs: MonthSection) -> Bool {
            return lhs.month < rhs.month
        }
        static func == (lhs: MonthSection, rhs: MonthSection) -> Bool {
            return lhs.month == rhs.month
        }
    }
    
    private func parseDate(_ str : String) -> Date {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        return dateFormat.date(from: str)!
    }
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
//        let groups = Dictionary(grouping: self.Model_data_Array) { (Model_data_Array) -> Date  in
//            return firstDayOfMonth(date: Model_data_Array.expenses_Date!)
//        }
//        self.sections  = groups.map(MonthSection.init(month:headlines:)).sorted()
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
    }
    @objc  func configuration(){
        TableView.delegate = self
        TableView.dataSource = self
        Model_data_Array = DatabaseHelper.shared.getAllContacts()
        self.TableView.reloadData()
//        self.TableView.refreshControl?.endRefreshing()
        TableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    private func AddINView(forType type: String) -> UIViewController {
        let vc = AddINViewController()
            vc.callbackSuccess = {
                     self.Model_data_Array = DatabaseHelper.shared.getAllContacts()
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
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
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

    }
    
    override func viewWillAppear(_ animated: Bool){
        self.TableView.reloadData()
    }
    
}

extension ViewController : UITableViewDelegate  , UITableViewDataSource {
            func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//            let dataIn_ExsKey = TodateSectionTitles[section]
//            if let dataIn_ExsValue = Model_data_Array[dataIn_ExsKey] {
//                return dataIn_ExsValue.count
//            }
//             let section = self.sections[section]
////                print(sections)
//             return section.headlines.count
                return Model_data_Array.count
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath) as! MyTableViewCell
                    cell.selectionStyle = .none
                    numberFormatter.numberStyle = .decimal
                    let formattedNumber = numberFormatter.string(from:NSNumber(value: Model_data_Array[indexPath.row].expenses_Salary))
                    cell.number_label?.text = formattedNumber
                    cell.type_header_label?.text = Model_data_Array[indexPath.row].expenses_Type
                    cell.type_text_sta?.text = Model_data_Array[indexPath.row].expenses_text_hidden
                    cell.time_label?.text = dateFormatter.string(from: Model_data_Array[indexPath.row].expenses_Date!)
                            if(cell.type_text_sta?.text == "รายจ่าย"){
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
//     func numberOfSections(in tableView: UITableView) -> Int {
//
//         return Model_data_Array.count
//       }

   
    
      
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
//             let section = self.sections[section]
//               let date = section.month
               let dateFormatter = DateFormatter()
               dateFormatter.dateFormat = "MMMM yyyy"
               return dateFormatter.string(from: date)
        }
    
//        func sectionIndexTitles(for tableView: UITableView) -> [String]? {
//           return TodateSectionTitles
//       }

}

