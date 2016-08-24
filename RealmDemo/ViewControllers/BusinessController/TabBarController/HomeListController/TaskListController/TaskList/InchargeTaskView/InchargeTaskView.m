//
//  InchargeTaskView.m
//  RealmDemo
//
//  Created by lottak_mac2 on 16/8/1.
//  Copyright © 2016年 com.luohaifang. All rights reserved.
//

#import "InchargeTaskView.h"
#import "TaskModel.h"
#import "TaskListCell.h"
#import "NoResultView.h"

@interface InchargeTaskView  ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource> {
    UISearchBar *_searchBar;
    NSMutableArray<TaskModel*> *_currArr;
    UITableView *_tableView;
    NoResultView *_noDataView;
}

@end

@implementation InchargeTaskView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _currArr = [@[] mutableCopy];
        //创建搜索框
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, 55)];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"搜索";
        _searchBar.tintColor = [UIColor colorWithRed:247 / 255.f green:247 / 255.f blue:247 / 255.f alpha:1];
        [_searchBar setSearchBarBackgroundColor:[UIColor colorWithRed:247 / 255.f green:247 / 255.f blue:247 / 255.f alpha:1]];
        _searchBar.returnKeyType = UIReturnKeySearch;
        [self addSubview:_searchBar];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, MAIN_SCREEN_WIDTH, frame.size.height - 60) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableView registerNib:[UINib nibWithNibName:@"TaskListCell" bundle:nil] forCellReuseIdentifier:@"TaskListCell"];
        [self addSubview:_tableView];
        _noDataView = [[NoResultView alloc] initWithFrame:_tableView.bounds];
        [self getCurrData];
        [_tableView reloadData];
    }
    return self;
}
- (void)dataDidChange {
    [self getCurrData];
     [_tableView reloadData];
}
- (void)getCurrData {
    [_currArr removeAllObjects];
       for (TaskModel *model in self.data) {
            if([NSString isBlank:_searchBar.text]) {
                [_currArr addObject:model];
            } else {
                if([model.descriptionStr rangeOfString:_searchBar.text].location != NSNotFound)
                    [_currArr addObject:model];
            }
    }
    if(_currArr.count == 0)
        _tableView.tableFooterView = _noDataView;
    else
        _tableView.tableFooterView = [UIView new];
}
#pragma mark -- UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self endEditing:YES];
    [self getCurrData];
    [_tableView reloadData];
}
#pragma mark -- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _currArr.count;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.alpha = 0;
    [UIView animateWithDuration:0.6 animations:^{
        cell.alpha = 1;
    }];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TaskListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaskListCell" forIndexPath:indexPath];
    cell.data = _currArr[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(self.delegate && [self.delegate respondsToSelector:@selector(taskClicked:)]) {
        [self.delegate taskClicked:_currArr[indexPath.row]];
    }
}
@end
