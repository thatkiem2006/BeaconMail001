//
//  LBSplashViewController.m
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

#import "LBSplashViewController.h"
#import "SWRevealViewController.h"
#import "LBProfileModel.h"


@interface LBSplashViewController ()<UIAlertViewDelegate>
{
    NSArray *arrayListBeacon;
    
}
@end

@implementation LBSplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tryAgainButton.hidden = true;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}

- (void) showAlertConfirmDownFileConfig{
   

        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:NSLocalizedString(@"message_init_setting", nil)
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"no", nil)
                                                  otherButtonTitles:NSLocalizedString(@"yes", nil), nil];
        alert.delegate = self;
        alert.tag = 1000;
        [alert show];
        
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1000){
        
        if (buttonIndex == 0)
        {
            //Code for Cancel button
           // exit(0);
             self.tryAgainButton.hidden = false;
        }
        if (buttonIndex == 1)
        {
            [self downloadConfigXML];
        }
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) goToLoadMail{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *newFrontController = nil;
    newFrontController = [storyboard instantiateViewControllerWithIdentifier:@"RevealViewController"];
    
    newFrontController.modalPresentationStyle = UIModalPresentationFullScreen;
//    newFrontController.transitionStyle = UIModalTransitionStyleCoverVertical;
    newFrontController.modalTransitionStyle = UIModalPresentationPopover;
    
    
    [self presentViewController:newFrontController animated:NO completion:nil];
    
}

- (IBAction)tryAgainTouch:(id)sender {
    [self downloadConfigXML];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"GoToRevealViewController"])
    {
  
    }
}

-(void)downloadConfigXML{
    self.tryAgainButton.hidden = true;

}

@end
