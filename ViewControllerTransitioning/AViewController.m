//
//  AViewController.m
//  ViewControllerTransitioning
//
//  Created by command.Zi on 16/1/25.
//  Copyright © 2016年 command.Zi. All rights reserved.
//

#import "AViewController.h"
#import <Masonry.h>

@interface AViewController () <UITableViewDelegate,UITableViewDataSource>

@end

@implementation AViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor cyanColor]];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"push" forState:UIControlStateNormal];
    [button setFrame:CGRectMake(0, 100, 100, 100)];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    UITableView * table = [[UITableView alloc]init];
    [table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    // Do any additional setup after loading the view.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = @"AAA";
    return cell;
}


- (IBAction)buttonAction:(id)sender {
    [self.navigationController pushViewController:[AViewController new] animated:YES];
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
