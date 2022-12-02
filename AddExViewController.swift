//
//  AddExViewController.swift
//  PayMeApp
//
//  Created by suriya taothongkom on 28/11/2565 BE.
//

import UIKit
import MobileCoreServices
import RealmSwift


class AddExViewController: UIViewController  , UITextFieldDelegate  , UIPickerViewDelegate  , UIPickerViewDataSource  {
//   
//    let realm = RealmService.shared.realm
//    let add_Income_number   = realm.objects(add_Income_number.self )
//    

    let realm = try! Realm()
    var data_type_income: [String] = []
    var text_fixld_type_income: UITextField?
    
    
    
    var Button_Save_Data: UIButton?
    
    
    var text_fixld_date: UITextField?{
        didSet { text_fixld_date?.AddDone_CancelToolbar()}
    }

    var text_fixld_number: UITextField?{
        didSet { text_fixld_number?.AddDone_CancelToolbar()}
    }
    var text_fixld_detail: UITextField?{
        didSet { text_fixld_detail?.AddDone_CancelToolbar()}
    }
//
    var viewPicker =  UIPickerView()
    var datePicker = UIDatePicker()
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
       
       
    

        
            data_type_income = ["เงินเดือน", "โบนัส" , "เงินเก็บ" , "เงินได้จากขายเสื้อ", "เงินได้จากขายอาหารเสริม " ]
            view.backgroundColor = UIColor(red: 1.00, green: 0.26, blue: 0.26, alpha: 1.00)
            let label = UILabel(frame: CGRect(x: 0 ,
                                              y: 0.05 * self.view.frame.size.width,
                                              width: self.view.frame.size.width ,
                                              height: 25))
            label.textAlignment = .center
            label.text = "เพิ่มรายการรายจ่าย"
            label.backgroundColor = .brown
            label.textColor = .white
            label.font = UIFont(name: "Halvetica", size: 17)
            self.view.addSubview(label)
            
            text_fixld_number = UITextField.init(frame:(CGRect(x: 14,
                                                               y: 0.15 * self.view.frame.size.width,
                                                               width: self.view.frame.size.width - 40  ,
                                                               height: 40)))
            text_fixld_number?.placeholder = "ระบุเงิน"
            text_fixld_number?.textColor = .black
            text_fixld_number?.textAlignment = .center
            text_fixld_number?.backgroundColor = .white
            text_fixld_number?.borderStyle = .roundedRect
            text_fixld_number?.keyboardType = .numberPad
            text_fixld_number?.delegate = self
            self.view.addSubview(text_fixld_number!)
        
            text_fixld_type_income = UITextField.init(frame:(CGRect(x: 14,
                                                                    y: 0.30 * self.view.frame.size.width ,
                                                                    width: self.view.frame.size.width - 40 ,
                                                                    height: 40)))
            text_fixld_type_income?.placeholder = "ระบุประเภทเงินเดือน"
            text_fixld_type_income?.textColor = .black
            text_fixld_type_income?.textAlignment = .center
            text_fixld_type_income?.backgroundColor = .white
            text_fixld_type_income?.borderStyle = .roundedRect
            text_fixld_type_income?.inputView = viewPicker
            viewPicker.dataSource = self
            viewPicker.delegate = self
            self.view.addSubview(text_fixld_type_income!)
        
            text_fixld_detail = UITextField.init(frame:
                                                (CGRect(x: 14,
                                                        y: 0.45 * self.view.frame.size.width,
                                                        width: self.view.frame.size.width - 40  ,
                                                        height: 60)))
            text_fixld_detail?.placeholder = "รายละเอียดเพิ่มเติม"
            text_fixld_detail?.textColor = .black
            text_fixld_detail?.textAlignment = .center
            text_fixld_detail?.backgroundColor = .white
            text_fixld_detail?.borderStyle = .roundedRect
            text_fixld_detail?.keyboardType = .default
            text_fixld_detail?.delegate = self
            self.view.addSubview(text_fixld_detail!)
            
        
            text_fixld_date = UITextField.init(frame:(CGRect(x: 14,
                                                             y: 0.65 * self.view.frame.size.width ,
                                                             width: self.view.frame.size.width - 40 ,
                                                             height: 40)))
            text_fixld_date?.text = formatDate(date: Date()) // todays Date
            datePicker.addTarget(self, action: #selector(dateChange(datePicker:)), for: UIControl.Event.valueChanged)
            text_fixld_date?.textColor = .black
            text_fixld_date?.textAlignment = .center
            text_fixld_date?.backgroundColor = .white
            text_fixld_date?.borderStyle = .roundedRect
            text_fixld_date?.inputView = datePicker
            datePicker.datePickerMode = .date
            datePicker.preferredDatePickerStyle = .wheels
            datePicker.maximumDate = Date()
            self.view.addSubview(text_fixld_date!)
        
      
     
        
//        let labelButton = UILabel(frame: CGRect(x: 14 ,
//                                          y: 0.80 * self.view.frame.size.width,
//                                          width: self.view.frame.size.width  - 40 ,
//                                          height: 40))
//        labelButton.textAlignment = .center
//        labelButton.text = "เพิ่มรายการรายจ่าย"
//        labelButton.textColor = .white
//        labelButton.font = UIFont(name: "Halvetica", size: 17)
//        self.view.addSubview(labelButton)
        
        Button_Save_Data = UIButton.init(frame: CGRect(x: 14,
                                                       y: 0.80 * self.view.frame.size.width ,
                                                       width: self.view.frame.size.width - 40 ,
                                                       height: 40))
        Button_Save_Data?.setTitle("บันทึก", for: .normal)

        Button_Save_Data?.backgroundColor = UIColor(red: 0.31, green: 0.76, blue: 0.59, alpha: 1.00)
        Button_Save_Data?.titleLabel?.textAlignment  = .center
        Button_Save_Data?.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        self.view.addSubview(Button_Save_Data!)
    
        
    
       
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        if( text_fixld_type_income?.text != "" &&  text_fixld_detail?.text != "" &&  text_fixld_date?.text != "" ){
            
                let model =  Model_data()
                model.expenses_Salary =   99999
                model.expenses_Type = text_fixld_type_income?.text!
                model.expenses_Description =  text_fixld_detail?.text!
                model.expenses_Date =  Date()
            
           
                 try! realm.write{
                     realm.add(model)
                     
                     print(Realm.Configuration.defaultConfiguration.fileURL )
                     
                     print(model.expenses_Salary)
                     print(model.expenses_Type)
                     print(model.expenses_Description)
                     print(model.expenses_Date)
                 }

        
            
          
            
//            let ac = UIAlertController(title: "Add Note", message: nil, preferredStyle: .alert)
//
//                   ac.addTextField(configurationHandler: .none)
//
//                   ac.addAction(UIAlertAction(title: "Add", style: .default, handler: { (UIAlertAction) in
//                         if  text_fixld_number.text  = ac.textFields?.first?.text
//                       {
//                           print(text_fixld_number!)
//                       }
//
//                   }))
//                   ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//                   present(ac, animated: true, completion: nil)
            
//            let action = UIAlertAction(title: "Add Success ", style: .default ) {
//                (_) in
//                guard let text_num = text_fixld_number?.first?.text,
//                      let text_type = text_fixld_type_income?[1].text,
//                      let text_detail = text_fixld_detail?[2].text,
//                      let text_date = text_fixld_date?.last?.text
//                else { return}
//
//                completeion(text_num ,  text_type , text_detail , text_date  )
//
//
//            }
        }else{
            
            let alert = UIAlertController(title: "ระบุค่าไม่ครบ", message: "ลองใหม่อีกครั้ง", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "ตกลง", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
        }
            
    }
    
    
    func save(completion: (_ finished: Bool ) -> ()){
        
        
    }
    
    @objc func dateChange(datePicker: UIDatePicker)
        {
            text_fixld_date?.text = formatDate(date: datePicker.date)
        }

        func formatDate(date: Date) -> String
        {
            let formatter = DateFormatter()
//            formatter.dateFormat = "MMMM dd yyyy "
            formatter.dateFormat = "dd MMMM yyyy"
            formatter.locale = Locale(identifier: "th")
            return formatter.string(from: date)
        }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
        
    }
//    @objc func textFieldDidChange(_ textField: UITextField) {
//        return
//    }

    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        data_type_income.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        data_type_income[row]
       }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        text_fixld_type_income!.text = data_type_income[row]
        

    }
   
}

//
//extension ViewController :   UIPickerViewDelegate , UIPickerViewDataSource {
//
//
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        1
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//           data_type_income.count
//
//
//    }
//
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//         data_type_income[row]
//    }
//
//}

extension UITextField  {
    
   
    func AddDone_CancelToolbar(onDone: (target: Any , action: Selector)? = nil , onCancel: (target: Any , action: Selector)? = nil ){
        
        let onCancel = onCancel ?? (target: self, action: #selector(cancelButtonTapped))
        let onDone = onDone ?? (target: self, action: #selector(doneButtonTapped))
        
        let toolbar : UIToolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.items = [
            UIBarButtonItem(title: "Cancel", style: .plain, target: onCancel.target, action: onCancel.action),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: onDone.target, action: onDone.action)
        ]
        toolbar.sizeToFit()
        self.inputAccessoryView = toolbar
        
    }
    
    @objc func cancelButtonTapped() {
        self.resignFirstResponder()
        
        
    }
    
    @objc func doneButtonTapped() { self.resignFirstResponder()}
    
}
