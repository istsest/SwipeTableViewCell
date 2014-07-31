//
//  PCSwipeTableViewCell.h
//
//  Created by Joon on 7/21/14.
//

#import <UIKit/UIKit.h>

@class PCSwipeTableViewCell;

@protocol PCSwipeTableViewCellDelegate <NSObject>
@optional
- (void)swipeLeftToRightTableViewCell:(PCSwipeTableViewCell *)swipeTableViewCell;
- (void)swipeRightToLeftTableViewCell:(PCSwipeTableViewCell *)swipeTableViewCell;
@end


@interface PCSwipeTableViewCell : UITableViewCell

@property (nonatomic, strong)	UIView			*leftViewOfCell;
@property (nonatomic, strong)	UIView			*rightViewOfCell;

@property						CGFloat			maximumWidthOfLeftView;
@property						CGFloat			maximumWidthOfRightView;

@property (assign)				id<PCSwipeTableViewCellDelegate> swipeDelegate;

- (void)setLeftView:(UIView *)leftView maximumWidth:(CGFloat)maximumWidth;
- (void)setRightView:(UIView *)rightView maximumWidth:(CGFloat)maximumWidth;

@end
