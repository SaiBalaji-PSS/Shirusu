//
//  RealmManager.swift
//  Shirusu
//
//  Created by Sai Balaji on 09/09/24.
//

import Foundation
import RealmSwift

class RealmManager{
    static var shared = RealmManager()
    private init(){}
    private var realm: Realm?
    
    func initializeRealm(onCompletion:@escaping(Error?)->(Void)){
        do{
            realm = try Realm()
            print(Realm.Configuration.defaultConfiguration.fileURL)
            onCompletion(nil)
        }
        catch{
            print(error)
            onCompletion(error)
        }
    }
    
    
    func saveDataToRealm<T: Object>(word: T,onCompletion:@escaping(Error?)->(Void)){
        if let realm{
            do{
                try realm.write {
                    realm.add(word)
                    
                }
              
                onCompletion(nil)
            }
            catch{
                onCompletion(error)
            }
        }
    }
    
    
    func readDataFromRealm<T: Object>(modelType: T.Type) -> Results<T>?{
        if let realm{
            return realm.objects(modelType.self)
        }
        return nil
    }
    
    func deleteDataFromRealm<T: Object>(object: T,onCompletion:@escaping(Error?)->(Void)){
        if let realm{
            do{
                try realm.write {
                    realm.delete(object)
                    
                    
                }
                onCompletion(nil)
            }
            catch{
                onCompletion(error)
            }
        }
    }
   
}
