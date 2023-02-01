//
//  ViewController.swift
//  PayMeApp
//
//  Created by suriya taothongkom on 28/11/2565 BE.
//

import UIKit
import StickyButton
import RealmSwift
import Charts
class ViewController: UIViewController , ChartViewDelegate {
    //    weak var axisFormatDelegate: IAxisValueFormatter?
    var Model_data_Array = [Model_data]()
    @IBOutlet weak var Label_ToDate: UILabel!
    let date = Date()
    let dateFormatter = DateFormatter()
    let TimeFormatter = DateFormatter()
    let numberFormatter = NumberFormatter()
    @IBOutlet weak var Label_Time: UILabel!
    

    @IBOutlet weak var PieChart: BarChartView!
    

    // test
    @IBOutlet weak var TableView: UITableView!
    // test
    @IBOutlet weak var View_Header: UIView!
    let MyCellId = "MyTableViewCell"
    //    @IBOutlet weak var Label_text: UILabel!
    var Activity_Header = [Date:[String]]()
    var TodateSectionTitles = [String]()
    var dataIn_Exs: [String] = []
    var date_section: String = ""
    @IBOutlet weak var Button_action: StickyButton!
    
//    var PieChart = PieChartView()
    @IBOutlet weak var SumIncomeLabel: UILabel!
    @IBOutlet weak var SumExpenLabel: UILabel!
    let realm = try! Realm()
    var items: Results<Model_data>?
    var groupedItems = [Date:Results<Model_data>]()
    var itemDates = [Date]()
    var months: [String]!
    var callback: ((String?)->())?
    var SectionDay:  String!
    var PKid: String = ""
    weak var playButton: UIButton!
    override func viewDidLoad() {
      
        configuration()
        SumLabel()
        super.viewDidLoad()
        let SetdataModel =  DatabaseHelper.shared.getAllContacts()
        
        var SumdataModel: [Double] = []
        for ForResultModel in SetdataModel{
            SumdataModel.append(Double(ForResultModel.expenses_Salary))
        }
//        var SumTypelist: [String] = []
//        for ForResultTypelistModel in SetdataModel{
//            SumTypelist.append(ForResultTypelistModel.expenses_SetMonth)
//        }
       
//        let SumTypelist = ["มกราคม" , "กุมภาพัน" , "มีนาคม" , "เมษายน" , "พฤษภาคม"  , "มิิถุนายน" , "กรกฏาคม" , "สิงหาคม" , "กันยายน" , "ตุลาคม" , "พฤศจิกายน" , "ธันวาคม"]
        let SumTypelist2 = ["ม.ค." , "ก.พ." , "มี.ค." , "เม.ย." , "พ.ค."  , "มิ.ย." , "ก.ค." , "ส.ค." , "ก.ย." , "ต.ค." , "พ.ย." , "ธ.ค"]
        let goals = [5, 3,3,7,5,6 ,9 , 8 ,9 ,2, 11, 1]
        let unitsBought = [10.0, 14.0, 60.0, 13.0, 2.0]
        setChart(dataPoints: SumTypelist2, values: goals.map{ Double($0)  })
        print(SumdataModel)
//        print(goals)
//        PieChartView.delegate = self
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
        Button_action.addItem(title: "ตั้งค่าnew", icon: UIImage(systemName: "gearshape")){ [self]
            item in
            self.present(self.SettingNewViewController(forType: "SettingNewViewController"), animated: true, completion: nil)
        }
        // pull to refesh in ios swift //
        //        TableView.refreshControl = UIRefreshControl()
        //        TableView.refreshControl?.addTarget(self, action: #selector(configuration), for: .valueChanged)
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
            let endOfDay =  Calendar.current.date(from: DateComponents(year: Calendar.current.component(.year, from: date), month:                                    Calendar.current.component(.month, from: date), day: Calendar.current.component(.day, from: date), hour: 23, minute: 59, second: 59))!
            results[beginningOfDay] = realm.objects(Model_data.self).filter("expenses_Date >= %@ AND expenses_Date <= %@", beginningOfDay, endOfDay)
        })
    }
    func SumLabel() {
        let getdataIncome =  DatabaseHelper.shared.getAllContacts()
        let getdataExpen = DatabaseHelper.shared.getAllContacts()
        var SumIncome:Int = 0
        var SumExpense:Int = 0
        for ForResultIncome in getdataIncome where ForResultIncome.expenses_text_hidden  != "รายจ่าย"{
            SumIncome += ForResultIncome.expenses_Salary
        }
        for  ForResultExpense  in getdataExpen where ForResultExpense.expenses_text_hidden != "รายรับ" {
            SumExpense += ForResultExpense.expenses_Salary
        }
        SumIncomeLabel.text! = String(SumIncome)
        SumExpenLabel.text! = String(SumExpense)
    }
    @objc  func configuration(){
        TableView.delegate = self
        TableView.dataSource = self
        Model_data_Array = DatabaseHelper.shared.getAllContacts()
        self.TableView.reloadData()
        self.SortDay()
        TableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    private func AddINView(forType type: String) -> UIViewController {
        let vc = AddINViewController()
        vc.callbackSuccess = {
            self.Model_data_Array = DatabaseHelper.shared.getAllContacts()
            self.SortDay()
            self.SumLabel()
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
            self.SumLabel()
            self.TableView.reloadData()
        }
        vcEX.modalPresentationStyle = .pageSheet
        navigationController?.pushViewController(vcEX, animated: true)
        return vcEX
    }
     func SettingNewViewController(forType type: String ) -> UIViewController {
         let NavigationController = UINavigationController()
         let settingview = SettingViewController()
         settingview.callbackSuccess = {
             self.TableView.reloadData()
         }
         settingview.modalPresentationStyle = .fullScreen
         NavigationController.pushViewController(settingview, animated: true)
        return NavigationController

    }
    
       func setChart(dataPoints: [String],  values: [Double] ) {
        var dataEntries: [BarChartDataEntry] = []
        var dataEntries1: [BarChartDataEntry] = []
           
        for i in 0..<dataPoints.count {
          let dataEntry = BarChartDataEntry(
                                            x: Double(i),
                                            y: Double(values[i]) , data: months as AnyObject?)
//            [Double(values[i])]
            dataEntries.append(dataEntry)
            

          
            
//            print(dataPoints)
        
        }
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "dwdw")
        let chartDataSet1 = BarChartDataSet(entries: dataEntries1, label: "Unit Bought")
//        let chartData = BarChartData(dataSet: chartDataSet)
           let dataSets: [BarChartDataSet] = [chartDataSet,chartDataSet1]
           chartDataSet.colors = [UIColor(red: 230/255, green: 126/255, blue: 34/255, alpha: 1)]
           let chartData = BarChartData(dataSets: dataSets)
           
           PieChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: dataPoints)
           PieChart.xAxis.granularityEnabled = true
           PieChart.xAxis.drawGridLinesEnabled = false
           PieChart.xAxis.drawAxisLineEnabled = false
         
        PieChart.xAxis.labelPosition = .bottom
           PieChart.xAxis.labelCount = 30
           PieChart.xAxis.granularity = 1
           PieChart.leftAxis.enabled = true
        PieChart.data = chartData
           PieChart.data = chartData2
        PieChart.center = view.center
           PieChart.backgroundColor = .clear
        PieChart.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)

    }
    
}

extension ViewController : UITableViewDelegate  , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return   itemDates.count // กลุ่มชุดข้อมูล
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupedItems[itemDates[section]]!.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath) as! MyTableViewCell
        cell.selectionStyle = .none
        numberFormatter.numberStyle = .decimal
        let itemsForDate = groupedItems[itemDates[indexPath.section]]!
        SectionDay = dateFormatter.string(from:  Array(itemsForDate.sorted(byKeyPath: "expenses_Date"))[indexPath.row].expenses_Date!)
        cell.time_label?.text = SectionDay.self
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
            let dataDelete = self.Model_data_Array[indexPath.row]
            let alertController = UIAlertController(title: "Default Style", message: "A standard alert.", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
              // do something
            }
            alertController.addAction(cancelAction)
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                let realm = try! Realm()
                try! realm.write {
                    realm.delete(dataDelete)
                }
                self.Model_data_Array.remove(at: indexPath.row)
                self.TableView.deleteRows(at: [indexPath], with: .automatic)
                self.TableView.reloadData()
            }
            alertController.addAction(OKAction)
            self.present( alertController , animated: true )
//            present(alertController, animated: true)
//            print(dataDelete)
          
        }
        deleteAction.backgroundColor = UIColor(red: 1.00, green: 0.00, blue: 0.00, alpha: 1.00)
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let DaySection = SectionDay.self
        if(DaySection != nil ){
            return "\(String(describing: DaySection))"
        }
        
        return ""
        
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
    
}

