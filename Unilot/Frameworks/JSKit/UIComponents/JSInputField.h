//
//  JSInputField.h
//  JSUIComponents
//
//  Created by Jitendra Singh on 7/23/14.
//  Copyright (c) 2014 JS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropDownListView.h"
#import "JSRule.h"

/***********************************************************************
 *
 *  JSInputField is inspired by JVFloatLabeledTextField.
 *  https://github.com/jverdi/JVFloatLabeledTextField
 *  
 *  JSInputField add ability to add validation rules directly to the textfield.
 *  This can save a lot of time by avoiding implementation of delegate methods
 *  avoiding repeatetive code for validations.
 *
 ***********************************************************************/

@interface JSInputField : UITextField 
{
    UILabel *_floatingLabel;
    CAShapeLayer *_frameLayer;
    NSMutableArray *_validationRules;
    NSError *_validationError;
    
}

/***********************************************************************
 *
 *  Content offsets from edges
 *  Defaults:
 *  leftOffset = 5
 *  rightOffset = 0
 *  bottomOffset = 0
 *  topOffset = 0
 *
 ***********************************************************************/
@property (nonatomic, assign) CGFloat leftOffset;
@property (nonatomic, assign) CGFloat rightOffset;
@property (nonatomic, assign) CGFloat bottomOffset;
@property (nonatomic, assign) CGFloat topOffset;
@property (nonatomic, strong) UIColor *ActiveModePlaceHolderColor;
@property (nonatomic, assign) NSInteger ParentId;



/***********************************************************************
 *
 *  setting roundedCorners will add border to field. Default is no border.
 *  This setting recommended over using 'borderStyle'.
 *
 ***********************************************************************/
@property (nonatomic, assign) UIRectCorner roundedCorners;


/***********************************************************************
 *
 *  set to change the border color. Default is gray.
 *
 ***********************************************************************/
@property (nonatomic, strong) UIColor *borderColor;


/***********************************************************************
 *
 *  set to change floating label font. Default is Italics with size 12.
 *
 ***********************************************************************/
@property (nonatomic, strong) UIFont *floatingLabelFont;

/***********************************************************************
 *
 *  set to change floating label text color. Default is light gray.
 *
 ***********************************************************************/
@property (nonatomic, strong) UIColor *floatingLabelTextColor;

/***********************************************************************
 *
 *  Set to hide/show floating label. Default is NO.
 *
 ***********************************************************************/
@property (nonatomic, assign) BOOL disableFloatLabel;


/***********************************************************************
 *
 *  These are the helper blocks to skip implementation of delegate methods.
 *  If delegate methods will be called if are implemented along with these blocks.
 *
 ***********************************************************************/
@property (nonatomic, copy) void(^endEditingBlock)(JSInputField *field);
@property (nonatomic, copy) void(^beginEditingBlock)(JSInputField *field);
@property (nonatomic, copy) void(^valueChangedBlock)(JSInputField *field);

- (void)setEndEditingBlock:(void (^)(JSInputField *field))endEditingBlock;
- (void)setBeginEditingBlock:(void (^)(JSInputField *field))beginEditingBlock;
- (void)setValueChangedBlock:(void (^)(JSInputField *field))valueChangedBlock;


- (void)initialize;

/***********************************************************************
 *
 *  Returns if the data is valid as per applied rules.
 *
 ***********************************************************************/
@property (nonatomic, assign) BOOL isValid;


/***********************************************************************
 *
 *  Add validation rules to input data. Data entered will be validated with all applied rules.
 *  Use EIRule to create rules and add to field
 *
 ***********************************************************************/
- (void)addValidationRule:(id)rule;


/***********************************************************************
 *
 *  Remove and applied rule. To use this you should keep object of any rule stored in a variable
 *
 ***********************************************************************/
- (void)removeValidationRule:(id)rule;


/***********************************************************************
 *
 *  Removes all validation rules
 *
 ***********************************************************************/
- (void)removeAllValidationRule;


/***********************************************************************
 *
 *  For any other custom rule this block can be used. This block is executed when field is validating data with any other rules.
 *
 ***********************************************************************/
@property (nonatomic, copy) NSError *(^customValidationBlock)(JSInputField *field);
- (void)setCustomValidationBlock:(NSError *(^)(JSInputField *field))customValidationBlock;

@end
