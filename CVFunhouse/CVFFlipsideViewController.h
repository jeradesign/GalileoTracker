//
//  CVFFlipsideViewController.h
//  CVFunhouse
//
//  Created by John Brewer on 3/7/12.
//  Copyright (c) 2012 Jera Design LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CVFFlipsideViewController;

@protocol CVFFlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(CVFFlipsideViewController *)controller;
@end

@interface CVFFlipsideViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    bool shouldShowFPS;
    bool shouldShowDescription;
}
@property (retain, nonatomic) IBOutlet UITableView *menuTable;
@property (weak, nonatomic) id <CVFFlipsideViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) UISwitch *switchCtl;
@property (retain, nonatomic) NSArray *demoList;

- (IBAction)done:(id)sender;

@end
