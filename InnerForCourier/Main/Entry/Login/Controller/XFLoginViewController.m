//
//  LoginViewController.m
//  InnerForCourier
//
//  Created by DamonLiao on 2017/2/3.
//  Copyright © 2017年 DamonLiao. All rights reserved.
//

#import "XFLoginViewController.h"
#import "UIImage+Create.h"
#import "UIColor+Project.h"
#import "AppDelegate.h"
#import "XFRequestLogin.h"
#import "JPUSHService.h"

@interface XFLoginViewController ()

@property (weak, nonatomic) IBOutlet UIButton       *loginButton;
@property (weak, nonatomic) IBOutlet UITextField    *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField    *passwordTextField;

@end

@implementation XFLoginViewController

- (IBAction)login:(id)sender {
    [self.view endEditing:YES];
    NSString *accountString = self.accountTextField.text;
    NSString *passwordString = self.passwordTextField.text;
    [XFProgressHUD showLoading];
    [self loginWithAccount:accountString password:passwordString];
}

- (void)loginWithAccount:(NSString *)accountString password:(NSString *)passwordString {
    [XFRequestLogin loginWithAccount:accountString password:passwordString success:^(NSDictionary *dict){
        [XFProgressHUD dismiss];
        [self persistenceInfoWithDict:dict]; // 持久化用户信息
        
        // 向极光注册tag
        NSString *tagString = [NSString stringWithFormat:@"%@_pstag", [XFKVCPersistence get:KEY_USER_OWNERID]];
        NSSet *tagsSet = [NSSet setWithObjects:tagString, nil];
        [JPUSHService setTags:tagsSet callbackSelector:nil object:nil];
        
        [[AppDelegate appDelegate] toMain];
    } failure:^(NSError *error, NSInteger statusCode) {
        if (error) {
            [self showError:error];
        }
    }];
}

#pragma mark - Override

- (void)setupViews {
    [super setupViews];
    self.accountTextField.tintColor = [UIColor colorDomina];
    [self.accountTextField becomeFirstResponder];
    
    self.passwordTextField.tintColor = [UIColor colorDomina];
    
    [self.loginButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorDomina]] forState:UIControlStateNormal];
    self.loginButton.layer.cornerRadius = 5.0f;
    self.loginButton.layer.masksToBounds = YES;
}


#pragma mark - Custom

- (IBAction)textFieldChanged:(UITextField *)sender {
    self.loginButton.enabled = self.accountTextField.text.length && self.passwordTextField.text.length;
}

- (void)persistenceInfoWithDict:(NSDictionary *)dict {
    /*
    for (<#initialization#>; <#condition#>; <#increment#>) {
        <#statements#>
    }
     */
    [XFKVCPersistence setValue:dict[KEY_RESULT][KEY_USER_CODE] forKey:KEY_ACCOUNT];
    NSDictionary *userDict = dict[KEY_RESULT][KEY_USER];
    [XFKVCPersistence setValue:userDict[KEY_USER_ID] forKey:KEY_USER_ID];
    [XFKVCPersistence setValue:userDict[KEY_USER_NAME] forKey:KEY_USER_NAME];
    [XFKVCPersistence setValue:userDict[KEY_USER_STATUS] forKey:KEY_USER_STATUS];
    [XFKVCPersistence setValue:userDict[KEY_USER_OWNERID] forKey:KEY_USER_OWNERID];
    [XFKVCPersistence setValue:userDict[KEY_USER_TYPE] forKey:KEY_USER_TYPE];
}

@end
