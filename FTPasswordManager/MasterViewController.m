//
//  MasterViewController.m
//  FTPasswordManager
//
//  Created by fountain on 16/1/26.
//  Copyright © 2016年 com.fountain. All rights reserved.
//

#import "MasterViewController.h"
#import "Password.h"
#import "PasswordDetails.h"
#import "FTImageSaver.h"
#import "FTPasswordViewController.h"
#import "FTSearchBar.h"

@interface MasterViewController ()<UISearchBarDelegate>

@property (nonatomic, strong) NSMutableArray *passwordsArray;
@property (nonatomic, strong)FTSearchBar *searchBar;
@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"密码小熊";
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:124/255.0 green:207/255.0 blue:249/255.0 alpha:0.8];

    // 必须先注册UITableViewCell class
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.scrollEnabled = YES;
   
    // 设置按钮
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 80, 20, 70, 44)];
    UIButton *collectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    collectButton.frame = CGRectMake(20, 0, 50, 40);
    [collectButton setTitle:@"+" forState:UIControlStateNormal];
    [collectButton addTarget:self action:@selector(addNewPsd) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:collectButton];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    self.navigationItem.rightBarButtonItem = barItem;
}


#pragma mark - viewWillAppear 
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self fetchAllPassword];
    [self.tableView reloadData];
}

#pragma mark -tableViewDelegate & dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.passwordsArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FTPasswordViewController *viewController = [[FTPasswordViewController alloc] init];
    Password *password = self.passwordsArray[indexPath.row];
    viewController.password = password;
    [self.navigationController pushViewController:viewController animated:YES];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.backgroundColor = [UIColor clearColor];
     cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    _searchBar = [[FTSearchBar alloc] initWithFrame:CGRectMake(30, 5, SCREEN_WIDTH - 60, 30)];
    _searchBar.translucent = NO;
    _searchBar.layer.cornerRadius = 10;
    _searchBar.clipsToBounds = YES;
    _searchBar.placeholder = @"搜索标题";
    _searchBar.backgroundColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:0.8];
    _searchBar.bgSearchImage = nil;
    _searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    _searchBar.delegate = self;
    return _searchBar;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0f;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Password *passwordToMove = self.passwordsArray[indexPath.row];
        if (passwordToMove.passwordDetails.image) {
            [FTImageSaver deleteImageAtPath:passwordToMove.passwordDetails.image];
        }
        [passwordToMove deleteEntity];
        [self saveContext];
        [self.passwordsArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark -other
- (void)saveContext {
    [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
}

- (void)addNewPsd {
    FTPasswordViewController *psdViewController = [[FTPasswordViewController alloc] init];
    psdViewController.isDelete = @"no";
    [self.navigationController pushViewController:psdViewController animated:YES];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Password *psd = self.passwordsArray[indexPath.row];
    cell.textLabel.text = psd.title;
}

- (void)fetchAllPassword {
    self.passwordsArray = [[Password findAll] mutableCopy];
}


#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([self.searchBar.text length] > 0) {
        [self doSearch];
    } else {
        [self fetchAllPassword];
        [self.tableView reloadData];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
    self.searchBar.text = @"";
    self.searchBar.showsCancelButton = NO;
    [self fetchAllPassword];
    [self.tableView reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
    [self doSearch];
}

- (void)doSearch {
    NSString *searchText = self.searchBar.text;
    self.passwordsArray = [[Password findAllWithPredicate:[NSPredicate predicateWithFormat:@"title contains[c] %@", searchText] inContext:[NSManagedObjectContext defaultContext]] mutableCopy];
                        
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
