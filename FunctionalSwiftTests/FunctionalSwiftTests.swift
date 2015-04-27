//
//  FunctionalSwiftTests.swift
//  FunctionalSwiftTests
//
//  Created by Ilinca on 16/04/2015.
//  Copyright (c) 2015 iosnsagora. All rights reserved.
//

import UIKit
import XCTest
import FunctionalSwift

class FunctionalSwiftTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetMe() {
        let user = getMe()
        XCTAssertNotNil(user, "User is nil")
        if let user = user {
            println("User: \(user)")
        }
    }
    
    func testGetUsers() {
        let users = getUsers()

        if users?.count != 2 {
            XCTFail("Users array invalid")
        }
        
        if let users = users {
             println("Users: \(users)")
        }
    }
    
}
