Swipe Table View Cell
==========================

[Sample Video](https://www.youtube.com/watch?v=jAEvt74SMDg&feature=youtube_gdata_player)

![Alt text](/ss.png)

It is so easy to use.

1. Create views and assign to leftView, rightView, or both of the PCSwipeTableViewCell class.
2. Implement delegates.



<pre><code>
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
</code></pre>
