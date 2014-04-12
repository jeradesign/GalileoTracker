//
//  CVFGalileoHandler.m
//  WristVision
//
//  Created by John Brewer on 11/15/13.
//  Copyright (c) 2013 Jera Design LLC. All rights reserved.
//

#import "CVFGalileoHandler.h"

@interface CVFGalileoHandler() {
}

@property (atomic) float panVelocity;
@property (atomic) float tiltVelocity;

@end

@implementation CVFGalileoHandler {
    BOOL _connected;
    NSTimer *_timer;
}

- (id)init
{
    self = [super init];
    if (self) {
        [GCGalileo sharedGalileo].delegate = self;
        [[GCGalileo sharedGalileo] waitForConnection];
    }
    return self;
}

#pragma mark - Galileo Support
- (void)tick {
    [self log:@"tick"];
    [self rotateBy:self.panVelocity axis:GCControlAxisPan];
    [self rotateBy:self.tiltVelocity axis:GCControlAxisTilt];
}

- (void)rotateBy:(double) degrees axis:(NSUInteger)axis {
    if (!_connected) {
        return;
    }
    
    GCVelocityControl *positionControl = [[GCGalileo sharedGalileo] velocityControlForAxis:
                                          axis ];
    [positionControl setTargetVelocity:degrees];
}

- (void)panBy:(double) degrees {
    self.panVelocity = degrees;
}

- (void)tiltBy:(double) degrees {
    self.tiltVelocity = degrees;
}

- (void) galileoDidConnect {
    [self log:@"galileoDidConnect"];
    _connected = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.2
                                                  target:self
                                                selector:@selector(tick)
                                                userInfo:nil
                                                 repeats:YES];
    //        sprintf(_message, "_timer:%p", _timer);
    });
}

- (void) galileoDidDisconnect {
    [self log:@"galileoDidDisconnect"];
    _connected = NO;
    [[GCGalileo sharedGalileo] waitForConnection];
    [_timer invalidate];
    _timer = nil;
}

- (void)controlDidReachTargetPosition {
    [self log:@"controlDidReachTargetPosition"];
}

- (void)controlDidOverrideMovement {
    [self log:@"controlDidOverrideMovement"];
}

- (void)log:(NSString*)message {
    (void)message;
//    NSLog(@"%@", message);
}
@end
