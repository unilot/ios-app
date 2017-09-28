//
//  JSInputField.m
//  JSUIComponents
//
//  Created by Jitendra Singh on 7/23/14.
//  Copyright (c) 2014 JS. All rights reserved.
//

#import "JSInputField.h"
#import "NSString+JSHelper.h"




@interface JSInputField ()
@property (nonatomic, strong) UIColor *activeTextColor;
@property (nonatomic, strong) UIColor *activeFloatingTextColor;


- (void)toggleValidationError;
- (BOOL)validate;

@end

@implementation JSInputField
@synthesize leftOffset = _leftOffset;
@synthesize rightOffset = _rightOffset;
@synthesize bottomOffset = _bottomOffset;
@synthesize topOffset = _topOffset;
@synthesize roundedCorners = _roundedCorners;
@synthesize ActiveModePlaceHolderColor;
@synthesize ParentId;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    ActiveModePlaceHolderColor  = [UIColor whiteColor];

    
    self.leftViewMode = self.rightViewMode = UITextFieldViewModeAlways;
    _floatingLabelFont = [UIFont italicSystemFontOfSize:12.0f];
    _floatingLabelTextColor = [UIColor whiteColor];
    
    __block typeof(self) weakSelf = self;
    [self addTarget:weakSelf action:@selector(textFieldEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
    [self addTarget:weakSelf action:@selector(textFieldStartedEditing:) forControlEvents:UIControlEventEditingDidBegin];
    [self addTarget:weakSelf action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    
    [self floatingLabel];
    
    [self setLeftOffset:5];
    self.isValid = YES;
}


- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    if (!enabled) {
        if (!self.activeTextColor) {
            self.activeTextColor = self.textColor;
        }
        if (!self.activeFloatingTextColor) {
            self.activeFloatingTextColor = _floatingLabel.textColor;
        }
        UIColor *disableModeColor = [UIColor colorWithWhite:0.71 alpha:1.0];
        _floatingLabel.textColor = self.textColor = disableModeColor;
        if (NSStringHasData(_floatingLabel.text)) {
            [self setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:_floatingLabel.text attributes:@{NSForegroundColorAttributeName:disableModeColor}]];
        }
    }
    else {
        if (self.activeTextColor) {
            self.textColor = self.activeTextColor;
        }
        if (self.activeFloatingTextColor) {
            _floatingLabel.textColor = self.activeFloatingTextColor;
        }
        if (NSStringHasData(_floatingLabel.text)) {
            [self setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:_floatingLabel.text attributes:@{NSForegroundColorAttributeName:ActiveModePlaceHolderColor}]];
        }
    }
}

- (void)dealloc
{
    self.borderColor = nil;
    self.floatingLabelFont = nil;
    self.floatingLabelTextColor = nil;
    self.customValidationBlock = nil;
    
    _floatingLabel = nil;
    _frameLayer = nil;
    _validationRules = nil;
    _validationError = nil;
    
    __block typeof(self) weakSelf = self;
    [self removeTarget:weakSelf action:@selector(textFieldEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
    [self removeTarget:weakSelf action:@selector(textFieldStartedEditing:) forControlEvents:UIControlEventEditingDidBegin];
    [self removeTarget:weakSelf action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    
    self.endEditingBlock = nil;
    self.beginEditingBlock = nil;
    self.valueChangedBlock = nil;
}

- (void) textFieldEndEditing:(JSInputField*)textField
{
    //self.isActive = NO;
    if (self.endEditingBlock) {
        self.endEditingBlock(self);
    }
}

- (void) textFieldStartedEditing:(JSInputField*)textField
{
    //self.isActive = YES;
    [self setAutocorrectionType:UITextAutocorrectionTypeNo];
    [self handleValidationStatus];
    if (self.beginEditingBlock) {
        self.beginEditingBlock(self);
    }
}

- (void) textFieldEditingChanged:(JSInputField*)textField
{
    [self handleValidationStatus];
    if (self.valueChangedBlock) {
        self.valueChangedBlock(self);
    }
}

- (UILabel*)floatingLabel
{
    if (_floatingLabel) {
        return _floatingLabel;
    }
    if (_disableFloatLabel) {
        return nil;
    }
    _floatingLabel = [UILabel new];
    _floatingLabel.alpha = 0.0f;
    [self addSubview:_floatingLabel];
    
    // some basic default fonts/colors
    _floatingLabel.font = _floatingLabelFont;
    _floatingLabel.textColor = _floatingLabelTextColor;
    
    return _floatingLabel;
}

- (void)setDisableFloatLabel:(BOOL)disableFloatLabel
{
    _disableFloatLabel = disableFloatLabel;
    if (_disableFloatLabel) {
        _floatingLabel = nil;
    }
    else {
        [self floatingLabel];
    }
}

- (void)setFloatingLabelFont:(UIFont *)floatingLabelFont
{
    _floatingLabelFont = floatingLabelFont;
    _floatingLabel.font = _floatingLabelFont;
    self.placeholder = self.placeholder;
}

- (void)setFloatingLabelTextColor:(UIColor *)floatingLabelTextColor
{
    _floatingLabelTextColor = floatingLabelTextColor;
    _floatingLabel.textColor = _floatingLabelTextColor;
    self.activeFloatingTextColor = _floatingLabel.textColor;
}

- (void)showFloatingLabel:(BOOL)animated
{
    void (^showBlock)() = ^{
        _floatingLabel.alpha = 1.0f;
        _floatingLabel.frame = CGRectMake(_leftOffset,
                                          2.0f+_topOffset,
                                          self.bounds.size.width - _leftOffset - _rightOffset,
                                          _floatingLabel.frame.size.height);
    };
    
    if (animated) {
        [UIView animateWithDuration:0.3
                              delay:0.0f
                            options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseOut
                         animations:showBlock
                         completion:nil];
    }
    else {
        showBlock();
    }
}

- (void)hideFloatingLabel:(BOOL)animated
{
    void (^hideBlock)() = ^{
        _floatingLabel.alpha = 0.0f;
        _floatingLabel.frame = CGRectMake(_leftOffset,
                                          _floatingLabel.font.lineHeight,
                                          self.bounds.size.width - _leftOffset - _rightOffset,
                                          _floatingLabel.frame.size.height);
        
    };
    
    if (animated) {
        [UIView animateWithDuration:0.3
                              delay:0.0f
                            options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseIn
                         animations:hideBlock
                         completion:nil];
    }
    else {
        hideBlock();
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

- (CGRect)textRectForBounds:(CGRect)bounds
{
    if (self.text.length && self.placeholder.length) {
        return UIEdgeInsetsInsetRect([super textRectForBounds:bounds], UIEdgeInsetsMake(ceilf(_floatingLabel.font.lineHeight + _topOffset), 0.0f, _bottomOffset, 0.0f));
    }
    return [super textRectForBounds:bounds];
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    if (self.text.length && self.placeholder.length) {
        return UIEdgeInsetsInsetRect([super editingRectForBounds:bounds], UIEdgeInsetsMake(ceilf(_floatingLabel.font.lineHeight + _topOffset), 0.0f, _bottomOffset, 0.0f));
    }
    return [super editingRectForBounds:bounds];
}

- (CGRect)clearButtonRectForBounds:(CGRect)bounds
{
    CGRect rect = [super clearButtonRectForBounds:bounds];
    rect = CGRectMake(rect.origin.x, rect.origin.y + (_floatingLabel.font.lineHeight / 2.0), rect.size.width, rect.size.height);
    return rect;
}

- (void)setBorderStyle:(UITextBorderStyle)borderStyle
{
    if (self.disableFloatLabel) {
        [super setBorderStyle:borderStyle];
    }
    else {
        if (borderStyle == UITextBorderStyleRoundedRect) {
            [self setRoundedCorners:(UIRectCornerAllCorners)];
        }
        else if (borderStyle == UITextBorderStyleLine) {
            [self setRoundedCorners:(0)];
        }
        else {
            [super setBorderStyle:UITextBorderStyleNone];
        }
    }
    [self setNeedsLayout];
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    [super setTextAlignment:textAlignment];
    
    [self setNeedsLayout];
}

- (void)setPlaceholder:(NSString *)placeholder
{
    //[super setPlaceholder:placeholder];
    if (NSStringHasData(placeholder)) {
        [self setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName:ActiveModePlaceHolderColor}]];
    }
    else {
        [self setAttributedPlaceholder:nil];
    }
    
    _floatingLabel.text = placeholder;
    [_floatingLabel sizeToFit];
    
    CGRect labelRect = _floatingLabel.frame;
    labelRect.origin.x = _leftOffset;
    labelRect.size.width = self.bounds.size.width - _leftOffset - _rightOffset;
    _floatingLabel.frame = labelRect;
}

- (void)setText:(NSString *)text
{
    
    NSString *trimmedText = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [super setText:trimmedText];
    //[self validate];
    [self handleValidationStatus];
}

- (NSString*)text
{
    NSString *val = [super text];
    if (val.length > 0) {
        return val;
    }
    return nil;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    BOOL firstResponder = self.isFirstResponder;
    //_floatingLabel.textColor = (firstResponder && self.text && self.text.length > 0 ? self.getLabelActiveColor : self.floatingLabelTextColor);
    if (!self.text || 0 == [self.text length]) {
        [self hideFloatingLabel:firstResponder];
    }
    else {
        [self showFloatingLabel:firstResponder];
    }
    
    //[self handleValidationStatus];
    
    UIView *v = [self viewWithTag:1911];
    [self bringSubviewToFront:v];
    [self bringSubviewToFront:self.rightView];
}

- (void)setLeftOffset:(CGFloat)leftOffset
{
    _leftOffset = leftOffset;
    [self setLeftView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, _leftOffset, self.bounds.size.height)]];
    CGRect labelRect = _floatingLabel.frame;
    labelRect.origin.x = _leftOffset;
    labelRect.size.width = self.bounds.size.width - _leftOffset - _rightOffset;;
    _floatingLabel.frame = labelRect;
}

- (void)setRightOffset:(CGFloat)rightOffset
{
    _rightOffset = rightOffset;
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _rightOffset, self.bounds.size.height)];
    [v setTag:119];
    [self setRightView:v];
    CGRect labelRect = _floatingLabel.frame;
    labelRect.origin.x = _leftOffset;
    labelRect.size.width = self.bounds.size.width - _leftOffset - _rightOffset;
    _floatingLabel.frame = labelRect;
}

- (void)setTopOffset:(CGFloat)topOffset
{
    _topOffset = topOffset;
    [self setNeedsDisplay];
}

- (void)setBottomOffset:(CGFloat)bottomOffset
{
    _bottomOffset = bottomOffset;
    [self setNeedsDisplay];
}

- (void)setRoundedCorners:(UIRectCorner)roundedCorners
{
    _roundedCorners = roundedCorners;
    
    CGFloat radius = 5;
    CGRect bounds = self.bounds;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds
                                                   byRoundingCorners:_roundedCorners
                                                         cornerRadii:CGSizeMake(radius, radius)];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = bounds;
    maskLayer.path = maskPath.CGPath;
    
    self.layer.mask = maskLayer;
    
    if (_frameLayer) {
        [_frameLayer removeFromSuperlayer];
    }
    _frameLayer = [CAShapeLayer layer];
    _frameLayer.frame = bounds;
    _frameLayer.path = maskPath.CGPath;
    if (_borderColor == nil) {
        _borderColor = [UIColor lightGrayColor];
    }
    _frameLayer.strokeColor = _borderColor.CGColor;
    _frameLayer.fillColor = nil;
    
    
    [self.layer addSublayer:_frameLayer];
}

- (void)setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
    if (_frameLayer) {
        [_frameLayer setStrokeColor:_borderColor.CGColor];
    }
}

#pragma mark - Validation Support

- (void)handleValidationStatus
{
    BOOL oldValue = self.isValid;
    if (![self validate] && (self.rightView.tag == 119 || self.rightView == nil)) {
        CGRect labelRect = _floatingLabel.frame;
        labelRect.size.width = labelRect.size.width - self.bounds.size.height;
        _floatingLabel.frame = labelRect;
        
        UIButton *b = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [b setFrame:CGRectMake(0, 0, self.bounds.size.height, self.bounds.size.height)];
        [b setTag:911];
        [b addTarget:self action:@selector(toggleValidationError) forControlEvents:(UIControlEventTouchUpInside)];
        
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [l setText:@"!"];
        [l setFont:[UIFont boldSystemFontOfSize:30]];
        [l setTextColor:[UIColor whiteColor]];
        [l setBackgroundColor:[UIColor redColor]];
        [l setTextAlignment:(NSTextAlignmentCenter)];
        [l.layer setCornerRadius:15];
        [l.layer setMasksToBounds:YES];
        [b addSubview:l];
        l.center = b.center;
        
        [self setRightView:b];
        l = nil;
        b = nil;
        
    }
    else if (self.isValid && self.rightView.tag == 911)
    {
        UIView *v = [self viewWithTag:1911];
        if (v) {
            [UIView animateWithDuration:0.3 animations:^{
                [v setFrame:CGRectMake(self.frame.size.width, 2, self.frame.size.width-self.frame.size.height, self.frame.size.height-4)];
            } completion:^(BOOL finished) {
                [v removeFromSuperview];
            }];
        }
        [self setRightOffset:_rightOffset];
    }
    else if (self.isValid)
    {
        UIView *v = [self viewWithTag:1911];
        if (v) {
            [UIView animateWithDuration:0.3 animations:^{
                [v setFrame:CGRectMake(self.frame.size.width, 2, self.frame.size.width-self.frame.size.height, self.frame.size.height-4)];
            } completion:^(BOOL finished) {
                [v removeFromSuperview];
            }];
        }
    }
    
    if (self.isValid != oldValue)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateError" object:nil];
    }
    
    
}

- (BOOL)validate
{
    NSString *value = [self.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (!NSStringHasData(value)) {
        value = nil;
    }
    NSError *error = nil;
    if (_validationRules.count > 0) {
        
        [JSRuleApply applyRules:_validationRules toValue:&value forKey:self.placeholder error:&error];
        if (!error && self.customValidationBlock) {
            error = self.customValidationBlock(self);
        }
        if (error) {
            self.isValid = NO;
            _validationError = error;
        }
        else {
            self.isValid = YES;
            _validationError = nil;
        }
    }
    else {
        self.isValid = YES;
        _validationError = nil;
    }
    
    return self.isValid;
}

- (void)toggleValidationError
{
    UIView *v = [self viewWithTag:1911];
    if (v) {
        [UIView animateWithDuration:0.3 animations:^{
            [v setFrame:CGRectMake(self.frame.size.width, 2, self.frame.size.width-self.frame.size.height, self.frame.size.height-4)];
        } completion:^(BOOL finished) {
            [v removeFromSuperview];
            [self becomeFirstResponder];
        }];
    }
    else
    {
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width, 2, self.frame.size.width-self.frame.size.height, self.frame.size.height-4)];
        UIEdgeInsets insets = {0, 5, 0, 5};
        UILabel *l = [[UILabel alloc] initWithFrame:UIEdgeInsetsInsetRect(v.bounds, insets)];
        [v addSubview:l];
        [self addSubview:v];
        [l setText:[_validationError localizedDescription]];
        [v setTag:1911];
        [l setNumberOfLines:0];
        [l setAdjustsFontSizeToFitWidth:YES];
        [l setBackgroundColor:[UIColor clearColor]];
        [v setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.9]];
        [l setTextColor:[UIColor redColor]];
        [self resignFirstResponder];
        [self bringSubviewToFront:self.rightView];
        [UIView animateWithDuration:0.3 animations:^{
            [v setFrame:CGRectMake(4, 2, self.frame.size.width-self.frame.size.height-4, self.frame.size.height-4)];
        } completion:^(BOOL finished) {
            [self resignFirstResponder];
        }];
        
        l = nil;
        v = nil;
    }
}

- (void)setCustomValidationBlock:(NSError *(^)(JSInputField *field))customValidationBlock
{
    _customValidationBlock = [customValidationBlock copy];
    [self handleValidationStatus];
}

- (void)addValidationRule:(id)rule
{
    if (_validationRules == nil) {
        _validationRules = [[NSMutableArray alloc] initWithCapacity:0];
    }
    if ([rule isKindOfClass:[JSRuleNumeric class]] || [rule isKindOfClass:[JSRuleNumberRange class]]) {
        [self setKeyboardType:(UIKeyboardTypeNumberPad)];
    }
    [self removeValidationRuleOfKind:[rule class]];
    [_validationRules addObject:rule];
    [self handleValidationStatus];
}

- (void)removeValidationRuleOfKind:(Class)class
{
    __block id ruleToDelete = nil;
    [_validationRules enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:class]) {
            ruleToDelete = obj;
            *stop = YES;
        }
    }];
    if (ruleToDelete) {
        [_validationRules removeObject:ruleToDelete];
        [self removeValidationRuleOfKind:class];
    }
}

- (void)removeValidationRule:(id)rule
{
    [_validationRules removeObject:rule];
    [self handleValidationStatus];
}

- (void)removeAllValidationRule
{
    [_validationRules removeAllObjects];
    [self handleValidationStatus];
}

@end
