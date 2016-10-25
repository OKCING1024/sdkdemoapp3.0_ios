//
//  EMChatToolBar.m
//  ChatDemo-UI3.0
//
//  Created by EaseMob on 16/9/23.
//  Copyright © 2016年 easemob. All rights reserved.
//

#import "EMChatToolBar.h"

#import "EMChatRecordView.h"
#import "EMMessageTextView.h"
#import "EMConvertToCommonEmoticonsHelper.h"

#define kDefaultToolBarHeight 83

@interface EMChatToolBar () <UITextViewDelegate,EMChatRecordViewDelegate>

@property (strong, nonatomic) UIView *activityButtomView;
@property (nonatomic) BOOL isShowButtomView;

@property (weak, nonatomic) IBOutlet EMMessageTextView *inputTextView;

@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
@property (weak, nonatomic) IBOutlet UIButton *photoButton;
@property (weak, nonatomic) IBOutlet UIButton *emotionButton;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;
@property (weak, nonatomic) IBOutlet UIButton *fileButton;

@property (strong, nonatomic) EMChatRecordView *recordView;

@property (strong, nonatomic) NSMutableArray *moreItems;

- (IBAction)cameraAction:(id)sender;
- (IBAction)photoAction:(id)sender;
- (IBAction)locationAction:(id)sender;
- (IBAction)recordAction:(id)sender;
- (IBAction)emotionAction:(id)sender;

@end

@implementation EMChatToolBar

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatKeyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _inputTextView.layer.borderColor = RGBACOLOR(189, 189, 189, 1).CGColor;
    _inputTextView.layer.borderWidth = 0.5;
    
    _cameraButton.left = (KScreenWidth/5 - _cameraButton.width)/2;
    _photoButton.left = (KScreenWidth/5 - _photoButton.width)/2 + KScreenWidth/5 * 1;
    _emotionButton.left = (KScreenWidth/5 - _emotionButton.width)/2 + KScreenWidth/5 * 2;
    _recordButton.left = (KScreenWidth/5 - _recordButton.width)/2 + KScreenWidth/5 * 3;
    _locationButton.left = (KScreenWidth/5 - _locationButton.width)/2 + KScreenWidth/5 * 4;
    
    _inputTextView.placeHolder = NSLocalizedString(@"chat.placeHolder", @"Send Message");
    _inputTextView.placeHolderTextColor = RGBACOLOR(173, 185, 193, 1);
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);

//    CGContextSetStrokeColorWithColor(context, RGBACOLOR(189, 189, 189, 1).CGColor);
//    CGContextStrokeRect(context, CGRectMake(0, 0, rect.size.width, 0.5));

//    CGContextSetStrokeColorWithColor(context, RGBACOLOR(0xe5, 0xe5, 0xe5, 1).CGColor);
//    CGContextStrokeRect(context, CGRectMake(0, rect.size.height - 0.5, rect.size.width, 0.5));
}
#pragma mark - getter

- (EMChatRecordView*)recordView
{
    if (_recordView == nil) {
        _recordView = (EMChatRecordView*)[[[NSBundle mainBundle]loadNibNamed:@"EMChatRecordView" owner:nil options:nil] firstObject];
        _recordView.delegate = self;
    }
    return _recordView;
}

- (NSMutableArray*)moreItems
{
    if (_moreItems == nil) {
        _moreItems = [NSMutableArray arrayWithArray:@[self.cameraButton,self.photoButton,self.emotionButton,self.recordButton,self.locationButton,self.fileButton]];
    }
    return _moreItems;
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        if (text.length > 0) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(didSendText:)]) {
                [self.delegate didSendText:[EMConvertToCommonEmoticonsHelper convertToCommonEmoticons:textView.text]];
            }
            textView.text = @"";
            return NO;
        }
    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    for (UIButton *btn in self.moreItems) {
        btn.selected = NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    [textView setNeedsDisplay];
}

#pragma mark - EMChatRecordViewDelegate

- (void)didFinishRecord:(NSString *)recordPath duration:(NSInteger)duration
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSendAudio:duration:)]) {
        [self.delegate didSendAudio:recordPath duration:duration];
    }
}

#pragma mark - UIKeyboardNotification

- (void)chatKeyboardWillChangeFrame:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect beginFrame = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    void(^animations)() = ^{
        [self _willShowKeyboardFromFrame:beginFrame toFrame:endFrame];
    };
    
    [UIView animateWithDuration:duration delay:0.0f options:(curve << 16 | UIViewAnimationOptionBeginFromCurrentState) animations:animations completion:nil];
}

#pragma mark - action

- (IBAction)cameraAction:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTakePhotos)]) {
        [self.delegate didTakePhotos];
    }
}

- (IBAction)photoAction:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectPhotos)]) {
        [self.delegate didSelectPhotos];
    }
}

- (IBAction)emotionAction:(id)sender
{
    UIButton *button = (UIButton*)sender;
    button.selected = !button.selected;
    for (UIButton *btn in self.moreItems) {
        if (button != btn) {
            btn.selected = NO;
        }
    }
    if (button.selected) {
        
    } else {
        
    }
}

- (IBAction)locationAction:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectLocation)]) {
        [self.delegate didSelectLocation];
    }
}

- (IBAction)recordAction:(id)sender
{
    UIButton *button = (UIButton*)sender;
    button.selected = !button.selected;
    for (UIButton *btn in self.moreItems) {
        if (button != btn) {
            btn.selected = NO;
        }
    }
    
    if (button.selected) {
        [self.recordView setHeight:187.f];
        [self.inputTextView resignFirstResponder];
        [self _willShowBottomView:self.recordView];
    } else {
        [self _willShowBottomView:nil];
    }
}

#pragma mark - public

- (BOOL)endEditing:(BOOL)force
{
    BOOL result = [super endEditing:force];
    for (UIButton *button in self.moreItems) {
        button.selected = NO;
    }
    [self _willShowBottomView:nil];
    return result;
}


#pragma mark - private

- (void)_willShowKeyboardFromFrame:(CGRect)beginFrame toFrame:(CGRect)toFrame
{
    if (beginFrame.origin.y == KScreenHeight) {
        [self _willShowBottomHeight:toFrame.size.height];
        if (self.activityButtomView) {
            [self.activityButtomView removeFromSuperview];
        }
        self.activityButtomView = nil;
    }
    else if (toFrame.origin.y == KScreenHeight) {
        [self _willShowBottomHeight:0];
    } else{
        [self _willShowBottomHeight:toFrame.size.height];
    }
}

- (void)_willShowBottomView:(UIView *)bottomView
{
    if (![self.activityButtomView isEqual:bottomView]) {
        CGFloat bottomHeight = bottomView ? bottomView.height : 0;
        [self _willShowBottomHeight:bottomHeight];
        
        if (bottomView) {
            bottomView.top = kDefaultToolBarHeight;
            [self addSubview:bottomView];
        }
        
        if (self.activityButtomView) {
            [self.activityButtomView removeFromSuperview];
        }
        self.activityButtomView = bottomView;
    }
}

- (void)_willShowBottomHeight:(CGFloat)bottomHeight
{
    CGRect fromFrame = self.frame;
    CGFloat toHeight = kDefaultToolBarHeight + bottomHeight;
    CGRect toFrame = CGRectMake(fromFrame.origin.x, fromFrame.origin.y + (fromFrame.size.height - toHeight), fromFrame.size.width, toHeight);
    
    if(bottomHeight == 0 && self.frame.size.height == kDefaultToolBarHeight) {
        return;
    }
    
    if (bottomHeight == 0) {
        self.isShowButtomView = NO;
    }
    else{
        self.isShowButtomView = YES;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
       self.frame = toFrame;
    }];
    [self _willShowViewFromHeight:toHeight];
}

- (void)_willShowViewFromHeight:(CGFloat)toHeight
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatToolBarDidChangeFrameToHeight:)]) {
        [self.delegate chatToolBarDidChangeFrameToHeight:toHeight];
    }
}

@end
