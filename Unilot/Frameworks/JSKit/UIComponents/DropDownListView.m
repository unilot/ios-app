//
//  DropDownListView.m
//  JSUIComponents
//
//  Created by Jitendra Singh on 8/5/14.
//  Copyright (c) 2014 JS. All rights reserved.
//

#import "DropDownListView.h"
#import "NSString+JSHelper.h"
#import "UIView+JSLayout.h"

#define DROPDOWNVIEW_SCREENINSET 10
#define DROPDOWNVIEW_HEADER_HEIGHT 40.
#define RADIUS 5

@interface DropDownListView ()
- (void)fadeIn;
- (void)fadeOut;
@end

@implementation DropDownListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        titleFont  = [UIFont boldSystemFontOfSize:15];
        listFont = [UIFont boldSystemFontOfSize:22];
    }
    return self;
}

- (id)initWithTitle:(NSString *)aTitle options:(NSArray *)aOptions isMultiple:(BOOL)isMultiple
{
    isMultipleSelection=isMultiple;
    self.selectedIndex = -1;
    self.selectedIndexes = [NSMutableArray arrayWithCapacity:0];
    CGRect rect = CGRectMake(0, 0,270,200);
    if (self = [super initWithFrame:rect])
    {
        titleFont  = [UIFont boldSystemFontOfSize:15];
        listFont = [UIFont boldSystemFontOfSize:22];
        self.backgroundColor = [UIColor clearColor];
        _titleText = [aTitle copy];
        _dropDownOption = [aOptions copy];
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [self addSubview:_tableView];
        
        [_tableView leftEqualToView:self offset:DROPDOWNVIEW_SCREENINSET];
        [_tableView topEqualToView:self offset:DROPDOWNVIEW_SCREENINSET + DROPDOWNVIEW_HEADER_HEIGHT];
        [_tableView rightEqualToView:self offset:-DROPDOWNVIEW_SCREENINSET];
        [_tableView bottomEqualToView:self offset:DROPDOWNVIEW_SCREENINSET+RADIUS];
        
        [_tableView setTableFooterView:[UIView new]];
        
        UIButton *btnDone=[UIButton  buttonWithType:UIButtonTypeRoundedRect];
        NSString *btnTitle = (isMultiple) ? @"Done" : @"Close";
        [btnDone setTitle:btnTitle forState:UIControlStateNormal];
        [btnDone addTarget:self action:@selector(Click_Done) forControlEvents: UIControlEventTouchUpInside];
        [self addSubview:btnDone];
        [btnDone rightEqualToView:self offset:-10];
        [btnDone topEqualToView:self offset:DROPDOWNVIEW_SCREENINSET];
        [btnDone heightEqualTo:@30];
        [btnDone widthEqualTo:@70];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_titleLabel setText:_titleText];
        [self addSubview:_titleLabel];
        [_titleLabel leftEqualToView:self offset:DROPDOWNVIEW_SCREENINSET+10];
        [_titleLabel topEqualToView:self offset:DROPDOWNVIEW_SCREENINSET];
        [_titleLabel rightEqualToLeftOfView:btnDone offset:-10];
        [_titleLabel heightEqualTo:@(DROPDOWNVIEW_HEADER_HEIGHT)];
        
        [_titleLabel setFont:titleFont];
        [_titleLabel setTextColor:[UIColor darkTextColor]];
        CGFloat width = [_titleLabel.text widthConstrainedToHeight:_titleLabel.frame.size.height andFont:_titleLabel.font];
        width = width + 120 + (2 * DROPDOWNVIEW_SCREENINSET);
        for (NSString *val in aOptions)
        {
            CGFloat itemWidth = [val widthConstrainedToHeight:30 andFont:listFont]+50;
            width = MAX(width, itemWidth);
        }
        
        NSInteger optionCount = (aOptions.count) ? aOptions.count : 1;
        CGFloat height = _tableView.frame.origin.y + MIN(((44 * optionCount) +25), 400);
        CGRect selfFrame = self.frame;
        selfFrame.size.width = width + (2 * DROPDOWNVIEW_SCREENINSET) + 40;
        selfFrame.size.height = height;
        self.frame = selfFrame;
        
    }
    
    [self registerForNotifications];
    return self;
}

- (void)dealloc
{
    self.selectedIndexes = nil;
    self.delegate = nil;
    _tableView = nil;
    _titleLabel = nil;
    _titleText = nil;
    _dropDownOption = nil;
    titleFont = nil;
    listFont = nil;
}

-(void)Click_Done{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(dropDownListView:didSelectedIndexes:)]) {
        if (isMultipleSelection) {
            [self.delegate dropDownListView:self didSelectedIndexes:self.selectedIndexes];
        }
        else
        {
            [self.delegate dropDownListViewDidCancel];
        }
    }
    
    // dismiss self
    [self fadeOut];
}


#pragma mark - Instance Methods
- (void)showInView:(UIView *)aView animated:(BOOL)animated
{
    UIView *placeHolderView = [UIView new];
    [aView addSubview:placeHolderView];
    [placeHolderView leftEqualToView:placeHolderView.superview];
    [placeHolderView rightEqualToView:placeHolderView.superview];
    [placeHolderView topEqualToView:placeHolderView.superview];
    [placeHolderView bottomEqualToView:placeHolderView.superview];
    
    [placeHolderView addSubview:self];
    [self leftEqualToView:self.superview offset:50];
    [self rightEqualToView:self.superview offset:-50];
    [self topEqualToView:self.superview offset:100];
    [self bottomEqualToView:self.superview offset:100];
    
    if (animated) {
        [self fadeIn];
    }
    [self performSelector:@selector(scrollToSelectedOption) withObject:nil afterDelay:0.5];
}

- (void)scrollToSelectedOption
{
    if (self.selectedIndex >= 0) {
        NSIndexPath *index = [NSIndexPath indexPathForRow:self.selectedIndex inSection:0];
        [_tableView scrollToRowAtIndexPath:index atScrollPosition:(UITableViewScrollPositionMiddle) animated:YES];
    }
}

#pragma mark - Tableview datasource & delegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 1;
    if ([_dropDownOption count]) {
        rows = [_dropDownOption count];
    }
    return rows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentity = @"DropDownViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor darkTextColor];
    cell.textLabel.font = listFont;
    
    
    if (_dropDownOption.count) {
        cell.textLabel.text = [_dropDownOption objectAtIndex:indexPath.row] ;
        if([self.selectedIndexes containsObject:indexPath])
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else if (self.selectedIndex == indexPath.row)
        {
            [cell setAccessoryType:(UITableViewCellAccessoryCheckmark)];
        }
        else
        {
            [cell setAccessoryType:(UITableViewCellAccessoryNone)];
        }
    }
    else {
        cell.textLabel.text = @"No Records";
        [cell setAccessoryType:(UITableViewCellAccessoryNone)];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_dropDownOption.count) {
        if (isMultipleSelection) {
            if([self.selectedIndexes containsObject:indexPath]){
                [(NSMutableArray*)self.selectedIndexes removeObject:indexPath];
            } else {
                [(NSMutableArray*)self.selectedIndexes addObject:indexPath];
            }
            [tableView reloadData];
            
        }
        else{
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(dropDownListView:didSelectedIndex:)]) {
                [self.delegate dropDownListView:self didSelectedIndex:[indexPath row]];
            }
            // dismiss self
            [self fadeOut];
        }
    }
    else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(dropDownListView:didSelectedIndex:)]) {
            [self.delegate dropDownListView:self didSelectedIndex:-1];
        }
        [self fadeOut];
    }
    
    
}

#pragma mark - Private Methods
- (void)fadeIn
{
    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        [self.superview setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:.46]];
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
    
}
- (void)fadeOut
{
    [self unregisterFromNotifications];
    [UIView animateWithDuration:.35 animations:^{
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.alpha = 0.0;
        [self.superview setBackgroundColor:[UIColor clearColor]];
    } completion:^(BOOL finished) {
        if (finished) {
            [self.superview removeFromSuperview];
            [self removeFromSuperview];
        }
    }];
}

#pragma mark - DrawDrawDraw
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGRect bgRect = CGRectInset(rect, DROPDOWNVIEW_SCREENINSET, DROPDOWNVIEW_SCREENINSET);
    
    CGRect separatorRect = CGRectMake(DROPDOWNVIEW_SCREENINSET, DROPDOWNVIEW_SCREENINSET + DROPDOWNVIEW_HEADER_HEIGHT - 2,
                                      rect.size.width - 2 * DROPDOWNVIEW_SCREENINSET, 2);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // Draw the background with shadow
    CGContextSetShadowWithColor(ctx, CGSizeZero, 6., [UIColor colorWithWhite:0.1 alpha:1.0].CGColor);
    [[UIColor colorWithRed:R green:G blue:B alpha:A] setFill];
    
    float x = DROPDOWNVIEW_SCREENINSET;
    float y = DROPDOWNVIEW_SCREENINSET;
    float width = bgRect.size.width;
    float height = bgRect.size.height;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, x, y + RADIUS);
    CGPathAddArcToPoint(path, NULL, x, y, x + RADIUS, y, RADIUS);
    CGPathAddArcToPoint(path, NULL, x + width, y, x + width, y + RADIUS, RADIUS);
    CGPathAddArcToPoint(path, NULL, x + width, y + height, x + width - RADIUS, y + height, RADIUS);
    CGPathAddArcToPoint(path, NULL, x, y + height, x, y + height - RADIUS, RADIUS);
    CGPathCloseSubpath(path);
    CGContextAddPath(ctx, path);
    CGContextFillPath(ctx);
    CGPathRelease(path);
    
    // Draw the separator with shadow
    CGContextSetShadowWithColor(ctx, CGSizeMake(0, 1), 0.5f, [UIColor blackColor].CGColor);
    [[UIColor colorWithWhite:0.7 alpha:1.] setFill];
    CGContextFillRect(ctx, separatorRect);
    
}

- (void)setBackgroundColorForList:(UIColor *)backgroundColor
{
    [backgroundColor getRed:&R green:&G blue:&B alpha:&A];
    A = 1.0;
}


#pragma mark - Notifications

- (void)registerForNotifications {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(deviceOrientationDidChange:)
               name:UIDeviceOrientationDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)unregisterFromNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)deviceOrientationDidChange:(NSNotification *)notification {
    
    [self setNeedsDisplay];
    
}


@end
