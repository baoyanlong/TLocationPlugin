//
//  TBaseViewController.m
//  TLocationPlugin
//
//  Created by TBD on 2019/9/5.
//  Copyright © 2019 TBD. All rights reserved.
//

#import "TBaseViewController.h"
#import "NSBundle+TLocationPlugin.h"

@interface TBaseViewController ()

@end

@implementation TBaseViewController

- (instancetype)init {
    return [super initWithNibName:NSStringFromClass(self.class) bundle:NSBundle.t_bundle];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

@end
