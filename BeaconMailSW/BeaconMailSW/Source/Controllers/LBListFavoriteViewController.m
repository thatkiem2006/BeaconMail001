//
//  LBListFavoriteViewController.m
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

#import "LBListFavoriteViewController.h"

@interface LBListFavoriteViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *arrayList;
    NSString *mailAccountId;
    UIRefreshControl *refreshControl;
    NSMutableArray *arrayListSeleted;
}
@end

@implementation LBListFavoriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource =self;
    self.tableView.delegate = self;

    arrayListSeleted = [[NSMutableArray alloc] init];

    // Do any additional setup after loading the view.
    self.bottomBarView.hidden = true;
    refreshControl = [UIRefreshControl.alloc init];
    refreshControl.attributedTitle   = [NSAttributedString.alloc initWithString:@"Refreshing..."];
    [refreshControl addTarget:self action:@selector(reloadData) forControlEvents:UIControlEventValueChanged];
    self.tableView.refreshControl = refreshControl;
    self.loadMoreActivityView =
    [[UIActivityIndicatorView alloc]
     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    

    self.noMailList.text = NSLocalizedString(@"no_mail", nil);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"%s", __FUNCTION__);
     [self loadData];
}

- (void)loadData {
   
    if(arrayList.count > 0){
     
        self.noMailList.hidden = true;
        self.navigationItem.rightBarButtonItem = [self makeDefaultRigthBtn:NSLocalizedString(@"edit", nil)];
    }else{
        self.navigationItem.rightBarButtonItem = nil;
        self.bottomBarView.hidden = true;
        self.noMailList.hidden = false;
    }
}

- (UIBarButtonItem*)makeDefaultRigthBtn:(NSString *)title {
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClick:)];

   
    return rightBtn;
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
   // self.addFavoriteButton.hidden = !self.isEditTableView;
  //  self.deleteButton.hidden = !self.isEditTableView;;
    self.bottomBarView.hidden = !self.isEditTableView;
    
  //  [self loadButtonWeb];
}

-(void)reloadData {
    self.tableView.refreshControl = nil;
    refreshControl = [UIRefreshControl.alloc init];
    refreshControl.attributedTitle   = [NSAttributedString.alloc initWithString:@"Refreshing..."];
    [refreshControl addTarget:self action:@selector(reloadData) forControlEvents:UIControlEventValueChanged];
    self.tableView.refreshControl = refreshControl;
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
    LBMailModel * model  = arrayList[indexPath.row];
    
    [arrayListSeleted addObject:model.mailId];
    
    NSLog(@"edit %d  mail id %@",self.isEditTableView,model.mailId);
    
    if(!self.isEditTableView){
        LBMailDetailViewController *vcDetail = [self.storyboard instantiateViewControllerWithIdentifier:@"LBMailDetailViewController"];
        
        [vcDetail setUpInboxDetail:model];
        [self.navigationController pushViewController:vcDetail animated:YES];
        
    }else{
        
        
    }
    // [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LBMailModel *model  = arrayList[indexPath.row];

    for(id item in arrayListSeleted) {
        NSString *itemRemove = item;
        
        if([itemRemove isEqualToString:model.mailId]){
            [arrayListSeleted removeObject:item];
            break;
        }
    }
    
    //NSLog(@"edit %d  mail id %@",self.isEditTableView,model.mailId);
    
}


- (IBAction)deleteButtonTouch:(id)sender {
 
        
}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//
//    }
//}
//
//// Override to support conditional editing of the table view.
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    // Return NO if you do not want the specified item to be editable.
//    return YES;
//}
//
//- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
//    return YES;
//}

@end
