//
//  CVFGalileoHandler.h
//  WristVision
//
//  Created by John Brewer on 11/15/13.
//  Copyright (c) 2013 Jera Design LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnewline-eof"
#import <GalileoControl/GalileoControl.h>
#pragma clang diagnostic pop

@interface CVFGalileoHandler : NSObject<GCGalileoDelegate, GCPositionControlDelegate>

- (void)panBy:(double) degrees;
- (void)tiltBy:(double) degrees;
- (void)rotateBy:(double) degrees axis:(BOOL)axis;

@end
