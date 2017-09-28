//
//  JSDropdownField.m
//  JSUIComponents
//
//  Created by Jitendra Singh on 8/5/14.
//  Copyright (c) 2014 JS. All rights reserved.
//

#import "JSDropdownField.h"
#import "NSString+JSHelper.h"

@interface NSArray (Dropdown)

- (NSInteger)indexOfObjectHavingValue:(id)value forKey:(NSString*)key;
- (NSDictionary *)dictionaryMappingWithKey:(NSString *)key;
- (NSDictionary *)mappingWithValueForKey:(NSString*)keyKey toValueForKey:(NSString*)valueKey;

@end

@interface PopoverVC : UIViewController

@end

@interface JSDropdownField ()

@property (nonatomic, strong) UIImage *activeModeDownArrowImage;
@property (nonatomic, strong) UIImage *inActiveModeDownArrowImage;

@end

@interface DropdownFieldGlobals : NSObject

@property (atomic, strong) UIPopoverController *popover;

@end

@implementation DropdownFieldGlobals

+ (instancetype)sharedGlobals {
    static dispatch_once_t predicate;
    static DropdownFieldGlobals *instance = nil;
    dispatch_once(&predicate, ^{
        instance = [[DropdownFieldGlobals alloc] init];
        
    });
    return instance;
}

@end


@implementation JSDropdownField




- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self makeDropdown];
        _showList = YES;
        _selectedIndex = -1;
    }
    return self;
}

- (void)dealloc
{
    self.optionArray = nil;
    self.displayOptionKey = nil;
    self.optionValueMap = nil;
    self.callback = nil;
    self.shouldShowDropdownBlock = nil;
    self.listContainerView = nil;
    _button = nil;
    _dropdownList = nil;
    [DropdownFieldGlobals sharedGlobals].popover = nil;
}

- (void)setRightOffset:(CGFloat)rightOffset
{
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    UIView *iv = (UIView*)[self.rightView viewWithTag:999];
    CGRect f = iv.frame;
    [iv setBackgroundColor:[UIColor clearColor]];
    
    if (!self.isValid && f.size.width <=40)
    {
        [self setRightView:nil];
        UIButton *b = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [b setFrame:CGRectMake(f.size.width, 0, self.bounds.size.height, self.bounds.size.height)];
        [b setTag:911];
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        [b addTarget:self action:@selector(toggleValidationError) forControlEvents:(UIControlEventTouchUpInside)];
#pragma clang diagnostic pop
        
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [l setText:@"!"];
        [l setFont:[UIFont boldSystemFontOfSize:30]];
        [l setTextColor:[UIColor whiteColor]];
        [l setBackgroundColor:[UIColor redColor]];
        [l setTextAlignment:(NSTextAlignmentCenter)];
        [l.layer setCornerRadius:15];
        [l.layer setMasksToBounds:YES];
        [b addSubview:l];
        l.center = CGPointMake(CGRectGetMidX(b.bounds), CGRectGetMidY(b.bounds));
        
        [iv addSubview:b];
        f.origin.x = f.origin.y = 0;
        f.size.width = f.size.width + self.frame.size.height;
        f.size.height = self.frame.size.height;
        iv.frame = f;
        [self setRightView:iv];
        _button.frame = CGRectInset(self.bounds, self.frame.size.height/2, 0.0);
        _button.frame = CGRectOffset(_button.frame, -(self.frame.size.height/2), 0.0);
        b = nil;
        l = nil;
        iv = nil;
        
    }
    else if (self.isValid && f.size.width > 40){
        [self setRightView:nil];
        UIButton *b = (UIButton*)[iv viewWithTag:911];
        [b removeFromSuperview];
        f.size.width = f.size.width - self.frame.size.height;
        f.size.height = self.frame.size.height;
        f.origin.x = f.origin.y = 0;
        iv.frame = f;
        [self setRightView:iv];
        [_button setFrame:self.bounds];
    }
    else
    {
        [_button setFrame:self.bounds];
    }
}

- (void)setBorderColor:(UIColor *)borderColor
{
    [super setBorderColor:borderColor];
    _borderColorWasSet = YES;
}

- (void)activate
{
    [self performSelector:@selector(buttonWasPressed) withObject:nil afterDelay:0.0];
}

- (BOOL)becomeFirstResponder
{
    [self activate];
    return NO;
}

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    UIImageView *iv = [self.rightView viewWithTag:10989];
    [iv setImage:(enabled) ? self.activeModeDownArrowImage : self.inActiveModeDownArrowImage];
}

#pragma mark - Dropdown

- (void)makeDropdown
{
    if (self.borderColor == nil) {
        [self setBorderColor:[UIColor grayColor]];
    }
    _holdRightOffset = self.rightOffset;
    self.rightOffset = 0;
    
    UIView *mV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, self.frame.size.height)];
    [mV setTag:999];
    
    if (!self.activeModeDownArrowImage) {
        self.activeModeDownArrowImage = [self downArrowImageWithSize:CGSizeMake(40, self.frame.size.height)];
    }
    
    if (!self.inActiveModeDownArrowImage) {
        self.inActiveModeDownArrowImage = [self inActiveDownArrowImageWithSize:CGSizeMake(40, self.frame.size.height)];
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:self.activeModeDownArrowImage];
    [imageView setContentMode:UIViewContentModeBottomLeft];
    [mV addSubview:imageView];
    [imageView setTag:10989];
    
    _button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [mV addSubview:_button];
    [self setRightView:mV];
    mV = nil;
    [_button setFrame:self.bounds];
    [_button addTarget:self action:@selector(buttonWasPressed) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)buttonWasPressed
{
    if(![DropdownFieldGlobals sharedGlobals].popover.popoverVisible)
    {
        [self.window endEditing:YES];
        [_dropdownList fadeOut];
        
        [self showPopUpWithTitle:self.placeholder withOption:self.optionArray isMultiple:NO];
        if (_selectedIndex >= 0) {
            [_dropdownList setSelectedIndex:_selectedIndex];
        }
    }
    
}

- (void)selectOption:(NSString *)option
{
    if (option == nil) {
        [self clearSelection];
        return;
    }
    NSInteger index = [self.optionArray indexOfObject:option];
    if (index != NSNotFound) {
        [self selectOptionAtIndex:index];
    }
    
    
}

- (void)selectOptionHavingValue:(id)value forKey:(NSString*)key
{
    if (value == nil) {
        [self clearSelection];
        return;
    }
    if (self.displayOptionKey) {
        NSInteger index = 0;
        for (NSString *akey in self.optionArray)
        {
            id obj = [_optionValueMap objectForKey:akey];
            if (value && [value isKindOfClass:[NSString class]]) {
                if ([value caseInsensitiveCompare:[obj valueForKey:key]] == NSOrderedSame) {
                    _selectedIndex = index;
                    super.text = akey;
                    break;
                }
            }
            else if (value && [value isKindOfClass:[NSNumber class]]) {
                if ([value isEqualToNumber:[obj valueForKey:key]]) {
                    _selectedIndex = index;
                    super.text = akey;
                    break;
                }
            }
            else {
                if (value && value == [obj valueForKey:key]) {
                    _selectedIndex = index;
                    super.text = akey;
                    break;
                }
            }
            index++;
        }
        
    }
}

- (void)selectOptionAtIndex:(NSInteger)index
{
    _selectedIndex = index;
    if (self.displayOptionKey) {
        NSString *key = [self.optionArray objectAtIndex:_selectedIndex];
        id obj = [_optionValueMap objectForKey:key];
        
        super.text = [obj valueForKey:self.displayOptionKey];
    }
    else if (self.optionArray.count){
        super.text = [self.optionArray objectAtIndex:_selectedIndex];
    }
}

- (void)clearSelection
{
    _selectedIndex = -1;
    super.text = nil;
}

- (void)setDisplayOptionKey:(NSString *)displayOptionKey
{
    if (self.optionArray.count && NSStringHasData(displayOptionKey) && [displayOptionKey caseInsensitiveCompare:_displayOptionKey] != NSOrderedSame) {
        _displayOptionKey = displayOptionKey;
        NSDictionary *dict = [self.optionArray dictionaryMappingWithKey:_displayOptionKey];
        _optionValueMap = dict;
        _optionArray = [[_optionValueMap allKeys]sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)] ;
    }
}

- (void)setOptionArray:(NSArray *)optionArray
{
    if (NSStringHasData(self.displayOptionKey)) {
        NSDictionary *dict = [optionArray dictionaryMappingWithKey:_displayOptionKey];
        _optionValueMap = dict;
        _optionArray = [[_optionValueMap allKeys]sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)] ;
    }
    else
    {
        _optionArray = optionArray;
    }
}

- (id)selectedValue
{
    if (self.optionValueMap){
        return [self.optionValueMap objectForKey:super.text];
    }
    else if (_selectedIndex >= 0) {
        id obj = [self.optionArray objectAtIndex:_selectedIndex];
        return obj;
    }
    return nil;
}

#pragma mark - Custom Setter

- (void)setOptionValueMap:(NSDictionary *)optionValueMap
{
    _optionValueMap = optionValueMap;
    _optionArray = [[optionValueMap allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)] ;
}

- (void)setText:(NSString *)text
{
    // this is not available for dropdown so overide the imlementation of super class
}



#pragma mark - DropDownListView
-(void)showPopUpWithTitle:(NSString*)popupTitle withOption:(NSArray*)arrOptions isMultiple:(BOOL)isMultiple{
    
    if (self.shouldShowDropdownBlock) {
        BOOL show = self.shouldShowDropdownBlock(self);
        if (!show) {
            return;
        }
    }
    [self.listContainerView resignFirstResponder];
    _dropdownList = nil;
    _dropdownList = [[DropDownListView alloc] initWithTitle:popupTitle options:arrOptions isMultiple:isMultiple];
    _dropdownList.delegate = self;
    [_dropdownList setBackgroundColorForList:[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0]];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if(![DropdownFieldGlobals sharedGlobals].popover.popoverVisible)
        {
            PopoverVC* popoverContent = [[PopoverVC alloc] init];
            popoverContent.view = _dropdownList;
            if ([popoverContent respondsToSelector:@selector(preferredContentSize)])
            {
                [popoverContent setPreferredContentSize:_dropdownList.frame.size];
            }
//            else if ([popoverContent respondsToSelector:@selector(contentSizeForViewInPopover)])
//            {
//                [popoverContent setContentSizeForViewInPopover:_dropdownList.frame.size];
//            }
            
            if(self.window)
            {
                UIPopoverController *popOverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
                popOverController.passthroughViews = [NSArray arrayWithObject:self];
                popOverController.delegate = self;
                CGRect rect = [self frame];
                if (!popOverController.popoverVisible) {
                    [popOverController presentPopoverFromRect:rect inView:self.superview permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                    [DropdownFieldGlobals sharedGlobals].popover = popOverController;
                }
            }
            popoverContent = nil;
        }
    }
    else
    {
        if (self.listContainerView) {
            [_dropdownList showInView:self.listContainerView animated:YES];
        }
        else {
            [_dropdownList showInView:self.window animated:YES];
        }
        
    }
}

- (void)dropDownListView:(DropDownListView *)dropdownListView didSelectedIndex:(NSInteger)anIndex{
    if (self.optionArray.count && anIndex >= 0 && anIndex < self.optionArray.count) {
        super.text = [self.optionArray objectAtIndex:anIndex];
        _selectedIndex = anIndex;
         
        if (self.callback) {
            self.callback(self, (int) _selectedIndex, self.selectedValue);
        }
    }
    [[DropdownFieldGlobals sharedGlobals].popover dismissPopoverAnimated:YES];
    [DropdownFieldGlobals sharedGlobals].popover = nil;
}

- (void)dropDownListView:(DropDownListView *)dropdownListView didSelectedIndexes:(NSArray *)indexes
{
    [[DropdownFieldGlobals sharedGlobals].popover dismissPopoverAnimated:YES];
    [DropdownFieldGlobals sharedGlobals].popover = nil;
}

- (void)dropDownListViewDidCancel
{
    [[DropdownFieldGlobals sharedGlobals].popover dismissPopoverAnimated:YES];
    [DropdownFieldGlobals sharedGlobals].popover = nil;
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [DropdownFieldGlobals sharedGlobals].popover = nil;
}

- (UIImage *)downArrowImageWithSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    
    [self.borderColor setFill];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth = 1.0;
    CGFloat halfWidth = size.width/2;
    CGFloat halfHeight = size.height/2;
    [path moveToPoint:CGPointMake(halfWidth, halfHeight)];
    [path addLineToPoint:CGPointMake(halfWidth + 5, halfHeight - 5)];
    [path addLineToPoint:CGPointMake(halfWidth + 5 + 3, halfHeight - 5)];
    [path addLineToPoint:CGPointMake(halfWidth, halfHeight + 3)];
    [path addLineToPoint:CGPointMake(halfWidth - 5 - 3, halfHeight - 5)];
    [path addLineToPoint:CGPointMake(halfWidth - 5, halfHeight - 5)];
    [path closePath];
    [path fill];
    [path stroke];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return(theImage);
}

- (UIImage *)inActiveDownArrowImageWithSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    
    [[UIColor lightGrayColor] setFill];
    [[UIColor lightGrayColor] setStroke];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth = 1.0;
    CGFloat halfWidth = size.width/2;
    CGFloat halfHeight = size.height/2;
    [path moveToPoint:CGPointMake(halfWidth, halfHeight)];
    [path addLineToPoint:CGPointMake(halfWidth + 5, halfHeight - 5)];
    [path addLineToPoint:CGPointMake(halfWidth + 5 + 3, halfHeight - 5)];
    [path addLineToPoint:CGPointMake(halfWidth, halfHeight + 3)];
    [path addLineToPoint:CGPointMake(halfWidth - 5 - 3, halfHeight - 5)];
    [path addLineToPoint:CGPointMake(halfWidth - 5, halfHeight - 5)];
    [path closePath];
    [path fill];
    [path stroke];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return(theImage);
}


@end



@implementation PopoverVC

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    DropDownListView *_dropdownList = (DropDownListView*)self.view;
    [_dropdownList performSelector:@selector(scrollToSelectedOption) withObject:nil afterDelay:0.0];
}

@end







@implementation NSArray (Dropdown)

- (NSInteger)indexOfObjectHavingValue:(id)value forKey:(NSString*)key
{
    if (!value || !key) {
        return NSNotFound;
    }
    NSInteger index = NSNotFound;
    NSInteger count = 0;
    for (id obj in self)
    {
        id val = [obj objectForKey:key];
        if (value == val) {
            index = count;
            break;
        }
        count++;
    }
    return index;
}

- (NSDictionary *)dictionaryMappingWithKey:(NSString *)key
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
    for (id obj in self)
    {
        NSString *val = [obj valueForKey:key];
        if (NSStringHasData(val)) {
            [dict setValue:obj forKey:val];
        }
    }
    return [[NSDictionary alloc] initWithDictionary:dict];
}

- (NSDictionary *)mappingWithValueForKey:(NSString*)keyKey toValueForKey:(NSString*)valueKey
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
    for (id obj in self)
    {
        NSString *newKey = [obj valueForKey:keyKey];
        id newValue = [obj valueForKey:valueKey];
        if (NSStringHasData(newKey)) {
            [dict setValue:newValue forKey:newKey];
        }
    }
    return [[NSDictionary alloc] initWithDictionary:dict];
}


@end
