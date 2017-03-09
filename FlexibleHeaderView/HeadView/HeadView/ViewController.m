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
    CGRect _oldFrame1;
    CGRect _newFrame1;
    
    UIView *_imageView;
    CGRect _oldFrame2;
    CGRect _newFrame2;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    _oldFrame1 = CGRectMake(0, 0, self.tableView.bounds.size.width, 100.0);
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:_oldFrame1];
    self.tableView.tableHeaderView.backgroundColor = [UIColor greenColor];
    
    _oldFrame2 = CGRectMake(0, 0, self.tableView.bounds.size.width, 50.0);
    _imageView = [[UIView alloc] initWithFrame:_oldFrame2];
    _imageView.backgroundColor = [UIColor blueColor];
    
    [self.view addSubview:_imageView];
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
    NSLog(@"offsetY: %f", offsetY);
    
    if (offsetY < 0) {
        _newFrame1 = CGRectMake(0, 0+offsetY, self.tableView.bounds.size.width, 50.0-offsetY);
        self.tableView.tableHeaderView.frame = _newFrame1;
        // notice that tableHeaderView is fixed in tableView and its frame can not be changed.
        
        _newFrame2 = CGRectMake(0, 0, self.tableView.bounds.size.width, 100.0-offsetY);
        _imageView.frame = _newFrame2;
    }
    else {
        self.tableView.tableHeaderView.frame = _oldFrame1;
        _imageView.frame = _oldFrame2;
    }
}




@end
