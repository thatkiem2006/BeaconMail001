//
//  LBListMailDetectViewController.m
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

#import "LBListMailDetectViewController.h"

@interface LBListMailDetectViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *arrayList;
    UIRefreshControl *refreshControl;
    NSMutableArray *arrayListSeleted;
}
@end

@implementation LBListMailDetectViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.dataSource =self;
    self.tableView.delegate = self;
    arrayListSeleted = [[NSMutableArray alloc] init];
    arrayList = [[NSMutableArray alloc] init];

    self.bottomBarView.hidden = true;
    
    refreshControl = [UIRefreshControl.alloc init];
    refreshControl.attributedTitle   = [NSAttributedString.alloc initWithString:@"Refreshing..."];
    [refreshControl addTarget:self action:@selector(reloadData) forControlEvents:UIControlEventValueChanged];
    self.tableView.refreshControl = refreshControl;
    
    self.loadMoreActivityView =
    [[UIActivityIndicatorView alloc]
     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    
    [self reloadData];
    
    self.navigationController.
    
    self.navigationItem.leftBarButtonItem = [self makeDefaultLeftBtn];
    self.navigationItem.leftBarButtonItem = [self makeDefaultRigthBtn];
    
    self.navigationItem.leftBarButtonItem.enabled = YES;

    [self initLocalizable];
}

-(void)initLocalizable {
    [self.webButton setTitle:NSLocalizedString(@"bottom_bar_web_view", nil) forState:UIControlStateNormal];
}

- (UIBarButtonItem*)makeDefaultRigthBtn {
     UIButton *rightButton;
    [rightButton setTitle:NSLocalizedString(@"edit", nil) forState:UIControlStateNormal];
  

    [rightButton setFrame:CGRectMake(0, 0, 90, 21)];
    [rightButton addTarget: self
                    action: @selector(buttonClicked:)
          forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *barBtn  = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
 
    return barBtn;
}

- (UIBarButtonItem*)makeDefaultLeftBtn {
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"btn_leftmenu"] forState:UIControlStateNormal];
    
    [button setFrame:CGRectMake(0, 0, 21, 21)];
    
    UIBarButtonItem *barBtn  = [[UIBarButtonItem alloc] initWithCustomView:button];
    //    barBtn.customView.backgroundColor = LB_COLOR_BLACK;
    return barBtn;
}


- (IBAction) buttonClicked: (id)sender
{
    

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"LBListMailViewController mail id %@",self.mailAccountId);
    
}

-(void)reloadData{
    if(self.mailAccountId != 0){
        self.tableView.refreshControl = nil;
        refreshControl = [UIRefreshControl.alloc init];
        refreshControl.attributedTitle   = [NSAttributedString.alloc initWithString:@"Refreshing..."];
        [refreshControl addTarget:self action:@selector(reloadData) forControlEvents:UIControlEventValueChanged];
        self.tableView.refreshControl = refreshControl;
  
    }else{
      
            self.mailAccountId = [NSString stringWithFormat:@"%d",self.mailAccountModel.uniqueId];
            
            self.tableView.refreshControl = nil;
            refreshControl = [UIRefreshControl.alloc init];
            refreshControl.attributedTitle   = [NSAttributedString.alloc initWithString:@"Refreshing..."];
            [refreshControl addTarget:self action:@selector(reloadData) forControlEvents:UIControlEventValueChanged];
            self.tableView.refreshControl = refreshControl;
            
        
            
        
        
    }
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
   
    
}
- (IBAction)deleteButtonTouch:(id)sender {
    
    
}

- (void)loadDataDB:(NSString *)mailAccountIdParam {
  
    
}

@end
