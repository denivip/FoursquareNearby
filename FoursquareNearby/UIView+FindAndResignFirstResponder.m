//
//  UIView+FindAndResignFirstResponder.m
//  Sogaz Lite
//
//  Created by Ilya on 05.10.12.
//  Copyright (c) 2012 Denivip Media. All rights reserved.
//

#import "UIView+FindAndResignFirstResponder.h"

@implementation UIView (FindAndResignFirstResponder)

- (BOOL)findAndResignFirstResponder
{
    if (self.isFirstResponder) {
        [self resignFirstResponder];
        return YES;
    }
    for (UIView *subView in self.subviews) {
        if ([subView findAndResignFirstResponder])
            return YES;
    }
    return NO;
}

@end
