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
    
    func updateContact(oldContact: Model_data, newContact: Model_data )
     {
         try! realm.write{
//             oldContact.expenses_Salary = newContact.first
//             oldContact.lastname = newContact.lastname
         }
        
    }
    
    func deleteContact(contact: Model_data ){
        try! realm.write{
            realm.delete(contact)}
    }
    func getAllContacts() -> [Model_data] {
        return Array(realm.objects(Model_data.self))
    }
    
    func getAllExTyper() -> [Model_Setting] {
        return Array(realm.objects(Model_Setting.self).where {
                $0.setting_type == "รายจ่าย"})
    }
    
    func getAllInTyper() -> [Model_Setting] {
        return Array(realm.objects(Model_Setting.self).where{
            $0.setting_type == "รายรับ"})
    }

}
