//
//  ViewController.m
//  GHFontListDemo
//
//  Created by Ghost on 2020/4/15.
//  Copyright © 2020 Ghost. All rights reserved.
//

#import "ViewController.h"
#import "GHFontListVC.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)_btnShowClick:(id)sender {
    [GHFontListVC presentFontListFromVC:self];
}


@end
