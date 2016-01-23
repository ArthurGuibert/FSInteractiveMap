//
//  FSSVGParsingTests.m
//  FSInteractiveMap
//
//  Created by Arthur GUIBERT on 23/01/2016.
//  Copyright © 2016 Arthur GUIBERT. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FSSVGUtils.h"
#import "FSSVGPathElement.h"

static const float FSSVGAccuryForTest = 0.001f;

@interface FSSVGParsingTests : XCTestCase

@end

@implementation FSSVGParsingTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark - Testing the parsePoints method

- (void)testEmptyPointsListParsing {
    NSArray* points = [FSSVGUtils parsePoints:""];
    XCTAssertEqual([points count], 0);
}

- (void)testSinglePointParsing {
    NSArray* points = [FSSVGUtils parsePoints:"1.2345"];
    XCTAssertEqual([points count], 1);
    XCTAssertEqualWithAccuracy([points[0] floatValue], 1.2345f, FSSVGAccuryForTest);
}

- (void)testMultiplePointsParsing {
    NSArray* points = [FSSVGUtils parsePoints:"1.2345, 2.345, 8,\n 0.001"];
    XCTAssertEqual([points count], 4);
    XCTAssertEqualWithAccuracy([points[0] floatValue], 1.2345f, FSSVGAccuryForTest);
    XCTAssertEqualWithAccuracy([points[1] floatValue], 2.345f, FSSVGAccuryForTest);
    XCTAssertEqualWithAccuracy([points[2] floatValue], 8, FSSVGAccuryForTest);
    XCTAssertEqualWithAccuracy([points[3] floatValue], 0.001, FSSVGAccuryForTest);
}

- (void)testWrongFormat {
    NSArray* points = [FSSVGUtils parsePoints:"abcd"];
    XCTAssertEqual([points count], 0);
}

#pragma mark - Testing the transfor parsing method

- (void)testEmptyTransform {
    CGAffineTransform transform = [FSSVGUtils parseTransform:@""];

    XCTAssertEqual(transform.tx, 0);
    XCTAssertEqual(transform.ty, 0);
    XCTAssertEqual(transform.a, 1);
    XCTAssertEqual(transform.b, 0);
    XCTAssertEqual(transform.c, 0);
    XCTAssertEqual(transform.d, 1);
}

- (void)testTranslateTransform {
    CGAffineTransform transform = [FSSVGUtils parseTransform:@"translate(1, 2)"];
    
    XCTAssertEqual(transform.tx, 1);
    XCTAssertEqual(transform.ty, 2);
    XCTAssertEqual(transform.a, 1);
    XCTAssertEqual(transform.b, 0);
    XCTAssertEqual(transform.c, 0);
    XCTAssertEqual(transform.d, 1);
}

- (void)testMatrixTransform {
    CGAffineTransform transform = [FSSVGUtils parseTransform:@"matrix(1, 2, 3, 4, 5, 6)"];
    
    XCTAssertEqual(transform.a, 1);
    XCTAssertEqual(transform.b, 2);
    XCTAssertEqual(transform.c, 3);
    XCTAssertEqual(transform.d, 4);
    XCTAssertEqual(transform.tx, 5);
    XCTAssertEqual(transform.ty, 6);
}

#pragma mark - SVGPathElement testing

- (void)testSvgPathElementInit {
    NSDictionary* dict = @{
                           @"title" : @"title__01",
                           @"id" : @"part_1",
                           @"class" : @"land",
                           @"d" : @"M302.37,434.36l-0.06,-1.12l1.61,-0.37l0.59,0.1l-0.11,2.11l-2.34,0.31l-0.5,-0.25L302.37,434.36zM309.41,631.56l-2.38,-1.12l-3.36,2.7l1.4,2.05l2.38,-2.05l1.26,1.59l3.79,-1.36l0.84,-1.58l-2.24,-2.01L309.41,631.56zM377.41,482.2l-0.95,-3.57l-1.02,-0.88l-2.4,-0.11l-2.16,-0.81l-3.58,-3.13l-4.15,-2.31l-4.19,0.11l-5.46,-1.47l-3.26,0.86l0.46,-1.54l-1.37,-1.63l-4.66,-1.7l-3.53,-1l-2.13,1.83l-0.1,-2.79l-4.96,-0.44l-0.87,-0.84l2.11,-2.29l-0.08,-1.92l-1.5,-0.46l-1.57,-4.88l-0.69,-1.54l-0.96,0.13l-0.46,-1.14l-2.97,-2.36l-2.06,-0.66l-0.95,-0.31l-3.01,-0.75l-2.27,0.2l-0.3,0.5l-3.36,-0.56l-1.11,-0.98l-1.5,-1.37l-1.06,-0.07l-0.08,-1.45l-1.73,-1.83L307.7,440l-1.1,-0.66l-1.46,0.06l-0.45,-2.26l-2.13,-1.39l-2.24,-0.21l-0.96,-1.34l2.38,-0.84l-3.36,0.04l-3.47,0.17l-0.03,0.71l-1.57,0.88l-2.14,-0.35l-1.61,-1.27l-3,0.29l-2.52,-0.02l-0.11,-0.94l-1.82,-1.58l-1.97,-0.05l-1.01,-2l-0.98,0.9l0.39,1.34l-3.49,1.15l0.14,2.15l0.87,1l-0.63,2.04l-1.21,0.18l-1.06,-2.24l1.24,-1.64l0.03,-1.48l-0.91,-1.29l1.65,-0.33l0.08,-0.67l0.54,-0.96l-0.74,-0.75l-0"
                           };
    
    FSSVGPathElement* element = [[FSSVGPathElement alloc] initWithAttributes:dict];
    
    XCTAssertNotNil(element);
    XCTAssertEqual(element.title, @"title__01");
    XCTAssertEqual(element.identifier, @"part_1");
    XCTAssertEqual(element.className, @"land");
    XCTAssertNotNil(element.path);
}

@end
