//
//  CoordinatorTests.swift
//  CoordinatorTests
//
//  Created by Wolf McNally on 5/18/22.
//

import XCTest
import CoreData
@testable import Coordinator

class CoordinatorTests: XCTestCase {

    func testExample() throws {
        let container = PersistenceController(inMemory: true)
        let itemEntity = container.container.managedObjectModel.entitiesByName["Item"]!
        verifyAttribute(nemed: "timestamp", on: itemEntity, hasType: .date)
    }
    
    func verifyAttribute(
        nemed name: String,
        on entity: NSEntityDescription,
        hasType type: NSAttributeDescription.AttributeType
    ) {
        guard let attribute = entity.attributesByName[name] else {
            XCTFail("\(entity.name!) is missing expected attribute \(name)")
            return
        }
        XCTAssertEqual(type, attribute.type)
    }
}
