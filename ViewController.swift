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
class CellClass: UITableViewCell {
    
}

class ViewController: UIViewController , ChartViewDelegate {
    //    weak var axisFormatDelegate: IAxisValueFormatter?
    var Model_data_Array = [Model_data]()
//    @IBOutlet weak var Label_ToDate: UILabel!
    let date = Date()
    let dateFormatter = DateFormatter()
    let TimeFormatter = DateFormatter()
    let numberFormatter = NumberFormatter()
//    @IBOutlet weak var Label_Time: UILabel!
    
    private let dataSource: NSArray = ["รายสัปดาห์","รายเดือน","รายปี"]
    @IBOutlet weak var ButtonSelect: UIButton!
    @IBOutlet weak var PieChart: BarChartView!
    
    var selectedButton = UIButton()
//    var dataSource = [String]()
    let transparentView = UIView()
    let tableViewSelect = UITableView()
    
  
    
    // test
    @IBOutlet weak var TableView: UITableView!
    // test
    @IBOutlet weak var View_Header: UIView!
    let MyCellId = "MyTableViewCell"
    
    let MyCell2 = "TableViewCell2"
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
        TableView.register(UINib.init(nibName: MyCellId  , bundle: nil), forCellReuseIdentifier: "DefaultCell")
        tableViewSelect.register(UINib.init(nibName: MyCell2  , bundle: nil), forCellReuseIdentifier: "DefaultCell")
        TableView.rowHeight = UITableView.automaticDimension
        TableView.separatorColor = UIColor.clear
        dateFormatter.dateFormat = "dd MMMM yyyy"
        TimeFormatter.dateFormat = "HH:mm"
        dateFormatter.locale = Locale(identifier: "th")
       
        
//        Label_ToDate.text = "\u{00a0}\u{00a0}\(dateFormatter.string(from: date))\u{00a0}\u{00a0}"
//        Label_ToDate.layer.shadowColor = UIColor.gray.cgColor
//        Label_ToDate.layer.shadowRadius = 3.0
//        Label_ToDate.layer.shadowOpacity = 2.0
//        Label_ToDate.layer.shadowOffset = CGSize(width: 1, height: 4)
//        Label_ToDate.layer.masksToBounds = false
        
//        Label_Time.text = "\(TimeFormatter.string(from: date))"
//        Label_Time.layer.shadowColor = UIColor.gray.cgColor
//        Label_Time.layer.shadowRadius = 3.0
//        Label_Time.layer.shadowOpacity = 2.0
//        Label_Time.layer.shadowOffset = CGSize(width: 1, height: 4)
//        Label_Time.layer.masksToBounds = false
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
    func addTransparentView(frames: CGRect) {
           let window = UIApplication.shared.keyWindow
           transparentView.frame = window?.frame ?? self.view.frame
           self.view.addSubview(transparentView)
           
        tableViewSelect.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height , width: frames.width , height: 0)
           self.view.addSubview(tableViewSelect)
        tableViewSelect.layer.cornerRadius = 5
           
           transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        tableViewSelect.reloadData()
           let tapgesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
           transparentView.addGestureRecognizer(tapgesture)
           transparentView.alpha = 0
           UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
               self.transparentView.alpha = 0.5
               self.tableViewSelect.frame = CGRect(x: frames.origin.x + 40, y: frames.origin.y + 40  + frames.height, width: frames.width + 100  , height: CGFloat(self.dataSource.count * 50))
           }, completion: nil)
       }
    
    @IBAction func onClickSelectType(_ sender: Any) {
                selectedButton = ButtonSelect
                addTransparentView(frames: ButtonSelect.frame)
    }
    
    @objc func removeTransparentView() {
            let frames = selectedButton.frame
            UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                self.transparentView.alpha = 0
                self.tableViewSelect.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
            }, completion: nil)
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
    @objc func configuration(){
        TableView.delegate = self
        TableView.dataSource = self
        tableViewSelect.delegate = self
        tableViewSelect.dataSource = self
      
        Model_data_Array = DatabaseHelper.shared.getAllContacts()
        self.TableView.reloadData()
        self.SortDay()
        TableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
//        tableView.register(UINib.init(nibName: CellClass  , bundle: nil), forCellReuseIdentifier: "Cell")
        tableViewSelect.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
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
       func setChart(dataPoints: [String],  values:[Double] , values2: [Double] ) {
        var dataEntries: [BarChartDataEntry] = []
        var dataEntries1: [BarChartDataEntry] = []
        for i in 0..<dataPoints.count {
            
            let dataEntry =  BarChartDataEntry(x: Double(i), y:Double(values[i] ?? 0.0 ))
                dataEntries.append(dataEntry)
            print(values[i])
            
            let dataEntry1 = BarChartDataEntry(x: Double(i) , y: Double(values2[i]) ?? 0.0  )
                dataEntries1.append(dataEntry1)
        }
           let groupSpace = 0.54
           let barSpace = 0.03
           let barWidth = 0.2
           let chartDataSet = BarChartDataSet(entries: dataEntries, label: "รายรับ")
           let chartDataSet1 = BarChartDataSet(entries: dataEntries1, label: "รายจ่าย")
           let dataSets: [BarChartDataSet] = [chartDataSet,chartDataSet1]
               chartDataSet.colors = [UIColor(red: 230/255, green: 126/255, blue: 34/255, alpha: 1)]
           let chartData = BarChartData(dataSets: dataSets)
           chartData.barWidth = barWidth
           chartData.groupBars(fromX: Double(0), groupSpace: groupSpace, barSpace: barSpace)
           PieChart.xAxis.axisMinimum = Double(0)
           PieChart.xAxis.axisMaximum = Double(0) + chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace) * Double(12)  // group count : 2
           chartData.groupBars(fromX: Double(0), groupSpace: groupSpace, barSpace: barSpace)
           PieChart.data = chartData
           let x_Axis = PieChart.xAxis
               x_Axis.valueFormatter = IndexAxisValueFormatter(values:dataPoints)
               x_Axis.centerAxisLabelsEnabled = true
               x_Axis.granularity = 1
           PieChart.xAxis.labelPosition = .bottom
           PieChart.xAxis.granularityEnabled = true
           PieChart.xAxis.drawGridLinesEnabled = false
           PieChart.xAxis.drawAxisLineEnabled = false
           PieChart.xAxis.labelPosition = .bottom
//           PieChart.xAxis.labelCount = 30
           PieChart.xAxis.labelCount = dataPoints.count
           
           PieChart.xAxis.granularity = 1
           PieChart.leftAxis.enabled = true
//           PieChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: dataPoints)
//        PieChart.data = chartData
//        PieChart.center = view.center
          PieChart.backgroundColor = .clear
        PieChart.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
    }
}
extension ViewController : UITableViewDelegate  , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return   itemDates.count  // กลุ่มชุดข้อมูล
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if( tableView ==  tableViewSelect ){
        return   dataSource.count
        }
        return groupedItems[itemDates[section]]!.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(tableView == TableView){
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
            if( cell.type_text_sta?.text  == "รายจ่าย"){
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
            let cell2 = tableViewSelect.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath) as! TableViewCell2
        cell2.TypeSelectLabel?.text = dataSource[indexPath.row] as? String
                   return cell2
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedButton.setTitle(dataSource[indexPath.row] as? String, for: .normal)
             removeTransparentView()
        print("Num: \(indexPath.row)")
        print("Value: \(dataSource[indexPath.row])")
        let SetdataModel =  DatabaseHelper.shared.getAllContacts()
        var SumdataModelIncome: [Double] = []
        for ForResultModelInCome in SetdataModel where ForResultModelInCome.expenses_text_hidden  != "รายจ่าย"  {
            SumdataModelIncome.append(Double(ForResultModelInCome.expenses_Salary))
        }
        var SumdataModelExpensenc: [Double] = []
        for ForResultModelExpen in SetdataModel where ForResultModelExpen.expenses_text_hidden  != "รายรับ" {
            SumdataModelExpensenc.append(Double(ForResultModelExpen.expenses_Salary))
        }
        print(SetdataModel)
        let SumTypelist = ["มกราคม" , "กุมภาพันธ์" , "มีนาคม" , "เมษายน" , "พฤษภาคม"  , "มิิถุนายน" , "กรกฏาคม" , "สิงหาคม" , "กันยายน" , "ตุลาคม" , "พฤศจิกายน" , "ธันวาคม"]
//        let SumTypelist2 = ["ม.ค." , "ก.พ." , "มี.ค." , "เม.ย." , "พ.ค."  , "มิ.ย." , "ก.ค." , "ส.ค." , "ก.ย." , "ต.ค." , "พ.ย." , "ธ.ค"]
//        let SumTypelist2 = ["ม.ค." , "ก.พ." ]
//        let goals = [5, 3,3,7,5,6 ,9 , 8 ,9 ,2, 11, 1]
//        let unitsBought = [3, 3,3,3,3,3 ,5 , 5 ,5 ,5, 5, 5]
        
        var SetResultMonth: [String] = []
        for CheckMonthArray in SetdataModel {
            SetResultMonth.append(CheckMonthArray.expenses_SetMonth)
        }
      let CheckMonthArraySum = Array(Set(SetResultMonth).intersection(Set(SumTypelist)))
         print(CheckMonthArraySum)
      let liveAlbums = indexPath.row
        switch liveAlbums {
        case 0:
            print("ดึงช้อมูลรายสัปหาด์")
            setChart(dataPoints: CheckMonthArraySum, values: SumdataModelIncome.map{ Double($0)} , values2: SumdataModelExpensenc.map{ Double($0)})
        case 1:
            print("ดึงช้อมูลรายเดือน")
            setChart(dataPoints: CheckMonthArraySum, values: SumdataModelIncome.map{ Double($0)} , values2: SumdataModelExpensenc.map{ Double($0)})
        case 2:
            print("ดึงข้อมูลรายปี")
            setChart(dataPoints: CheckMonthArraySum, values: SumdataModelIncome.map{ Double($0)} , values2: SumdataModelExpensenc.map{ Double($0)})
        default:
            print("default ดึงช้อมูลรายเดือน")
            setChart(dataPoints: CheckMonthArraySum, values: SumdataModelIncome.map{ Double($0)} , values2: SumdataModelExpensenc.map{ Double($0)})
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func viewWillAppear(_ animated: Bool){
//        self.TableView.reloadData()
        self.PieChart.reloadInputViews()
    }

   
    
}

