//
//  LPCalendarView.m
//  Calendar
//
//  Created by yiqiang on 16/7/12.
//  Copyright © 2016年 yiqiang. All rights reserved.
//

#import "LPCalendarView.h"

@implementation LPCalendarView
{
    UIButton  *_selectButton;
    NSMutableArray *_daysArray;
    
    UILabel *headlabel;
    
    UIButton *rightButton;
    UIImageView *rightImg;
    
    NSDate *lpDate;
    
    //temPStr
    NSString * nowDayStr;
    NSString * otherDayStr;
}



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _daysArray = [NSMutableArray arrayWithCapacity:42];
        for (int i = 0; i < 42; i++) {
            
            UIButton *button = [[UIButton alloc] init];
            [self addSubview:button];
            [_daysArray addObject:button];
        }
    }
    return self;
}
#pragma mark - create View

//240   220 170
- (void)setDate:(NSDate *)date{
    _date = date;
    [self createCalendarViewWith:date];
}
- (void)createCalendarViewWith:(NSDate *)date{
    
    lpDate=self.date;
    
    CGFloat itemW     = self.frame.size.width / 7;
    CGFloat itemH     = self.frame.size.height / 7;
    
    // 1.year month
    headlabel = [[UILabel alloc] init];
    headlabel.text     = [NSString stringWithFormat:@"%li年%.2li月",[LPCalendarDate year:date],[LPCalendarDate month:date]];
    headlabel.font     = [UIFont systemFontOfSize:14];
    headlabel.frame           = CGRectMake( self.frame.size.width/2-75, 0, 150, itemH);
    headlabel.textAlignment   = NSTextAlignmentCenter;
    [self addSubview:headlabel];
    
    nowDayStr = headlabel.text;
    nowDayStr = [nowDayStr stringByReplacingOccurrencesOfString:@"年" withString:@"-"];
    nowDayStr = [nowDayStr stringByReplacingOccurrencesOfString:@"月" withString:@""];
    otherDayStr = nowDayStr;
    //last month
    UIButton *leftButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    leftButton.frame=CGRectMake(headlabel.frame.origin.x-50, 0, 40, itemH);
    [leftButton addTarget:self action:@selector(clickMonth:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:leftButton];
    
    UIImageView *leftImg=[[UIImageView alloc] initWithFrame:CGRectMake(leftButton.frame.size.width-10, (leftButton.frame.size.height-15)/2, 10, 15)];
    leftImg.image=[UIImage imageNamed:@"leftarr.png"];
    [leftButton addSubview:leftImg];
    
    //next month   if greater than the current month does not show
    rightButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    rightButton.frame=CGRectMake(CGRectGetMaxX(headlabel.frame)+50-itemH, leftButton.frame.origin.y, leftButton.frame.size.width, leftButton.frame.size.height);
    [rightButton addTarget:self action:@selector(clickMonth:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:rightButton];
    
    rightImg=[[UIImageView alloc] initWithFrame:CGRectMake(0, (rightButton.frame.size.height-15)/2, 10, 15)];
    rightImg.image=[UIImage imageNamed:@"rightarr"];
    [rightButton addSubview:rightImg];
    
    // 2.weekday
    NSArray *array = @[@"日", @"一", @"二", @"三", @"四", @"五", @"六"];
    UIView *weekBg = [[UIView alloc] init];
    
    weekBg.frame = CGRectMake(0, CGRectGetMaxY(headlabel.frame), self.frame.size.width, itemH-10);
    weekBg.backgroundColor = [UIColor colorWithRed:230/255.0f green:240/255.0f blue:240/255.0f alpha:0.5];
    [self addSubview:weekBg];

    UILabel * labelTop = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1)];
    labelTop.backgroundColor = [UIColor lightGrayColor];
    [weekBg addSubview:labelTop];
    
    UILabel * labelBottom = [[UILabel alloc]initWithFrame:CGRectMake(0, weekBg.frame.size.height-1, self.frame.size.width, 1)];
    labelBottom.backgroundColor = [UIColor lightGrayColor];
    [weekBg addSubview:labelBottom];
    
    for (int i = 0; i < 7; i++) {
        UILabel *week = [[UILabel alloc] init];
        week.tag = 10010+i;
        week.text     = array[i];
        week.font     = [UIFont systemFontOfSize:12];
        week.frame    = CGRectMake(itemW * i, 0, itemW, 32);
        week.textAlignment   = NSTextAlignmentCenter;
        week.backgroundColor = [UIColor clearColor];
        week.textColor       = [UIColor blackColor];
        [weekBg addSubview:week];
    }
    
    NSInteger daysInLastMonth = [LPCalendarDate totaldaysInMonth:[LPCalendarDate lastMonth:date]];
    NSInteger daysInThisMonth = [LPCalendarDate totaldaysInMonth:date];
    NSInteger firstWeekday    = [LPCalendarDate firstWeekdayInThisMonth:date];
    //  3.days (1-31)
    for (int i = 0; i < 42; i++) {
        
        int x = (i % 7) * itemW ;
        int y = (i / 7) * itemH + CGRectGetMaxY(weekBg.frame);
        
        UIButton *dayButton = _daysArray[i];
        
        dayButton.frame = CGRectMake(x, y, itemW, itemH);
        
        dayButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        dayButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        dayButton.layer.cornerRadius = 5;
        
        [dayButton addTarget:self action:@selector(logDate:) forControlEvents:UIControlEventTouchUpInside];

        NSInteger day = 0;
        
        if (i < firstWeekday) {
            day = daysInLastMonth - firstWeekday + i + 1;
            [self setStyle_BeyondThisMonth:dayButton];
            
        }else if (i > firstWeekday + daysInThisMonth - 1){
            day = i + 1 - firstWeekday - daysInThisMonth;
            [self setStyle_BeyondThisMonth:dayButton];
            
        }else{
            day = i - firstWeekday + 1;
            [self setStyle_AfterToday:dayButton];
        }
        
        [dayButton setTitle:[NSString stringWithFormat:@"%li", day] forState:UIControlStateNormal];
        
        // this month
        NSInteger todayIndex = [LPCalendarDate day:[NSDate date]] + firstWeekday - 1;
        
        if([self judgementMonth] && i ==  todayIndex)
        {
            [self setStyle_Today:dayButton];
            _dayButton = dayButton;
        }else
        {
            dayButton.backgroundColor=[UIColor whiteColor];
        }
        
//        UILabel * labelTag1 = [self viewWithTag:10010];
//        if (CGRectGetMinX(dayButton.frame) == CGRectGetMinX(labelTag1.frame)) {
//            [dayButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
//        }
//
//        UILabel * labelTag2 = [self viewWithTag:10016];
//        if ((int)CGRectGetMinX(dayButton.frame) == (int)CGRectGetMinX(labelTag2.frame)) {
//            [dayButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
//        }
        
        if (i < firstWeekday) {
            [self setStyle_BeyondThisMonth:dayButton];
        }
        if (i >= firstWeekday && i<todayIndex){
            [self setStyle_lastMonthBtnClolor:dayButton];
        }
        
        
    }
}


#pragma mark - date button style
//设置不是本月的日期字体颜色   ---白色  看不到
- (void)setStyle_BeyondThisMonth:(UIButton *)btn
{
    btn.enabled = NO;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)setStyle_AfterToday:(UIButton *)btn
{
    btn.enabled = YES;
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}
-(BOOL) judgementMonth
{
    //获取当前月份
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    formatter.dateFormat=@"MM";
    NSInteger dateMon=[[formatter stringFromDate:[NSDate date]] integerValue];
    
    //获取选择的月份
    NSInteger mon=[[headlabel.text substringFromIndex:5] integerValue];
    
    if (mon==dateMon)
    {
        return YES;
    }else
        return NO;
}
- (void)setStyle_Today:(UIButton *)btn
{
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor colorWithRed:94/255.0 green:169/255.0 blue:251/255.0 alpha:1]];
}

- (void)setStyle_lastMonthBtnClolor:(UIButton *)btn{
    btn.enabled = NO;
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor whiteColor]];
}

-(void) clickMonth:(UIButton *)btn
{

    NSInteger curttenMonth = [self getcurrenMonth];
    NSString * headLabelStr;
    if (btn==rightButton)
    {
        lpDate=[LPCalendarDate nextMonth:lpDate];
    }else
    {
        lpDate=[LPCalendarDate lastMonth:lpDate];
        NSDate *date=lpDate;
        int conpare;
        NSString * tempStr = [NSString stringWithFormat:@"%li-%li",[LPCalendarDate year:date],[LPCalendarDate month:date]];
        conpare = [self compareOneStr:nowDayStr withanotherStr:tempStr];
        if (conpare == 1) {
            lpDate = self.date;
            return;
        }
    }
    
    NSDate *date=lpDate;
    headLabelStr = [NSString stringWithFormat:@"%li-%li",[LPCalendarDate year:date],[LPCalendarDate month:date]];
    otherDayStr = headLabelStr;
    
    headlabel.text = headLabelStr;
    
    NSInteger daysInLastMonth = [LPCalendarDate totaldaysInMonth:[LPCalendarDate lastMonth:date]];
    NSInteger daysInThisMonth = [LPCalendarDate totaldaysInMonth:date];
    NSInteger firstWeekday    = [LPCalendarDate firstWeekdayInThisMonth:date];
    
    NSInteger todayIndex = [LPCalendarDate day:[NSDate date]] + firstWeekday - 1;
    
    for (int i = 0; i < 42; i++) {
        
        UIButton *dayButton = _daysArray[i];
        
        NSInteger day = 0;
        
        if (i < firstWeekday) {
            day = daysInLastMonth - firstWeekday + i + 1;
            [self setStyle_BeyondThisMonth:dayButton];//设置不显示多余的日期
            
        }else if (i > firstWeekday + daysInThisMonth - 1){
            day = i + 1 - firstWeekday - daysInThisMonth;
            [self setStyle_BeyondThisMonth:dayButton];
            
        }else{
            day = i - firstWeekday + 1;
            [self setStyle_AfterToday:dayButton];
        }
        
        [dayButton setTitle:[NSString stringWithFormat:@"%li", day] forState:UIControlStateNormal];
        
        // this month
        if([self judgementMonth] && i ==  todayIndex)
        {
            [self setStyle_Today:dayButton];
            _dayButton = dayButton;
        }else
        {
            dayButton.backgroundColor=[UIColor whiteColor];
        }
        
        //点击左按钮
        
        if (btn  != rightButton && curttenMonth == [LPCalendarDate month:date]) {
            if (i < firstWeekday) {
                [self setStyle_BeyondThisMonth:dayButton];
            }
            if (i >= firstWeekday && i<todayIndex){
                [self setStyle_lastMonthBtnClolor:dayButton];
            }
        }
    }
    

}

- (void)logDate:(UIButton*)sender
{
    NSString * curtenStr = [NSString stringWithFormat:@"%@-%@",otherDayStr,sender.titleLabel.text];
    NSLog(@"curtenStr %@",curtenStr);
}

- (int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay

{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    
    NSComparisonResult result = [dateA compare:dateB];
    
//    NSLog(@"date1 : %@, date2 : %@", oneDay, anotherDay);
    
    if (result == NSOrderedDescending) {
        return 1;
    }
    else if (result ==NSOrderedAscending){
        return -1;
    }
 return 0;
    
    
}

- (NSInteger) getcurrenMonth
{
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    // 获取当前日期
    NSDate* dt = [NSDate date];
    // 定义一个时间字段的旗标，指定将会获取指定年、月、日、时、分、秒的信息
    unsigned unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |  NSCalendarUnitDay |
    NSCalendarUnitHour |  NSCalendarUnitMinute |
    NSCalendarUnitSecond | NSCalendarUnitWeekday;
    // 获取不同时间字段的信息
    NSDateComponents* comp = [gregorian components: unitFlags
                                          fromDate:dt];
    // 获取各时间字段的数值
    NSLog(@"现在是%ld年" , comp.year);
    NSLog(@"现在是%ld月 " , comp.month);
    return comp.month;
}

- (int)compareOneStr:(NSString *)oneStr withanotherStr:(NSString *)anotherStr

{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
    [dateFormatter setDateFormat:@"yyyy-MM"];
//    dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
//    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
//
//    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    
    NSDate *dateA = [dateFormatter dateFromString:oneStr];
    
    NSDate *dateB = [dateFormatter dateFromString:anotherStr];
    
    NSComparisonResult result = [dateA compare:dateB];
    
    NSLog(@"date1 : %@, date2 : %@", dateA, dateB);
    
    if (result == NSOrderedDescending) {
        return 1;
    }
    else if (result ==NSOrderedAscending){
        return -1;
    }
    return 0;
    
    
}
@end
