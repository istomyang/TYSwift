//
//  TestTSDevice.swift
//  TYSwift_Tests
//
//  Created by 杨洋 on 21/6/2022.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import XCTest
import TYSwift

func Log(_ name: String, m: String...) {
  print("TestTSDevice: ", name, m)
}

class TestTSDevice: XCTestCase {
  func testAll() {
    
    let a = true
    XCTAssertTrue(a)
  }
}
