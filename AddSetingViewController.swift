//
//  AddSetingViewController.swift
//  PayMeApp
//
//  Created by suriya taothongkom on 4/12/2565 BE.
//

import UIKit

class AddSetingViewController: UIViewController , UITextFieldDelegate , UIPickerViewDelegate , UIPickerViewDataSource    {
   
    var Model_data_Array = [Model_Setting]()
    var text_fixld_type: UITextField?
    var data_type: [String] = []
    var Button_Save_Data: UIButton?
    var viewPicker =  UIPickerView()
    var text_fixld_detail: UITextField?{
        didSet { text_fixld_detail?.AddDone_CancelToolbar()}
    }
    override func viewDidLoad() {
        data_type = ["รายรับ", "รายจ่าย"]
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        let label = UILabel(frame: CGRect(x: 0 ,
                                          y: 0.05 * self.view.frame.size.width,
                                          width: self.view.frame.size.width ,
                                          height: 25))
        label.textAlignment = .center
        label.text = "ตั้งค่า"
        label.textColor = .white
        label.font = UIFont(name: "Halvetica", size: 25)
        self.view.addSubview(label)
        text_fixld_type = UITextField.init(frame:(CGRect(x: 15,
                                                                y: self.view.frame.size.height * 0.1,
                                                                width: self.view.frame.size.width * 0.90 ,
                                                                height: self.view.frame.size.height * 0.05)))
        text_fixld_type?.placeholder = "ระบุประเภทที่ต้องการเพิ่มใหม่"
        text_fixld_type?.textColor = .black
        text_fixld_type?.textAlignment = .center
        text_fixld_type?.backgroundColor = .white
        text_fixld_type?.borderStyle = .roundedRect
        text_fixld_type?.inputView = viewPicker
        viewPicker.dataSource = self
        viewPicker.delegate = self
        self.view.addSubview(text_fixld_type!)
        
        text_fixld_detail = UITextField.init(frame:
                                            (CGRect(x: 15,
                                                    y: self.view.frame.size.height * 0.26,
                                                    width: self.view.frame.size.width * 0.90,
                                                    height: self.view.frame.size.height * 0.05)))
        text_fixld_detail?.placeholder = "เพิ่มหัวข้อประเภท - รายรับ/รายจ่าย"
        text_fixld_detail?.textColor = .black
        text_fixld_detail?.textAlignment = .center
        text_fixld_detail?.backgroundColor = .white
        text_fixld_detail?.borderStyle = .roundedRect
        text_fixld_detail?.keyboardType = .default
        text_fixld_detail?.delegate = self
        self.view.addSubview(text_fixld_detail!)
        
        Button_Save_Data = UIButton.init(frame: CGRect(x: 15,
                                                       y: self.view.frame.size.height * 0.58  ,
                                                       width: self.view.frame.size.width * 0.90 ,
                                                       height: self.view.frame.size.height * 0.05))
        Button_Save_Data?.setTitle("บันทึก", for: .normal)
        Button_Save_Data?.backgroundColor = UIColor(red: 0.18, green: 0.77, blue: 0.71, alpha: 1.00)
        Button_Save_Data?.titleLabel?.textAlignment  = .center
        Button_Save_Data?.addTarget(self, action: #selector(save_setting(_:)), for: .touchUpInside)
        self.view.addSubview(Button_Save_Data!)
        
        
}
    
    @IBAction func save_setting(_ sender: UIButton){
        
        if(text_fixld_type?.text != "" && text_fixld_detail?.text != ""  ){
            let set_data_type = text_fixld_type?.text!
            let set_data_detail = text_fixld_detail?.text!
            
            let model_seting = Model_Setting(setting_type: set_data_type ?? ""
                                             , setting_type_in_ex: set_data_detail ?? "")
            self.Model_data_Array.append(model_seting)
            DatabaseHelper.shared.saveSetting(contact: model_seting)
            self.dismiss(animated: true, completion: nil)
            
        }else{
            let alert = UIAlertController(title: "ระบุค่าไม่ครบ", message: "ลองใหม่อีกครั้ง", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "ตกลง", style: UIAlertAction.Style.default , handler: nil))
            self.present(alert, animated: true , completion: nil)
            
        }
        
    
    }
                                    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return  1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        data_type.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        data_type[row]
       }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        text_fixld_type!.text = data_type[row]

    }
    
    
}


