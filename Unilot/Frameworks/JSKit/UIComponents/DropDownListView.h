//
//  DropDownListView.h
//  JSUIComponents
//
//  Created by Jitendra Singh on 8/5/14.
//  Copyright (c) 2014 JS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DropDownListView;
@protocol DropDownListViewDelegate <NSObject>
- (void)dropDownListView:(DropDownListView *)dropdownListView didSelectedIndex:(NSInteger)anIndex;
- (void)dropDownListView:(DropDownListView *)dropdownListView didSelectedIndexes:(NSArray *)indexes;
- (void)dropDownListViewDidCancel;
@end


@interface DropDownListView : UIView <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableView;
    UILabel *_titleLabel;
    NSString *_titleText;
    CGFloat R,G,B,A;
    NSArray *_dropDownOption;
    BOOL isMultipleSelection;
    
    UIFont *titleFont;
    UIFont *listFont;
}

@property (nonatomic, strong) NSArray *selectedIndexes;
@property (nonatomic, weak) id<DropDownListViewDelegate> delegate;
@property (nonatomic, assign) NSInteger selectedIndex;

- (void)fadeOut;

// The options is a NSArray, contain some NSDictionaries, the NSDictionary contain 2 keys, one is "img", another is "text".
- (id)initWithTitle:(NSString *)aTitle options:(NSArray *)aOptions isMultiple:(BOOL)isMultiple;

// If animated is YES, PopListView will be appeared with FadeIn effect.
- (void)showInView:(UIView *)aView animated:(BOOL)animated;
- (void)setBackgroundColorForList:(UIColor *)backgroundColor;
- (void)scrollToSelectedOption;
@end
