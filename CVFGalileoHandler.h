//
//  CVFGalileoHandler.h
//  WristVision
//
//  Created by John Brewer on 11/15/13.
//  Copyright (c) 2013 Jera Design LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GalileoControl/GalileoControl.h>

@interface CVFGalileoHandler : NSObject<GCGalileoDelegate, GCPositionControlDelegate>

- (void)rotateBy:(double) degrees axis:(BOOL)axis;

@end
