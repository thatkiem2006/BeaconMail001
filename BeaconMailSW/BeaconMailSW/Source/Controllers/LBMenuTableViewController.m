//
//  LBMenuTableViewController.m
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

#import "LBMenuTableViewController.h"
#import "LBAboutViewController.h"
#import "LBListMailViewController.h"
#import "LBCustomNavigationViewController.h"

typedef enum {
    frontViewPositionLeft      = 0,
    frontViewPositionRightMost       = 1,
    frontViewPositionRight   = 2,
    
} _frontViewState;


@interface LBMenuTableViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray * arrayList;
    BOOL isEdit;
    NSInteger _presentedRow;
    NSMutableArray * arrayBeaconList;
    BOOL isDebugMode;
}
@property (nonatomic,strong) UILongPressGestureRecognizer *lpgr;
@end

@implementation LBMenuTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"LB_NOTI_UPDATE_UNREAD" object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadData)
                                                 name:@"LB_NOTI_UPDATE_UNREAD" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"LB_NOTI_RESET_CONFIG" object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(viewDidLoad)
                                                 name:@"LB_NOTI_RESET_CONFIG" object:nil];
    //  [LB_NOTI_CENTER_DEFAULT postNotificationName:@"LB_NOTI_LOAD_ACCOUNT_MAIL" object:paramDic];
    
    arrayList = [[NSMutableArray alloc] init];
    
   
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    
    isEdit = false;
    
    [self loadData];
    
    self.lpgr.minimumPressDuration = 1.0f;
    self.lpgr.allowableMovement = 100.0f;
    [self initLocalizable];
    [self addFooter];
    
}
-(void)initLocalizable{
    self.titleLabel.text = NSLocalizedString(@"menu_title", nil);
    [self.btnEdit setTitle:NSLocalizedString(@"edit", @"") forState:UIControlStateNormal];
    //titleLabel

}

- (void)goToWeb:(int)mailAccountId{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NSString *navViewControllerIdentity;
    UIViewController *newFrontController = nil;
    newFrontController = [storyboard instantiateViewControllerWithIdentifier:@"LBWebAppViewController"];
    navViewControllerIdentity = @"LBWebAppNavigationViewController";
    LBWebAppViewController *weblVC = ((LBWebAppViewController *)newFrontController);
    ;
   
    weblVC.mailAccountId = mailAccountId;

    LBCustomNavigationViewController *navController = [storyboard instantiateViewControllerWithIdentifier:navViewControllerIdentity];
    [navController setViewControllers: @[weblVC] animated: YES];
   
}

-(void)loadData{
    arrayList = [[NSMutableArray alloc] init];

    LBMenuItemModel *item1 = [[LBMenuItemModel alloc] initWithUniqueId:0 title:NSLocalizedString(@"menu_information", nil) iconUrl:@"ic_default_mail" badgeUnreadNumber:0 isEdit:false];
    LBMenuItemModel *item2 = [[LBMenuItemModel alloc] initWithUniqueId:1 title:NSLocalizedString(@"menu_favorite", nil) iconUrl:@"btn_favorite" badgeUnreadNumber:0 isEdit:false];

    [arrayList addObject:item1];
    [arrayList addObject:item2];
    
    [self.tableView reloadData];

}

-(void)loadDataGoToWeb{
    arrayList = [[NSMutableArray alloc] init];
    LBMenuItemModel *item1 = [[LBMenuItemModel alloc] initWithName:NSLocalizedString(@"menu_information ", nil) iconUrl:@"ic_default_mail" badgeUnreadNumber:0 isEdit:false];
    
    LBMenuItemModel *item2 = [[LBMenuItemModel alloc] initWithName:NSLocalizedString(@"menu_favorite", nil) iconUrl:@"btn_favorite" badgeUnreadNumber:0 isEdit:false];
    
    
    LBMenuItemModel *item3 = [[LBMenuItemModel alloc] initWithName:NSLocalizedString(@"menu_about", nil) iconUrl:@"btn_info"  badgeUnreadNumber:0 isEdit:false];
    [arrayList addObject:item1];
    [arrayList addObject:item2];
    
    [arrayList addObject:item3];
    
    [self.tableView reloadData];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"LBMenuLeftCell";
    LBMenuLeftCell *cell = (LBMenuLeftCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (LBMenuLeftCell *)[nib objectAtIndex:0];
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    
    LBMenuItemModel *menuItem = [arrayList objectAtIndex:indexPath.row];
    
    
    [cell setUpMenuItemInfo:menuItem];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.tag = indexPath.row;
    
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame:
                                 CGRectMake(0, 0, tableView.frame.size.width, 50.0)];
    sectionHeaderView.backgroundColor = [UIColor clearColor];
    
    return sectionHeaderView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section==0) {
        return nil;
    }
    return nil;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}
-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
}

//Count number of record for sections
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrayList.count;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

//// Override to support editing the table view.
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        //add code here for when you hit delete
//        
//    }
//}



- (IBAction)btnEditTouch:(id)sender {
    
    if(isEdit == true){
        [self.btnEdit setTitle:NSLocalizedString(@"edit", @"") forState:UIControlStateNormal];
        
        //        LBMenuItemModel *menuItem = [arrayList objectAtIndex:indexPath.row];
    }else{
        [self.btnEdit setTitle:NSLocalizedString(@"done", @"") forState:UIControlStateNormal];
       
       
    }
    
    isEdit = !isEdit;
    [self loadData];
}




-(void)addFooter {
    CGRect footerRect = CGRectMake(0, 0, 320, 1);
    UIView *wrapperView = [[UIView alloc] initWithFrame:footerRect];
    wrapperView.backgroundColor = [self.tableView separatorColor];
    
    //[wrapperView addSubview:tableFooter];
    self.tableView.tableFooterView = wrapperView;
}

@end
