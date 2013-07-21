//
//  ViewController.m
//  FrameworkGenerator
//
//  Created by HDBaggyon 03/04/13.
//  Copyright (c) 2013 Logic Engine. All rights reserved.
//

#import "ViewController.h"
#import "AppValidator.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    AppValidator *objAppValidator = [[AppValidator alloc] init];
    [objAppValidator appDidStart];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
