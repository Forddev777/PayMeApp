//
//  ViewController.swift
//  PayMeApp
//
//  Created by suriya taothongkom on 28/11/2565 BE.
//

import UIKit
import StickyButton

class ViewController: UIViewController  {


//, ChartViewDelegate
    @IBOutlet weak var Label_ToDate: UILabel!
    
    let date = Date()
    let dateFormatter = DateFormatter()
    let TimeFormatter = DateFormatter()
    @IBOutlet weak var Label_Time: UILabel!
    @IBOutlet weak var View_Grahp: UIView!
    @IBOutlet weak var TableView: UITableView!
//
//    @IBOutlet weak var Label_text: UILabel!
    var Activity_Header = [String:[String]]()
      var TodateSectionTitles = [String]()
      var dataIn_Exs: [String] = []
    
    //
   @IBOutlet weak var Button_action: StickyButton!
    
    
//    var barChart = BarChartView()
    override func viewDidLoad() {
        
        TableView.delegate = self
        TableView.dataSource = self
        super.viewDidLoad()
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
       
        
//        barChart.delegate = self
        
        
        
        
        dataIn_Exs = ["10/11/2022_เงินเดือน",
                      "10/11/2022ลบ_ค่าคอนโด","15/11/2022บวก_เงินโบนัส",
                      "17/11/2022ลบ_โอมากำเสะ พระราม 2",
                      "17/11/2022ลบ_ภาษี","17/11/2022บวก_เงินบันผล","17/11/2022จ่าย_อาหาร 100 บ ",
                      "10/11/2022จ่าย_เที่ยว 777 บ","15/11/2022จ่าย_เที่ยวเกาะ 777 บ"]
             
             for dataIn_Exs in dataIn_Exs {
                 let dataIn_ExsKey = String(dataIn_Exs.prefix(5))
                 if var dataIn_ExsValue = Activity_Header[dataIn_ExsKey] {
                     dataIn_ExsValue.append(dataIn_Exs)
                     Activity_Header[dataIn_ExsKey] = dataIn_ExsValue
                 } else {
                     Activity_Header[dataIn_ExsKey] = [dataIn_Exs]
                 }
             }
             
        TodateSectionTitles = [String](Activity_Header.keys)
        TodateSectionTitles = TodateSectionTitles.sorted(by: {$0 < $1})
    
        Button_action.addItem(title: "เพิ่มรายรับ", icon: UIImage(named: "icon1")){
            item in
            self.present(self.AddINView(forType: "Home"), animated: true, completion: nil)
        }

        Button_action.addItem(title: "รายจ่าย", icon: UIImage(named: "icon2")){
            item in

            
         
    
//            item.addTarget(self, action: #selector(AddNewEx) , for: .touchUpInside)
//
            
            
            self.present(self.AddExView(forType: "EX") , animated: true, completion: nil)

        }
     
      
       
    }
    
    
//
//    @objc func AddNewEx(){
//
//        let story = UIStoryboard(name: "Main_In", bundle: nil)
//        let controller = story.instantiateViewController(withIdentifier: "AddExViewController") as!
//        AddExViewController
//        self.present(controller, animated: true, completion: nil)
//
//    }

    private func AddINView(forType type: String) -> UIViewController {
        let vc = AddINViewController()
        navigationController?.pushViewController(vc, animated: true)
        return vc
  }
    
    private func AddExView(forType type: String) -> UIViewController {
        let vcEX = AddExViewController()
        navigationController?.pushViewController(vcEX, animated: true)
        return vcEX
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
    
   
}

extension ViewController : UITableViewDelegate  , UITableViewDataSource {
    
     func numberOfSections(in tableView: UITableView) -> Int {
           return TodateSectionTitles.count
       }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           let dataIn_ExsKey = TodateSectionTitles[section]
           if let dataIn_ExsValue = Activity_Header[dataIn_ExsKey] {
               return dataIn_ExsValue.count
           }
           return 0
       }

       
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

           let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
           let dataIn_ExsKey = TodateSectionTitles[indexPath.section]
           if let dataIn_ExsValue = Activity_Header[dataIn_ExsKey] {
               
               cell.textLabel?.text = dataIn_ExsValue[indexPath.row]
               
               cell.layer.cornerRadius  =  15
               cell.layer.shadowColor = UIColor.gray.cgColor
               cell.layer.shadowRadius = 3.0
               cell.layer.shadowOpacity = 2.0
               cell.layer.shadowOffset = CGSize(width: 2, height: 4)
               cell.layer.masksToBounds = false
               
               
           }

           return cell
       }
       
       
        func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
           return TodateSectionTitles[section]
       }
       
//        func sectionIndexTitles(for tableView: UITableView) -> [String]? {
//           return TodateSectionTitles
//       }

}

