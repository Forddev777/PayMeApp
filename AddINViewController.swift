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
    var text_Income = "รายรับ"
    var callbackSuccess: (() -> ())?
    override func viewDidLoad() {
        data_type_income = ["เงินเดือน", "โบนัส" , "ขายของออนไลน์" , "ปันผลหุ้น", "กองทุน"  , "แผงตลาด" ,  "ขายมะพร้าวประจำเดือน" ]
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.31, green: 0.76, blue: 0.59, alpha: 1.00)
        let label = UILabel(frame: CGRect(x: 0 ,
                                          y: 0.05 * self.view.frame.size.width,
                                          width: self.view.frame.size.width ,
                                          height: 25))
        label.textAlignment = .center
        label.text = "เพิ่มรายการรายรับ"
        label.textColor = .white
        label.font = UIFont(name: "Halvetica", size: 25)
        self.view.addSubview(label)
        
        text_fixld_number = UITextField.init(frame:(CGRect(x: 15,
                                                           y: self.view.frame.size.height * 0.1 ,
                                                           width: self.view.frame.size.width * 0.90 ,
                                                           height: self.view.frame.size.height * 0.05)))
        text_fixld_number?.placeholder = "ระบุเงิน"
        text_fixld_number?.textColor = .black
        text_fixld_number?.textAlignment = .center
        text_fixld_number?.backgroundColor = .white
        text_fixld_number?.borderStyle = .roundedRect
        text_fixld_number?.keyboardType = .numberPad
        text_fixld_number?.delegate = self
        self.view.addSubview(text_fixld_number!)
        text_fixld_type_income = UITextField.init(frame:(CGRect(x: 15,
                                                                y: self.view.frame.size.height * 0.18 ,
                                                                width: self.view.frame.size.width * 0.90 ,
                                                                height: self.view.frame.size.height * 0.05)))
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
                                            (CGRect(x: 15,
                                                    y: self.view.frame.size.height * 0.26,
                                                    width: self.view.frame.size.width * 0.90,
                                                    height: self.view.frame.size.height * 0.2)))
        text_fixld_detail?.placeholder = "รายละเอียดเพิ่มเติม"
        text_fixld_detail?.textColor = .black
        text_fixld_detail?.textAlignment = .center
        text_fixld_detail?.backgroundColor = .white
        text_fixld_detail?.borderStyle = .roundedRect
        text_fixld_detail?.keyboardType = .default
        text_fixld_detail?.delegate = self
        self.view.addSubview(text_fixld_detail!)
        
        text_fixld_date = UITextField.init(frame:(CGRect(x: 15,
                                                         y: self.view.frame.size.height * 0.48 ,
                                                         width: self.view.frame.size.width * 0.90 ,
                                                         height: self.view.frame.size.height * 0.05)))
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
        text_fixld_date?.delegate = self
        self.view.addSubview(text_fixld_date!)
        
        Button_Save_Data = UIButton.init(frame: CGRect(x: 15,
                                                       y: self.view.frame.size.height * 0.58  ,
                                                       width: self.view.frame.size.width * 0.90 ,
                                                       height: self.view.frame.size.height * 0.05))
        Button_Save_Data?.setTitle("บันทึก", for: .normal)
        Button_Save_Data?.backgroundColor = UIColor(red: 0.18, green: 0.77, blue: 0.71, alpha: 1.00)
        Button_Save_Data?.titleLabel?.textAlignment  = .center
        Button_Save_Data?.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        self.view.addSubview(Button_Save_Data!)
    }
    
   
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        
        if(text_fixld_number?.text != "" &&  text_fixld_type_income?.text != "" &&  text_fixld_detail?.text != "" && text_fixld_date?.text != "" ){
            
            
         
            let isoDate = text_fixld_date?.text!
            let dateFormatter = DateFormatter()
              dateFormatter.locale = Locale(identifier: "th") // set locale to reliable US_POSIX
              dateFormatter.dateFormat = "dd MMMM yyyy"
            let date = dateFormatter.date(from:isoDate ?? "")
            let v_Income_number = Int(text_fixld_number?.text! ?? "" ) ?? 0
            let v_Income_Type = text_fixld_type_income?.text!
            let v_Income_Description = text_fixld_detail?.text!
            let v_Income_text_heidden = text_Income
           
         

    
            let model = Model_data(expenses_Salary: v_Income_number,
                                   expenses_Type: v_Income_Type,
                                   expenses_Description: v_Income_Description,
                                   expenses_text_hidden: v_Income_text_heidden,
                                   expenses_Date: date
                                   
                                    )
            self.Model_data_Array.append(model)
            DatabaseHelper.shared.saveContact(contact: model)
            self.callbackSuccess?()
            self.dismiss(animated: true, completion: nil)
            
        }else{
            let alert = UIAlertController(title: "ระบุค่าไม่ครบ", message: "ลองใหม่อีกครั้ง", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "ตกลง", style: UIAlertAction.Style.default , handler: nil))
            self.present(alert, animated: true , completion: nil)
        }
        
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
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        data_type_income[row]
       }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        text_fixld_type_income!.text = data_type_income[row]
        

    }
    
}
