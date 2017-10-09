//
//  LBDebugModeViewController.m
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

#import "LBDebugModeViewController.h"

@interface LBDebugModeViewController ()
{
    NSArray *arrXMLConfig;
}
@end

@implementation LBDebugModeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)xmlConfigOptionButtonTouch:(id)sender {
    UIButton *btn  = sender;
    NSUInteger tag = btn.tag;
    self.urlTextField.text = arrXMLConfig[tag];
}
- (IBAction)saveButtonTouch:(id)sender {
    NSString *urlConfig = self.urlTextField.text;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LB_RESET_CONFIG" object:nil];
}
@end
