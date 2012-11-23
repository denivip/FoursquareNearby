//
//  DVTextViewCell.m
//  Together
//
//  Created by Nikolay Morev on 9/12/12.
//  Copyright (c) 2012 DENIVIP Media. All rights reserved.
//

#import "DVTextViewCell.h"


@interface DVTextViewCell ()
@property (nonatomic, strong) UITextView *textView;
@end


@implementation DVTextViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        [self addSubview:self.textView];
    
    }
    return self;
}

@synthesize textView = _textView;

- (UITextView *)textView
{
    if (! _textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectZero];
        _textView.editable = YES;
        _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _textView.backgroundColor = [UIColor clearColor];
    }
    return _textView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textView.frame = CGRectInset(self.bounds, 10.f, 5.f);
}

@end
