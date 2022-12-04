//
//  AddINViewController.swift
//  PayMeApp
//
//  Created by suriya taothongkom on 28/11/2565 BE.
//

import UIKit
import RealmSwift
class AddINViewController: UIViewController , UITextFieldDelegate , UIPickerViewDelegate , UIPickerViewDataSource  {
  
    
    var Model_data_Array = [Model_data]()
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
    var viewPicker =  UIPickerView()
    var datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.31, green: 0.76, blue: 0.59, alpha: 1.00)
        let label = UILabel(frame: CGRect(x: 0 ,
                                          y: 0.05 * self.view.frame.size.width,
                                          width: self.view.frame.size.width ,
                                          height: 25))
        label.textAlignment = .center
        label.text = "เพิ่มรายการรายรับ"
        label.textColor = .white
        label.font = UIFont(name: "Halvetica", size: 20)
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
        
        Button_Save_Data = UIButton.init(frame: CGRect(x: 14,
                                                       y: 0.80 * self.view.frame.size.width ,
                                                       width: self.view.frame.size.width - 40 ,
                                                       height: 40))
        Button_Save_Data?.setTitle("บันทึก", for: .normal)
        Button_Save_Data?.backgroundColor = UIColor(red: 0.18, green: 0.77, blue: 0.71, alpha: 1.00)
        Button_Save_Data?.titleLabel?.textAlignment  = .center
        Button_Save_Data?.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        self.view.addSubview(Button_Save_Data!)
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        
//            self.dismiss(animated: true, completion: nil)
//        }else{
//            let alert = UIAlertController(title: "ระบุค่าไม่ครบ", message: "ลองใหม่อีกครั้ง", preferredStyle: UIAlertController.Style.alert)
//                alert.addAction(UIAlertAction(title: "ตกลง", style: UIAlertAction.Style.default, handler: nil))
//                self.present(alert, animated: true, completion: nil)
//        }
//
       
    }
    
    @objc func dateChange(datePicker: UIDatePicker)
        {
            text_fixld_date?.text = formatDate(date: datePicker.date)
        }

        func formatDate(date: Date) -> String
        {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMMM yyyy"
            formatter.locale = Locale(identifier: "th")
            return formatter.string(from: date)
        }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        data_type_income.count
    }
    
    
}
