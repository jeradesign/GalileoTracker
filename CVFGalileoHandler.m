//
//  CVFGalileoHandler.m
//  WristVision
//
//  Created by John Brewer on 11/15/13.
//  Copyright (c) 2013 Jera Design LLC. All rights reserved.
//

#import "CVFGalileoHandler.h"

@implementation CVFGalileoHandler {
    BOOL _connected;
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
}

- (void)rotateBy:(double) degrees axis:(BOOL)axis {
    if (!_connected) {
        return;
    }
    GCPositionControl *positionControl = [[GCGalileo sharedGalileo] positionControlForAxis:
                                          axis ? GCControlAxisTilt : GCControlAxisPan];
    [positionControl setTargetPosition:positionControl.currentPosition + degrees completionBlock:
     ^(BOOL wasCommandPreempted) {
        if (wasCommandPreempted) {
            [self log:@"incrementTargetPosition preempted"];
        } else {
            [self log:@"incrementTargetPosition completed"];
        }
    }
                   waitUntilStationary:NO];
    
}

- (void)panBy:(double) degrees {
    [self rotateBy:degrees axis:FALSE];
}

- (void)tiltBy:(double) degrees {
    [self rotateBy:degrees axis:TRUE];
}

- (void) galileoDidConnect {
    [self log:@"galileoDidConnect"];
    _connected = YES;
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0
    //                                                  target:self
    //                                                selector:@selector(tick)
    //                                                userInfo:nil
    //                                                 repeats:YES];
    //        sprintf(_message, "_timer:%p", _timer);
    //    });
}

- (void) galileoDidDisconnect {
    [self log:@"galileoDidDisconnect"];
    _connected = NO;
    [[GCGalileo sharedGalileo] waitForConnection];
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
