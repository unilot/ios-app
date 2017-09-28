//
//  JSDropdownField.h
//  JSUIComponents
//
//  Created by Jitendra Singh on 8/5/14.
//  Copyright (c) 2014 JS. All rights reserved.
//

#import "JSInputField.h"


@class JSDropdownField;

typedef void (^DropdownMultiSelectionCallback) (JSDropdownField *dropdown, NSArray *selecteIndexes);

@interface JSDropdownField : JSInputField <DropDownListViewDelegate, UIPopoverControllerDelegate>
{
    CGFloat _holdRightOffset;
    BOOL _borderColorWasSet;
    UIButton *_button;
    NSInteger _selectedIndex;
    DropDownListView * _dropdownList;
    BOOL _showList;
}
//Use this if value and display string is same
@property (nonatomic, strong) NSArray *optionArray;

//option array can be collection of NSDictionary or key-value pair object, but this property should be set in that case.
@property (nonatomic, strong) NSString *displayOptionKey;

//use this when value and display string is different. This will overrite optionArray with the keys (sorted) of optionValueMap
@property (nonatomic, strong) NSDictionary *optionValueMap;

//callback block when dropdown finish selection
@property (nonatomic, copy) void(^callback)(JSDropdownField *dropdown, int selecteIndex, id selectedValue);

//callback block when dropdown shows list
@property (nonatomic, copy) BOOL(^shouldShowDropdownBlock)(JSDropdownField *dropdown);

// use this for iPhone to set superView for options list
@property (nonatomic, assign) UIView *listContainerView;

// this is readonly, returns value for selected option.
@property (nonatomic, readonly) id selectedValue;



// Note: Following methods should be called after setting properties above

- (void)selectOption:(NSString *)option;
- (void)selectOptionAtIndex:(NSInteger)index;
- (void)selectOptionHavingValue:(id)value forKey:(NSString*)key;
- (void)setCallback:(void (^)(JSDropdownField *dropdown, int selecteIndex, id selectedValue))callback;
- (void)setShouldShowDropdownBlock:(BOOL (^)(JSDropdownField *dropdown))shouldShowDropdownBlock;
- (void)activate;

@end



