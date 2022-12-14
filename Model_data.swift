//
//  Model_data.swift
//  PayMeApp
//
//  Created by suriya taothongkom on 30/11/2565 BE.
//

import Foundation
import RealmSwift



class Model_data: Object  {
    @Persisted var expenses_Salary: Int = 0
    @Persisted var expenses_Type: String?
    @Persisted var expenses_Description: String?
    @Persisted var expenses_text_hidden: String?
    @Persisted var expenses_Date: Date?
    
    convenience init(expenses_Salary: Int, expenses_Type: String? ,  expenses_Description: String? , expenses_text_hidden: String? ,  expenses_Date: Date?){
        self.init()
//        let date = Date()
//        let formatter = DateFormatter()
//        formatter.dateFormat = "dd MMMM yyyy"
//        formatter.locale = Locale(identifier: "th")
        self.expenses_Salary = expenses_Salary
        self.expenses_Type = expenses_Type
        self.expenses_Description = expenses_Description
        self.expenses_text_hidden = expenses_text_hidden
        self.expenses_Date =  expenses_Date
        

    }
}
