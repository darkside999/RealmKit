//
//  Mappable.swift
//
//  Created by Indir Amerkhanov on 09.03.2020.
//  Copyright © 2020 Indir Amerkhanov. All rights reserved.
//

import Foundation
import RealmSwift

public typealias Mappable = MappableType & AnyMappable

public protocol MappableType {
    associatedtype Persistence: Object
    
    func mapToPersistenceObject() -> Persistence
    static func mapFromPersistenceObject(_ object: Persistence) throws -> Self
}

public protocol AnyMappable {
    func mapToPersistenceObject() -> Any
    static func mapFromPersistenceObject(_ object: Any) throws -> Self
}

public extension AnyMappable where Self: Mappable {
    func mapToPersistenceObject() -> Any {
        mapToPersistenceObject() as Persistence
    }
    
    static func mapFromPersistenceObject(_ object: Any) throws -> Self {
        guard let object = object as? Persistence else {
            throw AnyMappableError.unknownError
        }
        
        return try mapFromPersistenceObject(object)
    }
}

enum AnyMappableError: Error {
    case unknownError
}
