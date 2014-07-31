//
//  ViewController.m
//  testSwipeTableViewCell
//
//  Created by Joon on 7/30/14.
//  Copyright (c) 2014 Joon. All rights reserved.
//

#import "ViewController.h"
#import "PCSwipeTableViewCell.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, PCSwipeTableViewCellDelegate>
{
	NSArray *_arrayData;
}

@end

@implementation ViewController


- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
	return [_arrayData count];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString			*CellIdentifier = [NSString stringWithFormat:@"PCSwipeTableViewCell"];
    PCSwipeTableViewCell	*cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
	static UILabel		*leftView = nil, *rightView = nil;
    
	if(cell == nil)
	{
        cell = [[PCSwipeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		if(!leftView)
		{
			leftView = [[UILabel alloc] init];
			leftView.contentMode = UIViewContentModeCenter;
			leftView.backgroundColor = [UIColor darkGrayColor];
			leftView.textColor = [UIColor whiteColor];
			leftView.textAlignment = NSTextAlignmentCenter;
			leftView.text = @"Share";
		}
		[cell setLeftView:leftView maximumWidth:100];
		if(!rightView)
		{
			rightView = [[UILabel alloc] init];
			rightView.contentMode = UIViewContentModeCenter;
			rightView.backgroundColor = [UIColor darkGrayColor];
			rightView.textColor = [UIColor whiteColor];
			rightView.textAlignment = NSTextAlignmentCenter;
			rightView.text = @"Detail...";
		}
		[cell setRightView:rightView maximumWidth:100];
		cell.swipeDelegate = self;
	}
	
	cell.textLabel.text = [_arrayData objectAtIndex:indexPath.row];
	
	return cell;
}

- (void)swipeLeftToRightTableViewCell:(PCSwipeTableViewCell *)swipeTableViewCell
{
	NSLog(@"Selected Share");
}

- (void)swipeRightToLeftTableViewCell:(PCSwipeTableViewCell *)swipeTableViewCell
{
	NSLog(@"Selected Detail");
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	_arrayData = @[@"One", @"Two", @"Three", @"Four", @"Five", @"Six", @"Seven", @"Eight", @"Nine", @"Ten", @"Eleven", @"Twelve", @"Thirteen", @"Fourteen", @"Fifteen"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
