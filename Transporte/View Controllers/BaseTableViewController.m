//
//  BaseTableViewController.m
//  Transporte
//
//  This base class will provide default implementation of UITableViewDelegate and UITableViewSource
//  Created by Bruce McLaren on 3/7/14.
//  Copyright (c) 2014 Bruce McLaren. All rights reserved.
//

#import "BaseTableViewController.h"

@implementation BaseTableViewController

#pragma mark UITableViewDelegate functions
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [self.tableArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"Cell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil)
  {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  }
  
  // Set up the cell...
  NSString* value = [self.tableArray objectAtIndex:indexPath.row];
  
  // Format row title.
  cell.textLabel.text = value;
  return cell;
}

@end
