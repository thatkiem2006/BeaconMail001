//
//  LBCustomNavigationViewController.m
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

#import "LBCustomNavigationViewController.h"
#import "SWRevealViewController.h"
#import "LBListMailViewController.h"
#import "LBListFavoriteViewController.h"
#import "LBStatusManagerTabbarViewController.h"

@interface LBCustomNavigationViewController (){
    BOOL isTableEditing;
    UIButton *rightButton;
    CGRect frameTable;
}

@end

@implementation LBCustomNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isTableEditing = false;
    rightButton  =  [UIButton buttonWithType:UIButtonTypeSystem];


    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor redColor]}];
    
    self.navigationController.navigationBar.opaque = YES;
    [self showDefaultLeftBtn];
}

- (void)goToScreen:(NSNotification *)noti {
    NSDictionary *userInfo = [noti object];
    int mailAccountId = [userInfo[@"LB_MAIL_ACCOUNT_ID"] intValue];
    if(mailAccountId >2){
        [self goToWeb:mailAccountId];
    }
    
}

- (void)goToWeb:(int)mailAccountId{
    
}

- (void)updateNaviRightButtonTitle:(NSNotification *)noti {
    NSDictionary *userInfo = [noti object];
    NSString *strTitle = (NSString *)userInfo[@"RightButton"];
    isTableEditing = false;
    [rightButton setTitle:strTitle forState:UIControlStateNormal];
   
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)showDefaultLeftBtn {
    UIBarButtonItem *barBtn = [self makeDefaultLeftBtn];
    [self setLeftButton:barBtn];
}

- (void)showDefaultRigthBtn {
    UIBarButtonItem *barBtn = [self makeDefaultRigthBtn];
    [self setRigthButton:barBtn];
}

- (void)showRigthBtnGeofenceMap {
    UIBarButtonItem *barBtn = [self makeRigthBtnMap];
    [self setRigthButton:barBtn];
}

- (UIBarButtonItem*)makeRigthBtnMap {
    [rightButton setTitle:@"MAP" forState:UIControlStateNormal];
    
    [rightButton setFrame:CGRectMake(0, 0, 90, 21)];
    [rightButton addTarget: self
                    action: @selector(buttonMapClicked:)
          forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *barBtn  = [[UIBarButtonItem alloc] initWithCustomView:rightButton];

    return barBtn;
}

- (IBAction) buttonMapClicked: (id)sender
{
  
}

- (UIBarButtonItem*)makeDefaultLeftBtn {
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"btn_leftmenu"] forState:UIControlStateNormal];
    SWRevealViewController *revealViewController = [self revealViewController];
    [button addTarget:revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, 21, 21)];
    
    UIBarButtonItem *barBtn  = [[UIBarButtonItem alloc] initWithCustomView:button];
//    barBtn.customView.backgroundColor = LB_COLOR_BLACK;
    return barBtn;
}

- (UIBarButtonItem*)makeDefaultRigthBtn {
    
    [rightButton setTitle:NSLocalizedString(@"edit", nil) forState:UIControlStateNormal];
   
    [rightButton setFrame:CGRectMake(0, 0, 90, 21)];
    [rightButton addTarget: self
               action: @selector(buttonClicked:)
     forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *barBtn  = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
   
    return barBtn;
}

- (IBAction) buttonClicked: (id)sender
{
    
}


-(void)actionShowMenu{
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
}

- (void)setLeftButton:(UIBarButtonItem*)barBtn {
    if (barBtn != nil) {
        self.topViewController.navigationItem.leftBarButtonItem = barBtn;
    }
}

- (void)setRigthButton:(UIBarButtonItem*)barBtn {
    if (barBtn != nil) {
        self.topViewController.navigationItem.rightBarButtonItem = barBtn;
    }
}

-(void)loadLeftMenuBarButton :(UIBarButtonItem *)leftMenuBarButtonItem{
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [leftMenuBarButtonItem setTarget: self.revealViewController];
        [leftMenuBarButtonItem setAction: @selector(revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    }
}

-(void)loadRightMenuChatBarButton :(UIBarButtonItem *)rigthMenuBarButtonItem{
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [rigthMenuBarButtonItem setTarget: self.revealViewController];
        [rigthMenuBarButtonItem setAction: @selector(rightRevealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    }
}

@end
