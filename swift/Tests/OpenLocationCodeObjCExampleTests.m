//===-- OpenLocationCodeObjCTests.m - Tests for OpenLocationCode.swift ----===//
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
//  Objective-C tests. Verify that the library is accessible from ObjC and that
//  the included library samples function correctly.
//
//  Authored by: William Denniss.
//
//===----------------------------------------------------------------------===//

#import <XCTest/XCTest.h>
@import OpenLocationCode;
@interface OpenLocationCodeObjCTests : XCTestCase

@end

@implementation OpenLocationCodeObjCTests

/* Tests the Objective-C library README examples.
 */
- (void)testObjCExamples {
  // Encode a location, default accuracy.
  NSString *code = [OpenLocationCode encodeWithLatitude:47.365590
                                              longitude:8.524997
                                             codeLength:10];
  
  // Encode a location using an additional digits of accuracy.
  NSString *codeExtraPrecise = [OpenLocationCode encodeWithLatitude:47.365590
                                                          longitude:8.524997
                                                         codeLength:11];
  
  // Decode a full code:
  OpenLocationCodeArea *coord = [OpenLocationCode decode:@"8FVC9G8F+6X"];
  NSLog(@"Center is %f, %f", coord.latitudeCenter, coord.longitudeCenter);
  
  // Attempt to trim the first characters from a code:
  NSString *shortCode = [OpenLocationCode shortenWithCode:@"8FVC9G8F+6X"
                                                 latitude:47.5
                                                longitude:8.5];
  
  // Recover the full code from a short code:
  NSString *fullCodeA =
      [OpenLocationCode recoverNearestWithShortcode:@"9G8F+6X"
                                  referenceLatitude:47.4
                                 referenceLongitude:8.6];

  NSString *fullCodeB =
      [OpenLocationCode recoverNearestWithShortcode:@"8F+6X"
                                  referenceLatitude:47.4
                                 referenceLongitude:8.6];
  
  XCTAssertEqualObjects(code, @"8FVC9G8F+6X");
  XCTAssertEqualObjects(codeExtraPrecise, @"8FVC9G8F+6XQ");
  double magn = pow(10.0, 7.0);
  XCTAssert((long)(coord.latitudeCenter * magn) == (long)(47.3655624 * magn));
  XCTAssert((long)(coord.longitudeCenter * magn) == (long)(8.5249375 * magn));
  XCTAssertEqualObjects(shortCode, @"9G8F+6X");
  XCTAssertEqualObjects(fullCodeA, @"8FVC9G8F+6X");
  XCTAssertEqualObjects(fullCodeB, @"8FVCCJ8F+6X");
}

@end
