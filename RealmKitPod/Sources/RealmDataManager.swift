//
//  RealmDataManager.swift
//
//  Created by Indir Amerkhanov on 09.03.2020.
//  Copyright © 2020 Indir Amerkhanov. All rights reserved.
//

import Foundation
import RealmSwift

fileprivate let logRealm: Bool = ProcessInfo.processInfo.environment["LOG_REALM"] != nil

public protocol RealmDataManagerProtocol {
    func create<T: Object>(_ model: T.Type, completion: ((T) -> Void)) throws
    func save<T: Object>(object: T) throws
    func save<T: Object>(objects: [T]) throws
    func update<T: Object>(object: T) throws
    func delete<T: Object>(object: T) throws
    func deleteAll<T: Object>(_ model: T.Type) throws
    func fetch<T: Object>(_ model: T.Type, predicate: NSPredicate?, sorted: Sorted?, completion: (([T]) -> ()))
}

public class RealmDataManager {
    private let realm: Realm?
    
    init(_ realm: Realm?) {
        self.realm = realm
    }
}

extension RealmDataManager: RealmDataManagerProtocol {
    
    public func create<T: Object>(
        _ model: T.Type,
        completion: ((T) -> Void)
    ) throws {
        guard let realm = realm else {
            throw RealmError.nilOrNotValidModel
        }
        
        try realm.write {
            let newObject = realm.create(model, value: [], update: .error)
            
            
            log("Realm data manager: Created entity \(T.self)")
            
            completion(newObject)
        }
    }
    
    //primary key needed
    public func save<T: Object>(object: T) throws {
        guard let realm = realm else {
            throw RealmError.nilOrNotValidModel
        }
        
        try realm.write {
            realm.add(object, update: .all)

            log("Realm data manager: Saved entity \(T.self)")
        }
    }
    
    //primary key needed
    public func save<T: Object>(objects: [T]) throws {
        guard let realm = realm else {
            throw RealmError.nilOrNotValidModel
        }
        
        try realm.write {
            realm.add(objects, update: .all)

            log("Realm data manager: Saved entities \(T.self)")
        }
    }
    
    //primary key needed
    public func update<T: Object>(object: T) throws {
        guard let realm = realm else {
            throw RealmError.nilOrNotValidModel
        }
        
        try realm.write {
            realm.add(object, update: .modified)
            
            log("Realm data manager: Updated entity \(T.self)")
        }
    }
    
    //primary key needed
    public func delete<T: Object>(object: T) throws {
        guard let realm = realm else {
            throw RealmError.nilOrNotValidModel
        }
        
        guard
            let primaryKey = T.primaryKey(),
            let primaryKeyValue = object.value(forKey: primaryKey),
            let realmObject = realm.object(ofType: T.self, forPrimaryKey: primaryKeyValue)
        else {
            throw RealmError.noPrimaryKey
        }
    
        try realm.write {
            realm.delete(realmObject)
   
            log("Realm data manager: Deleted entity \(T.self)")
        }
    }
    
    public func deleteAll<T: Object>(_ model: T.Type) throws {
        guard let realm = realm else {
            throw RealmError.nilOrNotValidModel
        }
        
        try realm.write {
            let objects = realm.objects(model)
            realm.delete(objects)
            
            log("Realm data manager: Deleted all entities \(T.self)")
        }
    }
    
    public func fetch<T: Object>(
        _ model: T.Type,
        predicate: NSPredicate?,
        sorted: Sorted?,
        completion: (([T]) -> Void)
    ) {
        guard let realm = realm else {
            return
        }
        
        var objects = realm.objects(model)
        
        if let predicate = predicate {
            objects = objects.filter(predicate)
        }
        
        if let sorted = sorted {
            objects = objects.sorted(byKeyPath: sorted.key, ascending: sorted.ascending)
        }

        log("Realm data manager: Fetched entity \(T.self)")
        
        completion(objects.compactMap { $0 })
    }
}

private extension RealmDataManager {
    var currentTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        return dateFormatter.string(from: Date())
    }
    
    func log(_ message: String) {
        if logRealm {
            print("[\(currentTime)] \(message)")
        }
    }
}

enum RealmError: Error {
    case nilOrNotValidModel
    case castError
    case noPrimaryKey
}
