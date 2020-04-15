//
//  GHFontListVC.m
//  GHFontListDemo
//
//  Created by Ghost on 2020/4/15.
//  Copyright © 2020 Ghost. All rights reserved.
//

#import "GHFontListVC.h"

static NSString *const kGHFontListFamilyNameKey = @"family_name";
static NSString *const kGHFontListFontNameKey = @"font_name";

@interface GHFontListVC () <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) NSArray    *fontList;
@property(nonatomic, strong) NSArray    *fontListTitle;
@property(nonatomic, strong) NSArray    *fontListIndex;

@end

@implementation GHFontListVC

+ (void)presentFontListFromVC:(UIViewController*)vc {
    GHFontListVC *fontlistVC = [[GHFontListVC alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:fontlistVC];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [vc presentViewController:nav animated:YES completion:^{
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Font List";
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 100.0f;
    self.tableView = tableView;
    
    [self _addSubView:tableView toView:self.view insets:UIEdgeInsetsZero];
    
    UIBarButtonItem *closeButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemClose target:self action:@selector(_closeBtnClick)];
    self.navigationItem.leftBarButtonItem = closeButtonItem;
    
    [self _reloadFonts];
}

- (void)_reloadFonts {
    
    NSMutableArray *arrayFont = [NSMutableArray array];
    // 获取父类名称
    NSArray *familyNames = [UIFont familyNames];
    for (NSString *familyName in familyNames) {
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:familyName forKey:kGHFontListFamilyNameKey];
        NSMutableArray    *array = [NSMutableArray array];
        // 获取具体名字
        NSArray *fontNames = [UIFont fontNamesForFamilyName:familyName];
        for( NSString *fontName in fontNames){
            [array addObject:fontName];
        }
        [dict setObject:array forKey:kGHFontListFontNameKey];
        [arrayFont addObject:dict];
    }
    [arrayFont sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSString *str1,*str2;
        //类型转换
        str1 = [obj1 objectForKey:kGHFontListFamilyNameKey];
        str2 = [obj2 objectForKey:kGHFontListFamilyNameKey];
        return  [str1 localizedCompare:str2];
    }];
    self.fontList = [NSArray arrayWithArray:arrayFont];
    
    NSMutableArray *arrayFontIndex = [NSMutableArray array];
    NSMutableArray *arrayFontTitle = [NSMutableArray array];
    for (int i = 0; i < arrayFont.count; i++) {
        NSString *familyName = arrayFont[i][kGHFontListFamilyNameKey];
        NSString *pre = [familyName substringToIndex:1];
        if (![arrayFontTitle containsObject:pre]) {
            [arrayFontTitle addObject:pre];
            [arrayFontIndex addObject:@(i)];
        }
    }
    self.fontListIndex = [NSArray arrayWithArray:arrayFontIndex];
    self.fontListTitle = [NSArray arrayWithArray:arrayFontTitle];
}

- (void)_addSubView:(UIView*)subView toView:(UIView*)toView insets:(UIEdgeInsets)insets {
    [toView addSubview:subView];
    subView.translatesAutoresizingMaskIntoConstraints = NO;
    [toView addConstraints:@[
        [NSLayoutConstraint constraintWithItem:subView
                                     attribute:NSLayoutAttributeLeading
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:toView
                                     attribute:NSLayoutAttributeLeading
                                    multiplier:1.0f
                                      constant:insets.left],
        [NSLayoutConstraint constraintWithItem:subView
                                     attribute:NSLayoutAttributeTop
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:toView
                                     attribute:NSLayoutAttributeTop
                                    multiplier:1.0f
                                      constant:insets.top],
        [NSLayoutConstraint constraintWithItem:subView
                                     attribute:NSLayoutAttributeTrailing
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:toView
                                     attribute:NSLayoutAttributeTrailing
                                    multiplier:1.0f
                                      constant:insets.right],
        [NSLayoutConstraint constraintWithItem:subView
                                     attribute:NSLayoutAttributeBottom
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:toView
                                     attribute:NSLayoutAttributeBottom
                                    multiplier:1.0f
                                      constant:insets.bottom]
    ]];
}

#pragma mark - Btn Click
- (void)_closeBtnClick {
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _fontList.count;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return _fontListTitle;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    NSNumber *numSection = _fontListIndex[index];
    return [numSection integerValue];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_fontList[section][kGHFontListFontNameKey] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"FontListCell" ;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier] ;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    NSString *strFontName = _fontList[indexPath.section][kGHFontListFontNameKey][indexPath.row];
    [cell.textLabel setFont:[UIFont fontWithName:strFontName size:30.0f]];
    [cell.textLabel setText:@"abc&ABC&123\n中华人民共和国"];
    [cell.textLabel setNumberOfLines:0];
    
    [cell.detailTextLabel setText:strFontName];
    return cell;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    UILabel *label = [[UILabel alloc] init];
    label.text = _fontList[section][kGHFontListFamilyNameKey];
    [self _addSubView:label toView:view insets:UIEdgeInsetsMake(0.0f, 15.0f, 0.0f, 15.0f)];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0f;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *strFontName = _fontList[indexPath.section][kGHFontListFontNameKey][indexPath.row];
    NSLog(@"select font name = %@",strFontName);
}

@end
