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
#import "XFRequestOrderCenter.h"


@interface XFLoginViewController ()
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation XFLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (IBAction)login:(id)sender {
    [self.view endEditing:YES];
    NSString *accountString = self.accountTextField.text;
    NSString *passwordString = self.passwordTextField.text;
    [XFProgressHUD showLoading];
    [self loginWithAccount:accountString password:passwordString];
}

- (void)loginWithAccount:(NSString *)accountString password:(NSString *)passwordString {
    [XFRequestOrderCenter loginWithAccount:accountString password:passwordString success:^{
        [XFProgressHUD dismiss];
        [[AppDelegate appDelegate] toMain];
    } failure:^(NSError *error, NSInteger statusCode) {
        [self showError:error];
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





@end
