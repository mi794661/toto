//
//  WBHomeslideListingViewController.m
//  NeedIt
//
//  Created by 湘汇天承 on 16/4/27.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

#import "WBHomeslideListingViewController.h"
#import "Coordinate.h"
#import "INTERFACE.h"
#import "MJRefresh.h"
#import "ZTNetRequest.h"
#import "HomeslideListingModel.h"
#import "UIImageView+WebCache.h"
#import "NeedIt-Swift.h"


@interface WBHomeslideListingViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger currentPage;
    NSMutableArray *_array;
    UIImageView *bottomImage;
    UILabel *_titleLabel;
}

@property (strong, nonatomic) UITableView *tableview;

@end

@implementation WBHomeslideListingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    _array = [[NSMutableArray alloc] init];

    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.frame = CGRectMake(0, 20, SELF_VIEW_Width, SELF_VIEW_Height - 20);
    backgroundView.backgroundColor = kUIColorFromRGB(0xE2E2E3);
    [self.view addSubview:backgroundView];
    
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SELF_VIEW_Width, 64)];
    navView.backgroundColor = kUIColorFromRGB(0x02ACCE);
    
    [self.view addSubview:navView];
    
    UIButton *backbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backbtn.frame = CGRectMake(5, 28, 40, 28);
    [backbtn setImage:[UIImage imageNamed:@"返回_n"] forState:UIControlStateNormal];
    backbtn.imageEdgeInsets = UIEdgeInsetsMake(3,12,3,16);
    [backbtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:backbtn];
    
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 22, SELF_VIEW_Width - 160, 40)];
//    _titleLabel.text = @"金龙米业";
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = kUIColorFromRGB(0xfefefe);
    _titleLabel.font = [UIFont systemFontOfSize:17];
    [navView addSubview:_titleLabel];
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 70, SELF_VIEW_Width, SELF_VIEW_Height - 70) style:UITableViewStylePlain];
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.tableview.showsVerticalScrollIndicator = NO;
    self.tableview.backgroundColor = kUIColorFromRGB(0xE2E2E3);
    [self.view addSubview:self.tableview];
    
    NSLog(@"urlId ===== %@",_urlId);
    
    
    __weak UITableView *tableView = self.tableview;
    tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        currentPage = 1;
        [self getData:^{
            [tableView.header endRefreshing];
        }];
    }];
    [tableView.header beginRefreshing];
    tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        currentPage ++;
        [self getData:^{
            [tableView.footer endRefreshing];
        }];
    }];

    
    
    
}

- (void)getData:(void (^)(void))requestComplete;
{
    
    
    NSDictionary *dict = @{@"id": _urlId,@"page": [NSString stringWithFormat:@"%ld", (long)currentPage]};

    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [[ZTNetRequest request] requestAction:CS_REQUEST_ADVERTISINGLIST aParameters: @{@"project":jsonString} aPlaceholder:nil cacheEnabled:(currentPage == 1) successComplete:^(NSDictionary *source) {
        
        NSLog(@"obj = %@",source);
        
        
        if (currentPage == 1 && _array > 0) {
            [_array removeAllObjects];
        }
        NSArray *array = [source objectForKey:@"data"];
        
        _titleLabel.text = [source objectForKey:@"merchant"];

        
        [self reloadTableView:array];
        [self.tableview reloadData];
        requestComplete();
    }];
    
}


- (void)reloadTableView:(NSArray *)array
{
    if (array.count == 0) {
        if (_array.count > 0) {
            self.tableview.footer.hidden = YES;
            bottomImage.hidden = NO;
            bottomImage.frame = CGRectMake((SELF_VIEW_Width - 277)/2, self.tableview.contentSize.height, 277, 68);
        }
    }
    else
    {
        self.tableview.footer.hidden = NO;
        bottomImage.hidden = YES;
        bottomImage.frame = CGRectZero;
        
        [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            HomeslideListingModel *model = [HomeslideListingModel statusWithDictionary:obj];
//            SABaseInformationFrame *statusFrame = [[SABaseInformationFrame alloc] init];
//            [statusFrame setStatus:model];
            [_array addObject:model];
        }];
    }
    [self.tableview reloadData];
}


- (void)addByThink:(HomeslideListingModel *)homeModel {
    WBActivityDetailVC *vc = (WBActivityDetailVC*)[CSUIUtils vcOfCommon:@"idtWBActivityDetailVC"];
    vc.dataId = homeModel.Itemid;
    WBBaseBlackNavigationController *nav = [[WBBaseBlackNavigationController alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:nav animated:false completion:^{
    }];
}


#pragma mark - tableviewCell点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeslideListingModel *homeModel = [_array objectAtIndex:indexPath.section];

    [self addByThink:homeModel];
    /*
    HomeslideListingModel *homeModel = [_array objectAtIndex:indexPath.section];

    
//    WBActivityDetailVC *vc =  [CSUIUtils vcOfCommon:@"idtWBActivityDetailVC"];
//    [vc initWithClosureDetailId:homeModel.Itemid orderBean:NULL closure:^(BOOL) {
//        
//    }];
//    let vc = CSUIUtils.vcOfCommon("idtWBActivityDetailVC") as! WBActivityDetailVC
//    vc.initWithClosureDetailId(bean!.urlId) { (isPurchase) in
//    }
    WBBaseBlackNavigationController *nav = [[WBBaseBlackNavigationController alloc] init];
    [self presentViewController:nav animated:NO completion:^{
        
    }];
     */
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return _array.count;
}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 105.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *cellName = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName];
        
    }
    
    [[cell.contentView viewWithTag:1001] removeFromSuperview];
    cell.backgroundColor = [UIColor clearColor];
    
    HomeslideListingModel *homeModel = [_array objectAtIndex:indexPath.section];
    
    
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(4.5, 0, SELF_VIEW_Width - 9, 105);
    view.tag = 1001;
    [view.layer setCornerRadius:5];
    view.layer.masksToBounds = YES;
    view.backgroundColor = kUIColorFromRGB(0xFFFFFF);

    
//    _pngimageView.layer.masksToBounds = YES;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(12, 16, 75, 75);
    [imageView sd_setImageWithURL:[NSURL URLWithString:homeModel.Itemimg]];
    [view addSubview:imageView];
    
    CGFloat Rect;
    
    Rect = CGRectGetMaxX(imageView.frame) + 14;
    UILabel *Contentlabel = [[UILabel alloc] init];
    Contentlabel.frame = CGRectMake(Rect, 16, SELF_VIEW_Width - Rect - 34, 40);
    Contentlabel.text = homeModel.Itemname;
    Contentlabel.textColor = kUIColorFromRGB(0x000000);
    Contentlabel.lineBreakMode = NSLineBreakByWordWrapping;
    Contentlabel.numberOfLines = 0;
    Contentlabel.font = [UIFont systemFontOfSize:15];
    [view addSubview:Contentlabel];

    CGFloat RectY;
    RectY = CGRectGetMaxY(Contentlabel.frame) + 2;
    
    
    UILabel *vouchersLabel = [[UILabel alloc] init];
    vouchersLabel.frame = CGRectMake(Rect, RectY,200, 12);
    vouchersLabel.text = [NSString stringWithFormat:@"代金券 %@",homeModel.Itemprice];
    vouchersLabel.font = [UIFont systemFontOfSize:12];
    vouchersLabel.textColor = kUIColorFromRGB(0xe95200);
    [view addSubview:vouchersLabel];
    
    RectY = CGRectGetMaxY(vouchersLabel.frame) + 6;
    
    UILabel *rebateLabel = [[UILabel alloc] init];
    rebateLabel.frame = CGRectMake(Rect, RectY,200, 12);
    rebateLabel.text = homeModel.Itemaccount;
    rebateLabel.font = [UIFont systemFontOfSize:12];
    rebateLabel.textColor = kUIColorFromRGB(0xCFA751);
    [view addSubview:rebateLabel];
    
    [cell.contentView addSubview:view];
    
    return cell;
}





- (void)backBtnClick:(UIButton *)btn
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}



- (void)viewWillAppear:(BOOL)animated
{
    // 隐藏导航条
    [self.navigationController setNavigationBarHidden:YES];
    
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

@end
