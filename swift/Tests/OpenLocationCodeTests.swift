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
//  Authored by: William Denniss. Ported from openlocationcode_test.py.
//
//===----------------------------------------------------------------------===//

import XCTest
import Foundation
@testable import OpenLocationCode

/// OLC Test helpers.
class OLCTestHelper {
  /// Loads CSV data from the test bundle and parses into an Array of
  /// Dictionaries using the given keys.
  ///
  /// - Parameter filename: the filename of the CSV file with no path or
  ///   extension component
  /// - Parameter keys: the keys used to build the dictionary.
  /// - Returns: An array of each line of data represented as a dictionary
  ///   with the given keys.
  static func loadData(filename: String,
                       keys: Array<String>)
                       -> Array<Dictionary<String, String>>? {
    var testData:Array<Dictionary<String, String>> = []
    let testBundle = Bundle(for: OLCTestHelper.self)
    guard let path = testBundle.path(forResource: filename, ofType: "csv")
        else {
      return nil
    }
    guard let  csvData = try? String(contentsOfFile: path) else {
      return nil
    }
    // Iterates each line.
    for(line) in csvData.components(separatedBy: CharacterSet.newlines) {
      if line.hasPrefix("#") || line.characters.count == 0 {
        continue
      }
      // Parses as a comma separated array.
      let lineData =
          line.components(separatedBy: CharacterSet.init(charactersIn: ","))
      // Converts to dict.
      var lineDict:Dictionary<String, String> = [:]
      for i in 0 ..< keys.count {
        lineDict[keys[i]] = lineData[i]
      }
      testData += [lineDict]
    }
    return testData
  }
}

class ExampleTests: XCTestCase {
  
  /// Tests the example code.
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
    
    // Recover the full code from a short coe:
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
}

/// Tests the validity methods.
class ValidityTests: XCTestCase {
  var testData:Array<Dictionary<String, String>> = []
  
  override func setUp() {
    super.setUp()
    let keys = ["code","isValid","isShort","isFull"]
    testData = OLCTestHelper.loadData(filename: "validityTests", keys: keys)!
    XCTAssertNotNil(testData)
    XCTAssert(testData.count > 0)
  }
  
  /// Tests OpenLocationCode.isValid
  func testValidCodes() {
    for(td) in testData {
      XCTAssertEqual(OpenLocationCode.isValid(code: td["code"]!),
                     Bool(td["isValid"]!)!)
    }
  }

  /// Tests OpenLocationCode.isFull
  func testFullCodes() {
    for(td) in testData {
      XCTAssertEqual(OpenLocationCode.isFull(code: td["code"]!),
                     Bool(td["isFull"]!)!)
    }
  }
  
  /// Tests OpenLocationCode.isShort
  func testShortCodes() {
    for(td) in testData {
      XCTAssertEqual(OpenLocationCode.isShort(code: td["code"]!),
                     Bool(td["isShort"]!)!)
    }
  }
}

/// Tests the code shortening methods.
class ShortenTests: XCTestCase {
  var testData:Array<Dictionary<String, String>> = []
  
  override func setUp() {
    super.setUp()
    let keys = ["code","lat","lng","shortcode"]
    testData = OLCTestHelper.loadData(filename: "shortCodeTests", keys: keys)!
    XCTAssertNotNil(testData)
    XCTAssert(testData.count > 0)
  }
  
  /// Tests OpenLocationCode.shorten
  func testFullToShort() {
    for(td) in testData {
      let shortened = OpenLocationCode.shorten(code: td["code"]!,
                                               latitude: Double(td["lat"]!)!,
                                               longitude: Double(td["lng"]!)!)!
      XCTAssertEqual(shortened, td["shortcode"]!)
    }
  }
}

/// Tests encoding and decoding.
class EncodingTests: XCTestCase {
  var testData:Array<Dictionary<String, String>> = []
  
  override func setUp() {
    super.setUp()
    let keys = ["code","lat","lng","latLo","lngLo","latHi","lngHi"]
    testData = OLCTestHelper.loadData(filename: "encodingTests", keys: keys)!
    XCTAssertNotNil(testData)
    XCTAssert(testData.count > 0)
  }
  
  /// Tests OpenLocationCode.encode
  func testEncoding() {
    for(td) in testData {
      let code = td["code"]!
      var codelength = code.characters.count - 1
      if (code.find("0") >= 0)
      {
        codelength = code.find("0")
      }
      let encoded = OpenLocationCode.encode(latitude: Double(td["lat"]!)!,
                                            longitude: Double(td["lng"]!)!,
                                            codeLength: codelength)
      XCTAssertEqual(encoded, code)
    }
  }
  
  /// Tests OpenLocationCode.decode
  func testDecoding() {
    let precision = pow(10.0,10.0)

    for(td) in testData {
      let decoded: OpenLocationCodeArea =
          OpenLocationCode.decode(td["code"]!)!
      XCTAssertEqual((decoded.latitudeLo * precision).rounded(),
                     (Double(td["latLo"]!)! * precision).rounded(),
                     "Failure with " + td["code"]!)
      XCTAssertEqual((decoded.longitudeLo * precision).rounded(),
                     (Double(td["lngLo"]!)! * precision).rounded(),
                     "Failure with " + td["code"]!)
      XCTAssertEqual((decoded.latitudeHi * precision).rounded(),
                     (Double(td["latHi"]!)! * precision).rounded(),
                     "Failure with " + td["code"]!)
      XCTAssertEqual((decoded.longitudeHi * precision).rounded(),
                     (Double(td["lngHi"]!)! * precision).rounded(),
                     "Failure with " + td["code"]!)
    }
  }
}


