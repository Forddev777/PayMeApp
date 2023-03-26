//
//  DatabaseHelper.swift
//  PayMeApp
//
//  Created by suriya taothongkom on 2/12/2565 BE.
//

import Foundation
import RealmSwift



class DatabaseHelper{
        static let shared = DatabaseHelper()
        private var realm = try! Realm()
    var filteredDate : Date?
    
    let beginningOfDay = Date()
    func getDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let newgetdate = dateFormatter.string(from: beginningOfDay)
        let Mynewdate = dateFormatter.date(from:newgetdate)!
        
        return  Mynewdate
    }
    
//    let MeDate =  Date()
    
//    let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
//    let dateme = dateFormatter.date(from:stringDate)!
    
    
    
//    func formatDate(date: Date) -> String{
//            let formatter = DateFormatter()
//                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
//                formatter.locale = Locale(identifier: "th_TH")
//        return  formatter.string(from: beginningOfDay)
//    }
   
    func  getDatabasePath() -> URL?{
        return Realm.Configuration.defaultConfiguration.fileURL
    }
    
    func saveContact(contact: Model_data ){
        try! realm.write({
            realm.add(contact)
            
        })
    }
    func saveSetting(contact: Model_Setting ){
        try! realm.write({
            realm.add(contact)
        
        })
    }
//    func updateContact(oldContact: Model_data, newContact: Model_data )
//     {
//         try! realm.write{
//         oldContact.expenses_Salary = newContact.first
///         oldContact.lastname = newContact.lastname
//         }
//    }
//    2022-12-28T06:43:40.000Z
//        .filter("expenses_Date == %@", )
    func deleteContact(contact: Model_data ){
        try! realm.write{
            realm.delete(contact)}
    }
    
    func getAllContacts() -> [Model_data] {
        return Array(realm.objects(Model_data.self)
                    .sorted(byKeyPath: "expenses_Date", ascending: false )
//            .filter("expenses_Date == 2023-03-15T05:39:03.000Z"){
            .filter("expenses_Date >= %@", getDate() ?? Date() )
            
        )
    }
   
    func getAllExTyper() -> [Model_Setting] {
        return Array(realm.objects(Model_Setting.self).where {
                $0.setting_type == "รายจ่าย"})
    }
    
     func getAllModelSetting() -> [Model_Setting] {
         return Array(realm.objects(Model_Setting.self))
     }
    
     func getAllModeldata() -> [Model_data] {
         return Array(realm.objects(Model_data.self))
     }
    
    func getAllInTyper() -> [Model_Setting] {
        return Array(realm.objects(Model_Setting.self).where{
            $0.setting_type == "รายรับ"})
    }

}
