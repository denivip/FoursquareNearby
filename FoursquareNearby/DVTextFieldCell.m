//
//  DVTextFieldCell.m
//  Together
//
//  Created by Nikolay Morev on 9/12/12.
//  Copyright (c) 2012 DENIVIP Media. All rights reserved.
//

#import "DVTextFieldCell.h"


@interface DVTextFieldCell ()
@end


@implementation DVTextFieldCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.textField];
    }
    return self;
}

- (UITextField *)textField
{
    if (! _textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectZero];
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth;
        _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    }
    return _textField;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat originX = CGRectGetMaxX([self convertRect:self.textLabel.bounds
                                             fromView:self.textLabel]);
    CGRect frame = CGRectMake(originX,
                              0,
                              CGRectGetMaxX(self.bounds) - originX,
                              CGRectGetHeight(self.bounds));
    frame = CGRectInset(frame, 20.f, 5.f);
    self.textField.frame = frame;
}

@end
