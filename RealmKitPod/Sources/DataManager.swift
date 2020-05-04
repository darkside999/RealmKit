//
//  DataManager.swift
//
//  Created by Indir Amerkhanov on 09.03.2020.
//  Copyright © 2020 Indir Amerkhanov. All rights reserved.
//

import Foundation
import RealmSwift

public protocol DataManagerProtocol {
    func create<DomainEntity: Mappable>(_ model: DomainEntity.Type, completion: @escaping ((DomainEntity) -> Void)) throws
    func save<DomainEntity: Mappable>(entity: DomainEntity) throws
    func save<DomainEntity: Mappable>(entities: [DomainEntity]) throws
    func update<DomainEntity: Mappable>(entity: DomainEntity) throws
    func delete<DomainEntity: Mappable>(entity: DomainEntity) throws
    func deleteAll<DomainEntity: Mappable>(_ model: DomainEntity.Type) throws
    func fetch<DomainEntity: Mappable>(
        _ model: DomainEntity.Type,
        predicate: NSPredicate?,
        sorted: Sorted?,
        completion: @escaping ([DomainEntity]) -> Void
    )
}

public protocol Storable { }

extension Object: Storable { }

public struct Sorted {
    var key: String
    var ascending: Bool = true
}

public class BaseDataManager: DataManagerProtocol {
    public static let shared = BaseDataManager()
    
    private let dataManager: RealmDataManagerProtocol
    private let backgroundQueue = DispatchQueue(label: "com.backgroundQueue.RealmKit")
    
    init(dataManager: RealmDataManager = RealmDataManager(RealmProvider.default)) {
        self.dataManager = dataManager
    }
    
    public func create<DomainEntity: Mappable>(_ model: DomainEntity.Type, completion: @escaping ((DomainEntity) -> Void)) throws {
        try backgroundQueue.sync {
            try dataManager.create(DomainEntity.Persistence.self, completion: { storeEntity in
                guard let domainEntity = try? DomainEntity.mapFromPersistenceObject(storeEntity) else {
                    return
                }
                
                DispatchQueue.main.async {
                    completion(domainEntity)
                }
            })
        }
    }
    
    public func save<DomainEntity: Mappable>(entity: DomainEntity) throws {
        try backgroundQueue.sync {
            try dataManager.save(object: entity.mapToPersistenceObject())
        }
    }
    
    public func save<DomainEntity: Mappable>(entities: [DomainEntity]) throws {
        try backgroundQueue.sync {
            try dataManager.save(objects: entities.map { $0.mapToPersistenceObject() })
        }
    }
    
    public func update<DomainEntity: Mappable>(entity: DomainEntity) throws {
        try backgroundQueue.sync {
            try dataManager.update(object: entity.mapToPersistenceObject())
        }
    }
    
    public func delete<DomainEntity: Mappable>(entity: DomainEntity) throws {
        try backgroundQueue.sync {
            try dataManager.delete(object: entity.mapToPersistenceObject())
        }
    }
    
    public func deleteAll<DomainEntity: Mappable>(_ model: DomainEntity.Type) throws {
        try backgroundQueue.sync {
            try dataManager.deleteAll(model.Persistence.self)
        }
    }
    
    public func fetch<DomainEntity: Mappable>(
        _ model: DomainEntity.Type,
        predicate: NSPredicate?,
        sorted: Sorted?,
        completion: @escaping ([DomainEntity]) -> Void
    ) {
        backgroundQueue.sync {
            dataManager.fetch(
                DomainEntity.Persistence.self,
                predicate: predicate,
                sorted: sorted,
                completion: { storeEntities in
                    let entities = storeEntities.compactMap {
                        try? DomainEntity.mapFromPersistenceObject($0)
                    }
                    
                    DispatchQueue.main.async {
                        completion(entities)
                    }
                }
            )
        }
    }
}
