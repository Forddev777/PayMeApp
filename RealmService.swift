//
//  RealmService.swift
//  PayMeApp
//
//  Created by suriya taothongkom on 30/11/2565 BE.
//

import Foundation
import RealmSwift

class RealmService {

    private init(){}

    static let shared = RealmService()

    var realm = try! Realm()

    func create<T: Object >(_ object: T){
        do {
            try realm.write{
                realm.add(object)
            }
        }catch{
           post(error)


        }


    }

    func update(){

    }



    func delete(){

    }

    func post(_ error: Error){
        NotificationCenter.default.post(name: NSNotification.Name("RealmError"),
                                        object: error)

    }

    func observeRealmErrors(in vc: UIViewController,
                            completion: @escaping (Error?) -> Void){
        NotificationCenter.default.addObserver(forName: NSNotification.Name("RealmError"),
                                               object: nil,
                                               queue: nil ){(notification) in
            completion(notification.object as? Error)



        }



    }


    func stopObservervingErrors(in vc: UIViewController){
        NotificationCenter.default.removeObserver(vc,name: NSNotification.Name("RealmError"), object: nil)

    }
}
