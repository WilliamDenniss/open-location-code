# Open Location Code for Swift
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

Convert between decimal degree coordinates and Open Location Codes. Shorten
and expand Open Location plus+codes for a given reference location.

## About Open Location Codes

Open Location Codes are short, 10-11 character codes that can be used
instead of street addresses. The codes can be generated and decoded offline,
and use a reduced character set that minimises the chance of codes including
words.

Codes are able to be shortened relative to a nearby location. This means
that in many cases, only four to seven characters of the code are needed.
To recover the original code, the same location is not required, as long as
a nearby location is provided.

Codes represent rectangular areas rather than points, and the longer the
code, the smaller the area. A 10 character code represents a 13.5x13.5
meter area (at the equator. An 11 character code represents approximately
a 2.8x3.5 meter area.

Two encoding algorithms are used. The first 10 characters are pairs of
characters, one for latitude and one for latitude, using base 20. Each pair
reduces the area of the code by a factor of 400. Only even code lengths are
sensible, since an odd-numbered length would have sides in a ratio of 20:1.
At position 11, the algorithm changes so that each character selects one
position from a 4x5 grid. This allows single-character refinements.

## Supported Platforms

This library supports Swift and Objective-C on iOS, watchOS,
tvOS, and macOS. Native Swift environments such as Linux and Windows are
also supported.

### Swift Example
```
import OpenLocationCode

// ...

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
```
# Objective-C Examples
```
@import OpenLocationCode;

// ...

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
```
