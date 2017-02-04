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


@interface XFLoginViewController ()
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation XFLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

}
- (IBAction)login:(id)sender {
    
    [[AppDelegate appDelegate] toMain];
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
