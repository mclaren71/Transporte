//
//  BaseTableViewController.h
//  Transporte
//
//  Created by Bruce McLaren on 3/7/14.
//  Copyright (c) 2014 Bruce McLaren. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseTableViewController : UIViewController < UITableViewDataSource, UITableViewDelegate >

@property (nonatomic, strong) NSMutableArray* tableArray;
@property (nonatomic, strong) IBOutlet UITableView* tableView;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView* activityIndicator;

@end
