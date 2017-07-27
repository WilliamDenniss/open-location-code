//===-- OpenLocationCodeTests.swift - Tests for OpenLocationCode.swift ----===//
//
//  Copyright 2017 Google Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//===----------------------------------------------------------------------===//
//
//  Tests that verify the included Swift library samples function correctly.
//
//  Authored by: William Denniss. Ported from openlocationcode_test.py.
//
//===----------------------------------------------------------------------===//

import XCTest
import Foundation
@testable import OpenLocationCode

class OpenLocationCodeSwiftTests: XCTestCase {
  
  /// Tests the Swift library README examples.
  func testExamples() {
    // Encode a location, default accuracy.
    let code = OpenLocationCode.encode(latitude: 47.365590,
                                       longitude: 8.524997)
    
    // Encode a location using an additional digits of accuracy.
    let codeExtraPrecise = OpenLocationCode.encode(latitude: 47.365590,
                                                   longitude: 8.524997,
                                                   codeLength: 11)
    
    // Decode a full code:
    let coord = OpenLocationCode.decode("8FVC9G8F+6X")
    print("Center is /(coord.latitudeCenter), /(oord.longitudeCenter)")
    
    // Attempt to trim the first characters from a code:
    let shortCode = OpenLocationCode.shorten(code: "8FVC9G8F+6X",
                                             latitude: 47.5,
                                             longitude: 8.5)
    
    // Recover the full code from a short code:
    let fullCodeA = OpenLocationCode.recoverNearest(shortcode: "9G8F+6X",
                                                    referenceLatitude: 47.4,
                                                    referenceLongitude: 8.6)
    let fullCodeB = OpenLocationCode.recoverNearest(shortcode: "8F+6X",
                                                    referenceLatitude: 47.4,
                                                    referenceLongitude: 8.6)
    
    XCTAssertEqual(code, "8FVC9G8F+6X")
    XCTAssertEqual(codeExtraPrecise, "8FVC9G8F+6XQ")
    let magn = pow(10.0,7.0)
    XCTAssertEqual(Int(coord!.latitudeCenter * magn), Int(47.3655624 * magn))
    XCTAssertEqual(Int(coord!.longitudeCenter * magn), Int(8.5249375 * magn))
    XCTAssertEqual(shortCode, "9G8F+6X")
    XCTAssertEqual(fullCodeA, "8FVC9G8F+6X")
    XCTAssertEqual(fullCodeB, "8FVCCJ8F+6X")
  }
  
  func testDocumentation() {
    
    for length in [2, 4, 6, 8, 10, 11, 12, 13, 14] {
      
      let code = OpenLocationCode.encode(latitude: 47.365590,
                                          longitude: 8.524997,
                                          codeLength: length)
      XCTAssertNotNil(code, "\(length)")
    }
    for length in [-1, 0, 1, 3, 5, 7, 9] {
      
      let code = OpenLocationCode.encode(latitude: 47.365590,
                                         longitude: 8.524997,
                                         codeLength: length)
      XCTAssertNil(code, "\(length)")
    }
  }
}


