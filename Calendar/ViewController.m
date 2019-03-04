//
//  ViewController.m
//  Calendar
//
//  Created by yiqiang on 16/7/12.
//  Copyright © 2016年 yiqiang. All rights reserved.
//

#import "ViewController.h"
#import "LPCalendarView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    LPCalendarView *calendarView=[[LPCalendarView alloc] init];
    calendarView.frame=CGRectMake(15, 74, [UIScreen mainScreen].bounds.size.width-20, 300);
    calendarView.date=[NSDate date];
    [self.view addSubview:calendarView];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
