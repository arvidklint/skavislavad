//
//  skavislavadTests.swift
//  skavislavadTests
//
//  Created by Arvid Sätterkvist on 20/03/16.
//  Copyright © 2016 arvidsat. All rights reserved.
//

import XCTest
@testable import skavislavad

class skavislavadTests: XCTestCase {
    
   // MARK: skavislavad tests
    
    // Tests to confirm that the Bear initializer returns when no name or a negative rating is provided.
    func testBearInitialization() {
        // Success case.
        let potentialItem = Bear(name: "Newest bear", photo: nil, rating: 5)
        XCTAssertNotNil(potentialItem)
        
        // Failure cases.
        let noName = Bear(name: "", photo: nil, rating: 0)
        XCTAssertNil(noName, "Empty name is invalid")
        
        let badRating = Bear(name: "Really bad rating", photo: nil, rating: -1)
        XCTAssertNil(badRating)
    }
    
}
