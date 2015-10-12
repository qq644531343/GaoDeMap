//
//  OutSearchViewController.m
//  TestGaoDeMap
//
//  Created by libo on 15/10/8.
//  Copyright © 2015年 libo. All rights reserved.
//

#import "OutSearchViewController.h"

@interface OutSearchViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITextField *searchTextFiled;

@property (nonatomic, strong) UITableView *searchResultTableView;

@property (nonatomic, strong) UILabel *noResultLabel;

@property (nonatomic, strong) NSArray *mapStoreListArray;

@end

@implementation OutSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //AMapSearchController
    self.searchTextFiled = [[UITextField alloc] initWithFrame:CGRectMake(0.0, 0.0, GAO_SIZE.width - 80.0, 28.0)];
    self.searchTextFiled.backgroundColor = GaoColorWithRGB(0xeeeeee);
//    self.searchTextFiled.leftView = searchIcon;
    self.searchTextFiled.leftViewMode = UITextFieldViewModeAlways;
    self.searchTextFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.searchTextFiled.returnKeyType = UIReturnKeySearch;
    self.searchTextFiled.placeholder = @"请输入关键字";
    self.searchTextFiled.layer.cornerRadius = 14.0;
    self.searchTextFiled.layer.masksToBounds = YES;
    [self.searchTextFiled setFont:[UIFont systemFontOfSize:13.0]];
    self.searchTextFiled.delegate = self;
    self.navigationItem.titleView = self.searchTextFiled;
    
    //搜索内容TableView
    UIColor *bgColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0];
    self.searchResultTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 66, GAO_SIZE.width, GAO_SIZE.height-66) style:UITableViewStylePlain];
    self.searchResultTableView.backgroundColor = bgColor;
    self.searchResultTableView.delegate = self;
    self.searchResultTableView.dataSource = self;
    [self.searchResultTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.searchResultTableView];
    self.searchResultTableView.tableFooterView = [[UIView alloc] init];
    self.searchResultTableView.hidden = YES;
    
    //无搜索结果提示View
    self.noResultLabel = [[UILabel alloc] initWithFrame:CGRectMake(GAO_SIZE.width/2-100.0, 100.0, 200.0, 20.0)];
    [self.noResultLabel setTextAlignment:NSTextAlignmentCenter];
    self.noResultLabel.text = @"没有找到相关品牌~";
    [self.view addSubview:self.noResultLabel];
    self.noResultLabel.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchTextFieldDidChangeValue:) name:UITextFieldTextDidChangeNotification object:self.searchTextFiled];

}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mapStoreListArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell;
    
    static NSString *mapStoreCellIdentifier = @"cell";
    cell = [tableView dequeueReusableCellWithIdentifier:mapStoreCellIdentifier];
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    AMapTip *tip = self.mapStoreListArray[indexPath.row];
    cell.textLabel.text = tip.name;
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AMapTip *tip = self.mapStoreListArray[indexPath.row];
    if (tip.location == nil) {
        [self searchPOIForKey:tip.name];
    }else {
        [self.map addMyAnnotationTip:tip];
        [self backToParent:nil];
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self.searchTextFiled resignFirstResponder];
}

#pragma mark -开始搜索
-(void)startSearch{
    NSString *searchKey = self.searchTextFiled.text;

    __weak OutSearchViewController *weakself = self;
    [self.map.searchManager inputTipsWithKeywords:searchKey city:@"Hangzhou" finish:^(NSError *error, NSArray *tips) {
        
        weakself.mapStoreListArray = tips;
        weakself.noResultLabel.hidden = weakself.mapStoreListArray.count>0;
        [weakself.searchResultTableView reloadData];
    }];
   
   
}


-(void)searchTextFieldDidChangeValue:(id)sender{
    if (self.searchTextFiled.text.length == 0) {
        self.noResultLabel.hidden = YES;
        self.searchResultTableView.hidden = YES;
        [self.searchResultTableView reloadData];
    }
    else{
        [self startSearch];
        self.searchResultTableView.hidden = NO;
        [self.view bringSubviewToFront:self.searchResultTableView];
        [self.view bringSubviewToFront:self.noResultLabel];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self searchPOIForKey:textField.text];
    return YES;
}

-(void)searchPOIForKey:(NSString *)key
{
    [self.searchTextFiled resignFirstResponder];
    if (key.length == 0) {
        return;
    }
    __weak OutSearchViewController *weakself = self;
    [self.map.searchManager searchPOIArroundByKeywords:key location:self.map.userLocation.location.coordinate radius:5*1000 finish:^(NSError *error, NSArray *pois, AMapSuggestion *suggestion) {
        [weakself.map addMyAnnotationPois:pois];
        [weakself backToParent:nil];
    }];
}

-(void)backToParent:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
