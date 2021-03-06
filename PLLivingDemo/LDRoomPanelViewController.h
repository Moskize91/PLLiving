//
//  LDRoomPanelViewController.h
//  PLLivingDemo
//
//  Created by TaoZeyu on 16/7/20.
//  Copyright © 2016年 com.pili-engineering. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    LDRoomPanelViewControllerMode_Anchor,
    LDRoomPanelViewControllerMode_Spectator
} LDRoomPanelViewControllerMode;

@class LDRoomPanelViewController;
@class LDRoomItem;

@protocol LDRoomPanelViewControllerDelegate <NSObject>

@optional

- (void)onKeyboardWasShownWithHeight:(CGFloat)keyboardHeight withDuration:(NSTimeInterval)duration;
- (void)onKeyboardWillBeHiddenWithDuration:(NSTimeInterval)duration;
- (void)onRoomDestroy;

@end

@interface LDRoomPanelViewController : UIViewController

@property (nonatomic, strong) LDRoomItem *roomItem;
@property (nonatomic, weak) id<LDRoomPanelViewControllerDelegate> delegate;

- (instancetype)initWithMode:(LDRoomPanelViewControllerMode)mode;
- (void)playCloseRoomPanelViewControllerAnimation;
- (void)connectToWebSocket;

@end
