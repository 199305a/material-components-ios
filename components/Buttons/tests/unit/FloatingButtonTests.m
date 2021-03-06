/*
 Copyright 2017-present the Material Components for iOS authors. All Rights Reserved.

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import <XCTest/XCTest.h>

#import "MaterialButtons.h"
#import "MaterialShadowElevations.h"

@interface FloatingButtonsTests : XCTestCase
@end

@implementation FloatingButtonsTests

- (void)testDefaultElevationsForState {
  // Given
  MDCFloatingButton *button = [MDCFloatingButton appearance];

  // Then
  XCTAssertEqual([button elevationForState:UIControlStateNormal], MDCShadowElevationFABResting);
  XCTAssertEqual([button elevationForState:UIControlStateHighlighted],
                 MDCShadowElevationFABPressed);
  XCTAssertEqual([button elevationForState:UIControlStateDisabled], MDCShadowElevationNone);
}

- (void)testCollapseExpandRestoresIdentityTransform {
  // Given
  MDCFloatingButton *button = [[MDCFloatingButton alloc] init];
  CGAffineTransform transform = CGAffineTransformIdentity;
  button.transform = transform;

  // When
  [button collapse:NO completion:nil];
  [button expand:NO completion:nil];

  // Then
  XCTAssertTrue(
      CGAffineTransformEqualToTransform(button.transform, transform),
      @"Collapse and expand did not restore the original transform.\nExpected: %@\nReceived: %@",
      NSStringFromCGAffineTransform(transform), NSStringFromCGAffineTransform(button.transform));
}

- (void)testCollapseExpandRestoresTransform {
  // Given
  MDCFloatingButton *button = [[MDCFloatingButton alloc] init];
  CGAffineTransform transform = CGAffineTransformRotate(button.transform, M_PI_2);
  button.transform = transform;

  // When
  [button collapse:NO completion:nil];
  [button expand:NO completion:nil];

  // Then
  XCTAssertTrue(
      CGAffineTransformEqualToTransform(button.transform, transform),
      @"Collapse and expand did not restore the original transform.\nExpected: %@\nReceived: %@",
      NSStringFromCGAffineTransform(transform), NSStringFromCGAffineTransform(button.transform));
}

- (void)testCollapseExpandAnimatedRestoresTransform {
  // Given
  MDCFloatingButton *button = [[MDCFloatingButton alloc] init];
  CGAffineTransform transform = CGAffineTransformMakeTranslation(10, -77.1);
  button.transform = transform;
  XCTestExpectation *expectation = [self expectationWithDescription:@"Collapse animation complete"];

  // When
  [button collapse:YES
        completion:^{
          [expectation fulfill];
        }];

  // Then
  // Collapse should take around 200ms in total
  [self waitForExpectationsWithTimeout:1 handler:nil];

  XCTAssertFalse(CGAffineTransformEqualToTransform(button.transform, transform),
                 @"Collapse did not modify the original transform.\nOriginal: %@\nReceived: %@",
                 NSStringFromCGAffineTransform(transform),
                 NSStringFromCGAffineTransform(button.transform));

  expectation = [self expectationWithDescription:@"Expand animation complete"];

  [button expand:YES
      completion:^{
        [expectation fulfill];
      }];

  // Expand should take around 200ms in total
  [self waitForExpectationsWithTimeout:1 handler:nil];

  XCTAssertTrue(
      CGAffineTransformEqualToTransform(button.transform, transform),
      @"Collapse and expand did not restore the original transform.\nExpected: %@\nReceived: %@",
      NSStringFromCGAffineTransform(transform), NSStringFromCGAffineTransform(button.transform));
}

@end
