//
//  ViewController.m
//  HeadView
//
//  Created by 周祺华 on 2017/3/9.
//  Copyright © 2017年 周祺华. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
{
    CGRect _oldFrame;
    CGRect _newFrame;
    
    UIView *_imageView;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    
    
    
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 200.0)];
    self.tableView.tableHeaderView.backgroundColor = [UIColor greenColor];
    
    _oldFrame = CGRectMake(0, 0, self.tableView.bounds.size.width, 50.0);
    _imageView = [[UIView alloc] initWithFrame:_oldFrame];
    _imageView.backgroundColor = [UIColor blueColor];
    
    [self.view addSubview:_imageView];
    //////////////////////////////////////////////////////////////////////////////////////////////////////
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NSString *info = [NSString stringWithFormat:@"%ld-%ld", (long)indexPath.section, (long)indexPath.row];
    cell.textLabel.text = info;
    
    return cell;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    
    
    if (offsetY < 0) {
        //////////////////////////////////////////////////////////////////////////////////////////////////////
        _newFrame = CGRectMake(0, 0, self.tableView.bounds.size.width, 50.0-offsetY);
        _imageView.frame = _newFrame;
        //////////////////////////////////////////////////////////////////////////////////////////////////////
    }
    else {
        _imageView.frame = _oldFrame;
    }
}




@end
