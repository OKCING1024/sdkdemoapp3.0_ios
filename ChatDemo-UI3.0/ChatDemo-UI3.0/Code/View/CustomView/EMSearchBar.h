/************************************************************
  *  * Hyphenate CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2016 Hyphenate Inc. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of Hyphenate Inc.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from Hyphenate Inc.
  */

#import <UIKit/UIKit.h>

@interface EMSearchBar : UISearchBar

@property (nonatomic, assign) CGFloat searchFieldWidth;

@property (nonatomic, assign) CGFloat searchFieldHeight;

- (void)setCancelButtonTitle:(NSString *)title;

- (void)setCancelEnable:(BOOL)isEnable;

- (BOOL)isCancelEnable;

@end
