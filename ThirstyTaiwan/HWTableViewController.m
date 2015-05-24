//
//  HWTableViewController.m
//  helloworld-objective-c
//
//  Created by CHENHSIN-PANG on 2015/3/24.
//  Copyright (c) 2015年 CinnamonRoll. All rights reserved.
//

#import "HWTableViewController.h"
#import "MBProgressHUD.h"
#import "DamController.h"

@interface HWTableViewController ()<UITableViewDataSource, UITableViewDelegate>

-(NSArray *)convertDamToNSArray: (NSMutableData *)response;

@property(nonatomic, weak)UITableView   *tableView;
@property(nonatomic, weak)UIRefreshControl *refreshControl; // Implement pull down refresh behavior.

@end
static NSArray *waterArray;
static NSMutableData *responseData;
static NSInteger damCount;

static NSString *const _DATA_SOURCE = @"http://128.199.223.114:10080/today";
static NSString *const _DAM_MESSAGE = @"%@ 目前蓄水量：%@";
static NSString *const _DAM_NAME = @"reservoirName";
static NSString *const _DAM_CAPACITY = @"immediateStorage";

@implementation HWTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    
    tableView.dataSource = self; // 需要在上面宣告這個class有實作 UITableViewDataSource
    tableView.delegate = self;

    self.tableView = tableView; // 把local variable設給這個物件的property，是方便存取。

    // Initialize the refresh control.
    UIRefreshControl *refCtl = [[UIRefreshControl alloc] init];
    refCtl.backgroundColor = [UIColor purpleColor];
    refCtl.tintColor = [UIColor whiteColor];
//    [refCtl addTarget:self
//               action:@selector(connectionDidFinishLoading)
//     forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refCtl;
    
    // Set remote URL detail
    responseData = [[NSMutableData alloc]init];
    DamController *damController = [[DamController alloc]init];
    // MBProgressHUD
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableURLRequest *request = [damController GetDamStatus: _DATA_SOURCE];

    // Get remote JSON data.
    (void)[NSURLConnection connectionWithRequest:request delegate:self];
}



// 當程式執行到這裡，self.view拿到的大小才正確
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.tableView.frame = self.view.bounds; // 可以查一下frame 與 bounds的差別
}


#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1; // 有幾個Section
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // 每個Section有幾個Row
    
    if(section == 0) return damCount;
    
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DataCell"];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"DataCell"];
    }

    cell.backgroundColor = (indexPath.row%2)?[UIColor lightGrayColor]:[UIColor grayColor];
    // Get dam information from static variable "waterArray" in the waters dictionary object.
    NSDictionary *dam = [waterArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat: _DAM_MESSAGE,
                           [dam valueForKey: _DAM_NAME],
                           //[dam valueForKey:@"immediatePercentage"]
                           [dam valueForKey: _DAM_CAPACITY]] ;

    cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    
    return cell;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"目前水庫蓄水量";
}



#pragma mark - UITableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Click Section = %ld Row = %ld", (long)indexPath.section, (long)indexPath.row);
}

#pragma mark - NSURLConnection Delegates

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error  {
    NSLog(@"Error occur when retriving data: %@", [error localizedDescription]);
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response   {
    [responseData setLength:0];
    NSLog(@"Response data got.");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data  {
    [responseData appendData:data];
    NSLog(@"Receive data got");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection    {
    
    // Get dam data from remote in JSON format.
    waterArray = [self convertDamToNSArray:responseData];
    damCount = [waterArray count];
    
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    [[self tableView] reloadData];
}

// Convert response data to an array which more easy to use for table view.
-(NSArray *)convertDamToNSArray:(NSMutableData *)response {
    NSArray *rtnArray;
    // Get dam data from remote in JSON format.
    NSString *responseString = [[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
    NSData *waterData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *waters = [NSJSONSerialization JSONObjectWithData:waterData options:0 error:nil];
    rtnArray = [waters valueForKey:@"data"];

    NSLog(@"%@",responseString);

    return rtnArray;
}
@end
