//
//  ViewController.h
//  TwitterTimeline
//
//  Created by digbio lab on 9/25/14.
//  Copyright (c) 2014 SoyKBDevelopment. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <
    UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
