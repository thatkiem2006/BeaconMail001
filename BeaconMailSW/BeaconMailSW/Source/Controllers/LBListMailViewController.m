//
//  LBListMailViewController.m
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

#import "LBListMailViewController.h"


@interface LBListMailViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *arrayList;
    //NSString *mailAccountId;
    UIRefreshControl *refreshControl;
    NSMutableArray *arrayListSeleted;
    //LBDetechManager *detectManger;
}
@end

@implementation LBListMailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"LB_NOTI_UPDATE_UNREAD" object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadData)
                                                 name:@"LB_NOTI_UPDATE_UNREAD" object:nil];
    
    
    self.tableView.dataSource =self;
    self.tableView.delegate = self;

    arrayListSeleted = [[NSMutableArray alloc] init];
    arrayList = [[NSMutableArray alloc] init];

    self.bottomBarView.hidden = true;
    
    refreshControl = [UIRefreshControl.alloc init];
    refreshControl.attributedTitle   = [NSAttributedString.alloc initWithString:@"Refreshing..."];
    [refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    self.tableView.refreshControl = refreshControl;
    
    self.loadMoreActivityView =
    [[UIActivityIndicatorView alloc]
     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    
    self.navigationItem.leftBarButtonItem = [self makeDefaultLeftBtn];
    [self reloadData];
    
    /*
    detectManger = [LBDetechManager sharedManager];
    detectManger.delegate = self;
    [self setUpDetect];
     */
    
    [self loadButtonWeb];
    [self initLocalizable];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

}

-(void)initLocalizable {
    [self.webButton setTitle:NSLocalizedString(@"bottom_bar_web_view", nil) forState:UIControlStateNormal];
    self.noMailLabel.text = NSLocalizedString(@"no_mail", nil);
}

-(void)loadButtonWeb {
    if([self.mailAccountModel.accountType intValue] > 0){
        self.webButton.hidden = false;
    }else{
        self.webButton.hidden = true;
    }
   
}

- (IBAction) rightBtnClick: (id)sender
{
    self.isEditTableView = !self.isEditTableView;
    if(self.isEditTableView){
        self.navigationItem.rightBarButtonItem = [self makeDefaultRigthBtn:NSLocalizedString(@"cancel", nil)];
    }else{
        self.navigationItem.rightBarButtonItem = [self makeDefaultRigthBtn:NSLocalizedString(@"edit", nil)];
        
    }
    [self.tableView setEditing:self.isEditTableView];
    self.addFavoriteButton.hidden = !self.isEditTableView;
    self.deleteButton.hidden = !self.isEditTableView;;
    self.bottomBarView.hidden = !self.isEditTableView;
    
    [self loadButtonWeb];
}

-(void)viewDidDisappear:(BOOL)animated{
    self.isEditTableView = false;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"LBListMailViewController mail id %@",self.mailAccountId);

}

- (UIBarButtonItem*)makeDefaultRigthBtn:(NSString *)title {
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClick:)];

    return rightBtn;
}



- (UIBarButtonItem*)makeDefaultLeftBtn {
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
   
    [button setFrame:CGRectMake(0, 0, 21, 21)];
    
    UIBarButtonItem *barBtn  = [[UIBarButtonItem alloc] initWithCustomView:button];
    //    barBtn.customView.backgroundColor = LB_COLOR_BLACK;
    return barBtn;
}
-(void)refreshData{
    [self reloadData];
}

-(void)reloadData{
    
    self.addFavoriteButton.hidden = true;
    self.deleteButton.hidden = true;
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     return arrayList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LBMailCell *cell = nil;
    static NSString *cellIdentifier = @"LBMailCell";
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:(@"LBMailCell")
                                              owner:self
                                            options:nil] lastObject];
    } else {
       
    }
    
    LBMailModel *model = arrayList[indexPath.row];
    [cell setUpMailInfo:model];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LBMailModel *model;
    model  = arrayList[indexPath.row];

    
    if(model != nil){
        [arrayListSeleted addObject:model.mailId];
    }
    
    NSLog(@"edit %d  mail id %@",self.isEditTableView,model.mailId);
    
    if(!self.isEditTableView){
        LBMailDetailViewController *vcDetail = [self.storyboard instantiateViewControllerWithIdentifier:@"LBMailDetailViewController"];
        [vcDetail setUpInboxDetail:model];
        [self.navigationController pushViewController:vcDetail animated:YES];
    }else{
    
    }
}

-(void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LBMailModel *model;
    model  = arrayList[indexPath.row];

    for(id item in arrayListSeleted) {
        NSString *itemRemove = item;
       
        if([itemRemove isEqualToString:model.mailId]){
            [arrayListSeleted removeObject:item];
            break;
        }
    }
    NSLog(@"edit %d  mail id %@",self.isEditTableView,model.mailId);
}


- (IBAction)addFavoriteTouch:(id)sender {
    
}
- (IBAction)webButtonTouch:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    NSString *navViewControllerIdentity;
    UIViewController *newFrontController = nil;
    
    newFrontController = [storyboard instantiateViewControllerWithIdentifier:@"LBWebAppViewController"];
    
    if([newFrontController isKindOfClass:[LBWebAppViewController class]] ){
        LBWebAppViewController *webVC = ((LBWebAppViewController *)newFrontController);
        
        navViewControllerIdentity = @"LBWebAppNavigationViewController";
        webVC.mailAccountModel = self.mailAccountModel;
        webVC.mailAccountId = [self.mailAccountId intValue];
        LBCustomNavigationViewController *navController = [storyboard instantiateViewControllerWithIdentifier:navViewControllerIdentity];
        
        [navController setViewControllers: @[webVC] animated: YES];
        //[navController popViewControllerAnimated:YES];
        //[self.revealViewController po];
        
    }
    
}
- (IBAction)deleteButtonTouch:(id)sender {
    
}

- (void)loadDataDB:(NSString *)mailAccountIdParam {
   
    if(arrayList.count > 0){
        self.noMailLabel.hidden = true;
        self.navigationItem.rightBarButtonItem = [self makeDefaultRigthBtn:NSLocalizedString(@"edit", nil)];
        
    }else{
        self.navigationItem.rightBarButtonItem = nil;
        self.bottomBarView.hidden = true;
        self.noMailLabel.hidden = false;
    }
    

}

@end
