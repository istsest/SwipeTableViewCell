//
//  PCSwipeTableViewCell.m
//
//  Created by Joon on 7/21/14.
//

#import "PCSwipeTableViewCell.h"


@interface PCSwipeTableViewCell () <UIGestureRecognizerDelegate>
{
	CGPoint			_touchDownPoint;
	UIView			*_leftViewOfCell;
	UIView			*_rightViewOfCell;
}

@end

@implementation PCSwipeTableViewCell


#pragma mark - Process properties

- (void)setLeftView:(UIView *)leftView maximumWidth:(CGFloat)maximumWidth
{
	self.leftViewOfCell = leftView;
	self.maximumWidthOfLeftView = maximumWidth;
}

- (void)setRightView:(UIView *)rightView maximumWidth:(CGFloat)maximumWidth
{
	self.rightViewOfCell = rightView;
	self.maximumWidthOfRightView = maximumWidth;
}


- (UIView *)leftViewOfCell
{
	return _leftViewOfCell;
}

- (void)setLeftViewOfCell:(UIView *)leftViewOfCell
{
	_leftViewOfCell = leftViewOfCell;
	_leftViewOfCell.clipsToBounds = YES;
}

- (UIView *)rightViewOfCell
{
	return _rightViewOfCell;
}

- (void)setRightViewOfCell:(UIView *)leftViewOfCell
{
	_rightViewOfCell = leftViewOfCell;
	_rightViewOfCell.clipsToBounds = YES;
}


#pragma mark - Process gestures

- (UIView *)addSubSwipeViewIfNeeded:(CGFloat)gap
{
	if(gap > 0)
	{
		if(self.rightViewOfCell && self.rightViewOfCell.superview)
			[self.rightViewOfCell removeFromSuperview];
		if(self.leftViewOfCell)
		{
			if(self.leftViewOfCell.superview != self)
			{
				CGRect frame = CGRectMake(-self.maximumWidthOfLeftView, 0, self.maximumWidthOfLeftView, self.bounds.size.height);
				self.leftViewOfCell.frame = frame;
				[self addSubview:self.leftViewOfCell];
			}
			return self.leftViewOfCell;
		}
	}
	else if(gap < 0)
	{
		if(self.leftViewOfCell && self.leftViewOfCell.superview)
			[self.leftViewOfCell removeFromSuperview];
		if(self.rightViewOfCell)
		{
			if(self.rightViewOfCell.superview != self)
			{
				CGRect frame = CGRectMake(self.bounds.size.width, 0, self.maximumWidthOfRightView, self.bounds.size.height);
				UITableView *tableView = (UITableView *)self.superview.superview;
				NSArray *arr = nil;
				if(tableView.dataSource && [tableView.dataSource respondsToSelector:@selector(sectionIndexTitlesForTableView:)])
					arr = [tableView.dataSource sectionIndexTitlesForTableView:tableView];
				if(arr && [arr count])
					frame.origin.x -= 18;
				self.rightViewOfCell.frame = frame;
				[self addSubview:self.rightViewOfCell];
			}
			return self.rightViewOfCell;
		}
	}
	else
	{
		if(self.leftViewOfCell && self.leftViewOfCell.superview)
			[self.leftViewOfCell removeFromSuperview];
		if(self.rightViewOfCell && self.rightViewOfCell.superview)
			[self.rightViewOfCell removeFromSuperview];
	}
	
	return nil;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSSet			*allTouches = [event allTouches];
	if([allTouches count] == 1)
	{
		NSArray		*touch = [allTouches allObjects];
		_touchDownPoint = [[touch lastObject] locationInView:self];
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSSet			*allTouches = [event allTouches];
	if([allTouches count] == 1 && (self.leftViewOfCell || self.rightViewOfCell))
	{
		NSArray		*touch = [allTouches allObjects];
		CGPoint		movePoint = [[touch lastObject] locationInView:self];
		float		gap = (movePoint.x - _touchDownPoint.x);
		
		if(gap > 0.0 && !self.leftViewOfCell)
			return;
		if(gap < 0.0 && !self.rightViewOfCell)
			return;

		if(fabs(gap) > 5.0 || !((UIScrollView *)self.superview.superview).scrollEnabled)
		{
			UIView *swipeView = [self addSubSwipeViewIfNeeded:gap];
			if(swipeView)
			{
				if(self.leftViewOfCell && gap > self.maximumWidthOfLeftView)
					gap = self.maximumWidthOfLeftView;
				if(self.rightViewOfCell && gap < -self.maximumWidthOfRightView)
					gap = -self.maximumWidthOfRightView;
				
				UIScrollView *scrollView = (UIScrollView *)self.contentView.superview;
				scrollView.contentOffset = CGPointMake(-gap, 0);
			}

			((UIScrollView *)self.superview.superview).scrollEnabled = NO;
		}
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSSet			*allTouches = [event allTouches];
	if([allTouches count] == 1)
	{
		NSArray		*touch = [allTouches allObjects];
		CGPoint		movePoint = [[touch lastObject] locationInView:self];
		float		gap = (movePoint.x - _touchDownPoint.x);
		
		if(self.swipeDelegate)
		{
			if(gap <= -self.maximumWidthOfRightView && self.rightViewOfCell && [self.swipeDelegate respondsToSelector:@selector(swipeRightToLeftTableViewCell:)])
				[self.swipeDelegate swipeRightToLeftTableViewCell:self];
			else if(gap >= self.maximumWidthOfLeftView && self.leftViewOfCell && [self.swipeDelegate respondsToSelector:@selector(swipeLeftToRightTableViewCell:)])
				[self.swipeDelegate swipeLeftToRightTableViewCell:self];
		}
		
		((UIScrollView *)self.superview.superview).scrollEnabled = YES;
		[self moveContentsViewToOriginalPosition];
	}
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	((UIScrollView *)self.superview.superview).scrollEnabled = YES;
	[self moveContentsViewToOriginalPosition];
}

- (void)moveContentsViewToOriginalPosition
{
	UIScrollView *scrollView = (UIScrollView *)self.contentView.superview;
	CGPoint point = scrollView.contentOffset;
	if((point.x < 0 && self.leftViewOfCell) || (point.x > 0 && self.rightViewOfCell))
	{
		point.x = 0.0;
		[UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.5 options:0 animations:^{
			scrollView.contentOffset = point;
		} completion:^(BOOL finished) {
			[self.leftViewOfCell removeFromSuperview];
			[self.rightViewOfCell removeFromSuperview];
		}];
	}
}

#pragma mark - Initializing

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
	{
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
