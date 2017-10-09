//
//  LBStatusScreenViewController.m
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

#import "LBStatusScreenViewController.h"

@interface LBStatusScreenViewController ()
{
    NSMutableArray *arrrayListBeacon;
    NSMutableArray *arrayListGeofence;
}
@end

@implementation LBStatusScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    arrrayListBeacon = [[NSMutableArray alloc] init];
    arrayListGeofence = [[NSMutableArray alloc] init];
    self.iBeaconTableView.dataSource = self;
    self.iBeaconTableView.delegate = self;
    self.geoFenceTableView.dataSource = self;
    self.geoFenceTableView.delegate = self;
    
    [self loadListBeacon];
    [self loadListGeofence];
    
}

-(void)loadListBeacon {
   
}
-(void)loadListGeofence {
   
}

-(void) viewWillAppear:(BOOL)animated{
    self.nameTextField.text = self.profileModel.name;
    self.dayToLiveTextField.text = [NSString stringWithFormat:@"%d",[self.profileModel.daysToLive intValue]];
    self.readRecipeUrlTextView.text = self.profileModel.readReceiptUrl;
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:NSLocalizedString(@"menu_debug", nil) forKey:@"title"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LBShowTitleNotificationCenter" object:userInfo];
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
    if(tableView == self.iBeaconTableView){
        return arrrayListBeacon.count;
    }else{
        return arrayListGeofence.count;
    }

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LBBeaconModel *objBeacon;
    LBGeofenceModel *objGeofence;
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
  
    if(tableView == self.iBeaconTableView){
        objBeacon = arrrayListBeacon[indexPath.row];
        cell.textLabel.text = objBeacon.uuid;
       
        cell.detailTextLabel.text = objBeacon.xmlUrl;
        return cell;
    
    }else{
        objGeofence = arrayListGeofence[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@, %@, %@ m",objGeofence.latitude,objGeofence.longitude,objGeofence.radius];
        cell.detailTextLabel.text = objGeofence.xmlFileId;
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

@end
