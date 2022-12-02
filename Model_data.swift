//
//  Model_data.swift
//  PayMeApp
//
//  Created by suriya taothongkom on 30/11/2565 BE.
//

import Foundation
import RealmSwift



class Model_data: Object  {
    @objc dynamic var expenses_Salary: Int = 0
//    @objc dynamic var expenses_Salary.value = RealmProperty<Int?>()
    @objc dynamic var expenses_Type: String?
    @objc dynamic var expenses_Description: String?
    @objc dynamic var expenses_Date: Date? = nil
    
    convenience init(expenses_Salary: Int, expenses_Type: String? ,  expenses_Description: String? , expenses_Date:Date? ){
        self.init()
        self.expenses_Salary = expenses_Salary
        self.expenses_Type = expenses_Type
        self.expenses_Description = expenses_Description
        self.expenses_Date = expenses_Date
        
    }

    
    
//    dynamic var  expenses_Salary =  RealmProperty<Int?>()
//    dynamic var  expenses_Type: String? = ""
//
//    dynamic var  expenses_Description: String? = ""
//
//    dynamic var  expenses_Date: Date? =  nil
//
//
//
//
//   convenience init(expenses_Salary:  Int? ,  expenses_Type: String? , expenses_Description: String? , expenses_Date: Date?  ){
//       self.init()
//       self.expenses_Salary.value = expenses_Salary
//        self.expenses_Type = expenses_Type
//        self.expenses_Description = expenses_Description
//        self.expenses_Date = expenses_Date
//    }
//
//
//
//    func expeses_Salary() -> String? {
//        guard let expenses_Salary = expenses_Salary.value else { return nil }
//        return String(expenses_Salary)
//    }

}
