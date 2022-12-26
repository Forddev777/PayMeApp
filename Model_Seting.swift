//
//  Model_Seting.swift
//  PayMeApp
//
//  Created by suriya taothongkom on 7/12/2565 BE.
//

import Foundation
import RealmSwift
class Model_Setting: Object {
    @Persisted var PKeyid = UUID().uuidString
    @Persisted var setting_type: String?
    @Persisted var setting_type_in_ex : String?
    convenience init(setting_type: String? , setting_type_in_ex: String?){
        self.init()
        self.setting_type = setting_type
        self.setting_type_in_ex = setting_type_in_ex
    }
    override static func primaryKey() -> String? {
       return "PKeyid"
     }
}

