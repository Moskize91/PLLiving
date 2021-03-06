//
//  LDAppSettingViewController.m
//  PLLivingDemo
//
//  Created by TaoZeyu on 16/7/27.
//  Copyright © 2016年 com.pili-engineering. All rights reserved.
//

#import "LDUserDefaultsKey.h"
#import "LDAppSettingViewController.h"
#import "LDAgreementsViewController.h"
#import "LDLoginViewController.h"

@interface LDAppSettingViewController ()
@property (nonatomic, strong) UIBarButtonItem *closeButton;
@property (nonatomic, strong) UIView *scrollContainer;
@end

@implementation LDAppSettingViewController

- (void)loadView
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    self.view = scrollView;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    UIScrollView *scrollView = (UIScrollView *)self.view;
    scrollView.contentSize = self.scrollContainer.frame.size;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = kcolGrayBackground;
    
    self.scrollContainer = ({
        UIView *container = [[UIView alloc] init];
        
        [self.view addSubview:container];
        [container mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.view);
            make.height.greaterThanOrEqualTo(self.view);
        }];
        container;
    });
    
    [self.navigationItem setTitleView:({
        UILabel *label = [[UILabel alloc] init];
        label.text = LDString("settings");
        label.textColor = kcolTextButton;
        label.font = [UIFont systemFontOfSize:14];
        [label sizeToFit];
        label;
    })];
    
    self.closeButton = ({
        UIBarButtonItem *button = [[UIBarButtonItem alloc] init];
        self.navigationItem.leftBarButtonItem = button;
        [button setImage:[UIImage imageNamed:@"icon-close"]];
        [button setTintColor:kcolCloseButtonIcon];
        [button setTarget:self];
        [button setAction:@selector(_pressedCloseButton)];
        button;
    });
    
    UIImageView *appIconView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.scrollContainer addSubview:imageView];
        imageView.image = [UIImage imageNamed:@"logo"];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.scrollContainer).with.offset(78);
            make.centerX.equalTo(self.scrollContainer);
        }];
        imageView;
    });
    
    UIImageView *titleImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.scrollContainer addSubview:imageView];
        imageView.image = [UIImage imageNamed:@"LIVING"];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(appIconView.mas_bottom).with.offset(7);
            make.centerX.equalTo(self.scrollContainer);
        }];
        imageView;
    });
    
    UILabel *sloganLabel = ({
        UILabel *label = [[UILabel alloc] init];
        [self.scrollContainer addSubview:label];
        label.text = LDString("slogan");
        label.textColor = kcolTextSlogan;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleImageView.mas_bottom).with.offset(19);
            make.centerX.equalTo(self.scrollContainer);
        }];
        label;
    });
    
    UIButton *agreementsButton = ({
        UIButton *button = [self _createSelectItemButtonWithTitle:@"Agreements"];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(sloganLabel.mas_bottom).with.offset(66);
        }];
        UIImageView *arrowImageView = [[UIImageView alloc] init];
        [button addSubview:arrowImageView];
        arrowImageView.image = [UIImage imageNamed:@"arrows-right"];
        [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(button);
            make.right.equalTo(button).with.offset(-12.5);
        }];
        button;
    });
    
    UIButton *deleteCacheButton = ({
        UIButton *button = [self _createSelectItemButtonWithTitle:@"Delete Cache"];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(agreementsButton.mas_bottom).with.offset(17);
        }];
        button;
    });
    
    UIButton *logoutButton = ({
        UIButton *button = [self _createSelectItemButtonWithTitle:@"Log Out"];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(deleteCacheButton.mas_bottom).with.offset(17);
        }];
        button;
    });
    
    ({
        UILabel *versionLabel = [[UILabel alloc] init];
        [self.scrollContainer addSubview:versionLabel];
        versionLabel.text = LDString("version");
        versionLabel.textColor = kcolTextVersion;
        versionLabel.font = [UIFont systemFontOfSize:12];
        [versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.greaterThanOrEqualTo(logoutButton.mas_bottom).with.offset(56);
            make.bottom.equalTo(self.scrollContainer).with.offset(-12);
            make.centerX.equalTo(self.scrollContainer);
        }];
    });
    
    [agreementsButton addTarget:self action:@selector(_pressedAgreementsButton)
               forControlEvents:UIControlEventTouchUpInside];
    [logoutButton addTarget:self action:@selector(_pressedLogoutButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (UIButton *)_createSelectItemButtonWithTitle:(NSString *)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.scrollContainer addSubview:button];
    [button setBackgroundColor:[UIColor whiteColor]];
    [button setTitleColor:kcolTextButton forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [button setContentEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.scrollContainer);
        make.height.mas_equalTo(56);
    }];
    return button;
}

- (void)_pressedCloseButton
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)_pressedAgreementsButton
{
    LDAgreementsViewController *viewController = [[LDAgreementsViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)_pressedLogoutButton:(id)sender
{
    [self _confirmLogout:^(BOOL willLogout) {
        if (willLogout) {
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kLDUserDefaultsKey_DidLogin];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:kLDUserDefaultsKey_StoredCookies];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            UIWindow *window = self.view.window;
            [self dismissViewControllerAnimated:YES completion:^{
                [window.basicViewController popupViewController:[[LDLoginViewController alloc] init] animated:YES completion:^{
                    [window.basicViewController removeAllViewControllersExceptTop];
                }];
            }];
        }
    }];
}

- (void)_confirmLogout:(void (^)(BOOL willLogout))confirmBlock
{
    
    UIAlertController *av = [UIAlertController alertControllerWithTitle:LDString("confirm-logout")
                                                                message:LDString("logout-would-reset-username")
                                                         preferredStyle:UIAlertControllerStyleAlert];
    [av addAction:[UIAlertAction actionWithTitle:LDString("logout")
                                           style:UIAlertActionStyleDestructive
                                         handler:^(UIAlertAction * _Nonnull action) {
                                             confirmBlock(YES);
                                         }]];
    [av addAction:[UIAlertAction actionWithTitle:LDString("cancel")
                                           style:UIAlertActionStyleCancel
                                         handler:^(UIAlertAction * _Nonnull action) {
                                             confirmBlock(NO);
                                         }]];
    [self presentViewController:av animated:true completion:nil];
}

@end
