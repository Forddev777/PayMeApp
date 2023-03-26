import UIKit
import StickyButton
import RealmSwift
import Charts
import Fastis
class ViewController: UIViewController , ChartViewDelegate {
    var Model_data_Array =  [Model_data]()
    //    @IBOutlet weak var Label_ToDate: UILabel!
    let date = Date()
    let dateFormatter = DateFormatter()
    let TimeFormatter = DateFormatter()
    let numberFormatter = NumberFormatter()
    //    @IBOutlet weak var Label_Time: UILabel!
    private let dataSource: NSArray = ["รายวัน","กำหนด"]
    //    @IBOutlet weak var ButtonSelect: UIButton!
    @IBOutlet weak var PieChart: BarChartView!
    @IBOutlet weak var BoundView: UIView!
    @IBOutlet weak var buttonDate: UIButton!
    @IBOutlet weak var Labeldaytext: UILabel!
    @IBOutlet weak var ViewDayWeek: UIView!
    var selectedButton = UIButton()
    let transparentView = UIView()
    let tableViewSelect = UITableView()
    lazy var currentDateLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    @IBOutlet weak var segmentControlOutlet: UISegmentedControl!
    @IBOutlet weak var TableView: UITableView!
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
//    @IBOutlet weak var SumIncomeLabel: UILabel!
//    @IBOutlet weak var SumExpenLabel: UILabel!
    let realm = try! Realm()
    var items: Results<Model_data>?
    var groupedItems = [Date:Results<Model_data>]()
    var itemDates = [Date]()
    var months: [String]!
    var callback: ((String?)->())?
    var SectionDay:  String!
    var PKid: String = ""
    weak var playButton: UIButton!
    let SetdataModel =  DatabaseHelper.shared.getAllContacts()
    var SelectVauleSinger: [String]! = []
    var SumdataIncome_Salary: [Double] =  []
    var SumdataExpenses_Salary: [Double] = []
    var callbackSuccess: (() -> ())?
    let SumTypelist = ["มกราคม" , "กุมภาพันธ์" , "มีนาคม" , "เมษายน" , "พฤษภาคม"  , "มิิถุนายน" , "กรกฏาคม" , "สิงหาคม" , "กันยายน" , "ตุลาคม" , "พฤศจิกายน" , "ธันวาคม"]
    
    var CurrenArray: [String] = []
    
    let formatter3 = DateFormatter()

    var item:Model_data?
    
    override func viewDidLoad() {
        configuration()
//        SumLabel()
//        print("testtest \(self.ModeldataArrayToDate)")
        super.viewDidLoad()
        TableView.register(UINib.init(nibName: MyCellId  , bundle: nil), forCellReuseIdentifier: "DefaultCell")
        tableViewSelect.register(UINib.init(nibName: MyCell2  , bundle: nil), forCellReuseIdentifier: "DefaultCell")
        TableView.rowHeight = UITableView.automaticDimension
        TableView.separatorColor = UIColor.clear
        dateFormatter.dateFormat = "dd MMMM yyyy"
        TimeFormatter.dateFormat = "HH:mm"
        dateFormatter.locale = Locale(identifier: "th")
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
    }
    var currentValue: FastisValue? {
        didSet {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMM yy"
            formatter.locale = Locale(identifier: "th")
            if let rangeValue = self.currentValue as? FastisRange {
                self.currentDateLabel.text = formatter.string(from: rangeValue.fromDate) + " - " + formatter.string(from: rangeValue.toDate)
                Labeldaytext.text  =  self.currentDateLabel.text
            } else if let dateValue = self.currentValue as? Date {
                self.currentDateLabel.text  = formatter.string(from: dateValue  )
                self.Labeldaytext.text  =  self.currentDateLabel.text
            } else {
                self.currentDateLabel.text = "Choose a date"
            }
        }
    }
    func chooseDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        formatter.timeZone = TimeZone(abbreviation: "THA")
        let formatter2 = DateFormatter()
        formatter2.dateFormat = "d MMMM yyyy"
        formatter2.timeZone = TimeZone(abbreviation: "THA")
        let fastisController = FastisController(mode: .single)
        fastisController.initialValue = Date()
        fastisController.maximumDate = Calendar.current.date(byAdding: .day, value: 0, to: Date())
        fastisController.doneHandler = { dateValue in
        let montSigerValue =   formatter.string(from: dateValue! )
        self.Labeldaytext.text =  formatter2.string(from: dateValue! )
            let dateselect   = self.formatter3.string(from: dateValue! )
        self.SelectVauleSinger.append(String(montSigerValue))
        var SumIncomeSalarySingerVaule:Int = 0
        var SumExpenseSalarySingerVaule:Int = 0
            for ForReSultIncomeSalary in  self.SetdataModel  where  ForReSultIncomeSalary.expenses_text_hidden != "รายจ่าย"  {
                if (self.formatter3.string(from:ForReSultIncomeSalary.expenses_Date!) == dateselect ) {
                    SumIncomeSalarySingerVaule +=  ForReSultIncomeSalary.expenses_Salary
                }
            }
            for ForReSultExpensesSalary in  self.SetdataModel  where  ForReSultExpensesSalary.expenses_text_hidden != "รายรับ"  {
                if (self.formatter3.string(from:ForReSultExpensesSalary.expenses_Date!) == dateselect ) {
                   SumExpenseSalarySingerVaule += ForReSultExpensesSalary.expenses_Salary
                }
            }
            self.setChart(dataPoints: self.SelectVauleSinger , valuesInSalary: [Double(SumIncomeSalarySingerVaule)] ,
                          valuesExSalary: [Double(SumExpenseSalarySingerVaule)] )
        }
            fastisController.present(above: self)
    }
    func chooseRange() {
        let fastisController = FastisController(mode: .range)
        fastisController.minimumDate = Calendar.current.date(byAdding: .yearForWeekOfYear , value: -1, to: Date())
        fastisController.maximumDate = Calendar.current.date(byAdding: .month , value: 0, to: Date())
        fastisController.doneHandler = { newDate in
            self.currentValue = newDate
        }
        fastisController.present(above: self)
    }
    @IBAction func segmentControllClick(_ sender: Any) {
        switch segmentControlOutlet.selectedSegmentIndex {
                case 0:
                    BoundView.backgroundColor = .orange
                    PieChart.layer.cornerRadius = 15
                    ViewDayWeek.layer.cornerRadius = 15
                    print("sec0")
                case 1 :
                    BoundView.backgroundColor = .orange
                    PieChart.layer.cornerRadius = 15
                    ViewDayWeek.layer.cornerRadius = 15
                    print("sec1")
                default:
                   break
                }
    }
    @IBAction func ActBtnDate(_ sender: Any) {
        if(segmentControlOutlet.selectedSegmentIndex == 0 ){
            chooseDate()
            print("aaa")
        }else{
            chooseRange()
        }
    }
    func SortDay(){
        let items = DatabaseHelper.shared.getAllContacts()
        itemDates = items.reduce(into: [Date](), { results, currentItem in
            let date = currentItem.expenses_Date!
            let beginningOfDay = Calendar.current.date(from: DateComponents(year: Calendar.current.component(.year, from: date), month:                  Calendar.current.component(.month, from: date), day: Calendar.current.component(.day, from: date), hour: 0, minute: 0, second: 0))!
            let endOfDay = Calendar.current.date(from: DateComponents(year: Calendar.current.component(.year, from: date), month: Calendar.current.component(.month, from: date), day: Calendar.current.component(.day, from: date), hour: 23, minute: 59, second: 59))!
            if !results.contains(where: { addedDate->Bool in
                return addedDate >= beginningOfDay && addedDate <= endOfDay
            }) {
                results.append(beginningOfDay)
            }
        })
        groupedItems = itemDates.reduce(into: [Date:Results<Model_data>](),
                                        { results, date in
            let beginningOfDay = Calendar.current.date(from: DateComponents(year: Calendar.current.component(.year, from: date), month:                                          Calendar.current.component(.month, from: date), day: Calendar.current.component(.day, from: date), hour: 0, minute: 0, second: 0))!
            let endOfDay =  Calendar.current.date(from: DateComponents(year: Calendar.current.component(.year, from: date), month:                                    Calendar.current.component(.month, from: date), day: Calendar.current.component(.day, from: date), hour: 23, minute: 59, second: 59))!
            results[beginningOfDay] = realm.objects(Model_data.self).filter("expenses_Date >= %@ AND expenses_Date <= %@", beginningOfDay, endOfDay)
        })
    }
    
//    func SumLabel() {
//        let getdataIncome =  DatabaseHelper.shared.getAllContacts()
//        let getdataExpen = DatabaseHelper.shared.getAllContacts()
//        var SumIncome:Int = 0
//        var SumExpense:Int = 0
//        for ForResultIncome in getdataIncome where ForResultIncome.expenses_text_hidden  != "รายจ่าย"{
//            SumIncome += ForResultIncome.expenses_Salary
//        }
//        for  ForResultExpense  in getdataExpen where ForResultExpense.expenses_text_hidden != "รายรับ" {
//            SumExpense += ForResultExpense.expenses_Salary
//        }
//        SumIncomeLabel.text! = String(SumIncome)
//        SumExpenLabel.text! = String(SumExpense)
//    }
    @objc func configuration(){
        TableView.delegate = self
        TableView.dataSource = self
        tableViewSelect.delegate = self
        tableViewSelect.dataSource = self
        self.SortDay()
        self.ChartApiRequst()
        self.Model_data_Array = DatabaseHelper.shared.getAllContacts()
        self.TableView.reloadData()
        print(self.Model_data_Array)
        TableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableViewSelect.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
    }
    
    @objc func ChartApiRequst(){
        var SumDateIncomeChart = Int()
        var SumDateExpenseChart = Int()
        var CurrenMonth:String
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateNew = dateFormatter.string(from: Date())
        let dateFormatterMonth = DateFormatter()
        dateFormatterMonth.dateFormat = "MMMM"
        CurrenMonth = dateFormatterMonth.string(from: Date())
        let formatter3 = DateFormatter()
        formatter3.dateFormat = "yyyy-MM-dd"
        formatter3.timeZone = TimeZone(abbreviation: "THA")
        for ForReSultIncomeSalary in  self.SetdataModel
        where  ForReSultIncomeSalary.expenses_text_hidden != "รายจ่าย" && formatter3.string(from:ForReSultIncomeSalary.expenses_Date!) == dateNew {
            SumDateIncomeChart +=  ForReSultIncomeSalary.expenses_Salary
        }
        for ForReSultExpensesSalary in  self.SetdataModel
        where  ForReSultExpensesSalary.expenses_text_hidden != "รายรับ" && formatter3.string(from:ForReSultExpensesSalary.expenses_Date!) == dateNew   {
               SumDateExpenseChart += ForReSultExpensesSalary.expenses_Salary
        }
//        self.callbackSuccess = {
            self.setChart(dataPoints: [CurrenMonth],
                          valuesInSalary: [Double(SumDateIncomeChart)],
                          valuesExSalary: [Double(SumDateExpenseChart)] )
            
//        }
        print(self.setChart(dataPoints: [CurrenMonth], valuesInSalary: [Double(SumDateIncomeChart)], valuesExSalary: [Double(SumDateExpenseChart)]))
    }
    
    private func AddINView(forType type: String) -> UIViewController {
        let vc = AddINViewController()
        vc.callbackSuccess = {
            self.Model_data_Array = DatabaseHelper.shared.getAllContacts()
            self.SortDay()
            self.ChartApiRequst()
//            self.SumLabel()
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
            self.ChartApiRequst()
//            self.SumLabel()
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
             self.ChartApiRequst()
         }
         settingview.modalPresentationStyle = .fullScreen
         NavigationController.pushViewController(settingview, animated: true)
        return NavigationController
    }
    func setChart(dataPoints: [String],  valuesInSalary:[Double]  , valuesExSalary: [Double] ) {
        var dataEntries: [BarChartDataEntry] = []
        var dataEntries1: [BarChartDataEntry] = []
//        for i in 0..<dataPoints.count {
//            let dataEntry =  BarChartDataEntry(x: Double(i), y:Double(valuesInSalary[i]))
//                    dataEntries.append(dataEntry)
//            let dataEntry1 = BarChartDataEntry(x: Double(i) , y: Double(valuesExSalary[i]))
//                       dataEntries1.append(dataEntry1)
//        }
    
        for dataChart in  0..<dataPoints.count{
//            let newMonth   =  Array(Set(arrayLiteral: dataChart).intersection(Set(SumTypelist)))
//            print(newMonth)
            
            let dataEntry =  BarChartDataEntry(x: Double(dataChart), y:Double(valuesInSalary[0]))
                              dataEntries.append(dataEntry)
            let dataEntry1 = BarChartDataEntry(x: Double(dataChart) , y: Double(valuesExSalary[0]))
                                  dataEntries1.append(dataEntry1)
        }
           let groupSpace = 0.54
           let barSpace = 0.03
           let barWidth = 0.3
           let chartDataSet = BarChartDataSet(entries: dataEntries, label: "รายรับ")
           let chartDataSet1 = BarChartDataSet(entries: dataEntries1, label: "รายจ่าย")
           let dataSets: [BarChartDataSet] = [chartDataSet,chartDataSet1]
               chartDataSet.colors = [UIColor(red: 0.31, green: 0.76, blue: 0.59, alpha: 1.00)]
                chartDataSet1.colors = [UIColor(red: 1.00, green: 0.26, blue: 0.26, alpha: 1.00)]
           let chartData = BarChartData(dataSets: dataSets)
            chartData.barWidth = barWidth
            chartData.groupBars(fromX: Double(0), groupSpace: groupSpace, barSpace: barSpace)
            PieChart.xAxis.axisMinimum = Double(0)
            PieChart.xAxis.axisMaximum = Double(0) + chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace) * Double(1)  // group count : 1
            chartData.groupBars(fromX: Double(0), groupSpace: groupSpace, barSpace: barSpace)
            PieChart.data = chartData
            PieChart.xAxis.valueFormatter = IndexAxisValueFormatter(values:dataPoints)
            PieChart.xAxis.centerAxisLabelsEnabled = true
            PieChart.xAxis.granularity = 1
            PieChart.xAxis.labelPosition = .bottom
            PieChart.xAxis.granularityEnabled = true  //ความล่ะเอียด
            PieChart.xAxis.drawGridLinesEnabled = false //วาดเส้น
            PieChart.xAxis.drawAxisLineEnabled = false
            PieChart.xAxis.labelCount = dataPoints.count
            PieChart.xAxis.granularity = 5
            PieChart.doubleTapToZoomEnabled = false
            PieChart.pinchZoomEnabled = false
            PieChart.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
//        let xAxis = PieChart.xAxis
//           xAxis.drawGridLinesEnabled = true
//           xAxis.labelPosition = .topInside
//           xAxis.labelRotationAngle = 0
//           xAxis.labelTextColor = .darkGray
//           xAxis.granularity = 5
//           xAxis.axisLineWidth = 0
//        xAxis.labelCount = 12
//        xAxis.granularityEnabled = true
//        xAxis.valueFormatter = IndexAxisValueFormatter(values:dataPoints)
//        xAxis.labelRotationAngle = 0
//        xAxis.gridColor = .clear
        //leftAxis ซ้ายแกน Y
           let yAxis = PieChart.leftAxis
           yAxis.drawGridLinesEnabled = false
           yAxis.axisMinimum = 0
//           yAxis.axisMaximum = Double(0) + chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace) * Double(3)
           yAxis.axisLineWidth = 0
           yAxis.labelTextColor = .clear
           yAxis.drawLabelsEnabled = true
           yAxis.labelPosition = .outsideChart
        //rightAxis ขวาแกน Y
           let dAxis = PieChart.rightAxis
           dAxis.drawGridLinesEnabled = false
           dAxis.axisMinimum = 0
//           dAxis.axisMaximum = Double(0) + chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace) * Double(3)
           dAxis.axisLineWidth = 0
           dAxis.labelTextColor = .clear
           dAxis.drawLabelsEnabled = true
           dAxis.labelPosition = .outsideChart
    }
}
extension ViewController : UITableViewDelegate  , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
//        return   itemDates.count
        return itemDates.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if( tableView ==  tableViewSelect ){
            
            print(dataSource)
        return   dataSource.count
        }
        return groupedItems[itemDates[section]]!.count
//        return   dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(tableView == TableView){
            let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath) as! MyTableViewCell
            cell.selectionStyle = .none
            numberFormatter.numberStyle = .decimal
            let itemsForDate = groupedItems[itemDates[indexPath.section]]!
            SectionDay = dateFormatter.string(from:  Array(itemsForDate.sorted(byKeyPath: "expenses_Date"))[indexPath.row].expenses_Date!)
            cell.time_label?.text = self.SectionDay
            cell.type_header_label?.text = Array(itemsForDate.sorted(byKeyPath: "expenses_Date"))[indexPath.row].expenses_Type
            let formattedNumber = numberFormatter.string(from:NSNumber(value: Array(itemsForDate.sorted(byKeyPath: "expenses_Date"))[indexPath.row].expenses_Salary))
            cell.number_label?.text = formattedNumber
            cell.type_text_sta?.text =  Array(itemsForDate.sorted(byKeyPath: "expenses_Date"))[indexPath.row].expenses_text_hidden
        
//            formatter3.dateFormat = "yyyy-MM-dd"
//            formatter3.timeZone = TimeZone(abbreviation: "THA")
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd"
//            let DateNow = dateFormatter.string(from: Date())
//            for ResultDateToday in self.ModeldataArrayToDate  where  formatter3.string(from:ResultDateToday.expenses_Date!) == DateNow {
//                //                 print(ResultDateToday)
//                //                print(self.ModeldataArrayToDate)
//                cell.time_label?.text = dateFormatter.string(from: ResultDateToday.expenses_Date!)
//                cell.type_header_label?.text = ResultDateToday.expenses_text_hidden
//                cell.number_label?.text =  numberFormatter.string(from:NSNumber(value:(ResultDateToday.expenses_Salary)))
//                cell.type_text_sta?.text = ResultDateToday.expenses_text_hidden
//                print("text")
//            }
//            cell.time_label?.text = "test"
//            cell.type_header_label?.text = "dede"
//            cell.number_label?.text =  "dedeed"
//            cell.type_text_sta?.text = "dedede"
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
//            let dataDelete = self.Model_data_Array[indexPath.row]
            let alertController = UIAlertController(title: "Default Style", message: "A standard alert.", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
              // do something
            }
            alertController.addAction(cancelAction)
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                let realm = try! Realm()
                if let item = self.items?[indexPath.row] {
                                do {
                                    try realm.write {
                                        realm.delete(item)
                                    }
                                } catch {
                                    print("Error deleting item, \(error)")
                                }
                                self.TableView.reloadData()
                            
                        }
                self.TableView.deleteRows(at: [indexPath], with: .automatic)
                self.TableView.endUpdates()
                self.ChartApiRequst()
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
//        let DaySection = SectionDay.self
//
//        if(DaySection != nil ){
        return "\(String(describing: ""))"
//        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Num: \(indexPath.row)")
        print("Value: \(dataSource[indexPath.row])")
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    override func viewWillAppear(_ animated: Bool){
//        self.callbackSuccess?()
        self.PieChart.reloadInputViews()
        self.TableView.reloadData()
        self.ChartApiRequst()
       
     
    }

}


