//
//  NSString+Date.m
//  BossApp
//
//  Created by fanfans on 5/31/16.
//  Copyright © 2016 ZDJY. All rights reserved.
//

#import "NSString+Date.h"

@implementation NSString (Date)

#pragma mark - 当前项目的
+(NSString *)dateHourStrFormDateStr:(NSString *)dateStr{
    NSDateFormatter *formate = [[NSDateFormatter alloc]init];
    formate.dateFormat = @"HH:mm:ss";
    NSDate *beginDate  = [formate dateFromString:dateStr];
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    fmt.dateFormat = @"HH:mm:ss";
    NSString *monthAndDayStr = [fmt stringFromDate:beginDate];
    return monthAndDayStr;
}

+(NSDate *)dateDateStr:(NSString *)dateStr FormateDateStr:(NSString *)formateStr{
    NSDate *beginDate  = [NSDate dateWithTimeIntervalSince1970:dateStr.longLongValue/1000];
//    NSDateFormatter *formate = [[NSDateFormatter alloc]init];
//    formate.dateFormat = formateStr;
//    NSDate *date  = [formate dateFromString:dateStr];
    return beginDate;
}

/** 获取昨天，前天 逻辑*/
+(NSString *)getUTCFormateDate:(NSString *)newsDateStr{
    
    NSString *dateContent;
    NSDate *beginDate  = [NSDate dateWithTimeIntervalSince1970:newsDateStr.longLongValue/1000];
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today=[[NSDate alloc] init];
    NSDate *yearsterDay =  [[NSDate alloc] initWithTimeIntervalSinceNow:-secondsPerDay];
    NSDate *qianToday =  [[NSDate alloc] initWithTimeIntervalSinceNow:-2*secondsPerDay];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:beginDate];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:yearsterDay];
    NSDateComponents* comp3 = [calendar components:unitFlags fromDate:qianToday];
    NSDateComponents* comp4 = [calendar components:unitFlags fromDate:today];
    if ( comp1.year == comp2.year && comp1.month == comp2.month && comp1.day == comp2.day) {
        NSDateFormatter *formate = [[NSDateFormatter alloc]init];
        formate.dateFormat = @"HH:mm";
        dateContent = [NSString stringWithFormat:@"昨天 %@",[formate stringFromDate:beginDate]];
    }
    else if (comp1.year == comp3.year && comp1.month == comp3.month && comp1.day == comp3.day)
    {
        NSDateFormatter *formate = [[NSDateFormatter alloc]init];
        formate.dateFormat = @"HH:mm";
        dateContent = [NSString stringWithFormat:@"前天 %@",[formate stringFromDate:beginDate]];
    }
    else if (comp1.year == comp4.year && comp1.month == comp4.month && comp1.day == comp4.day)
    {
        NSDateFormatter *formate = [[NSDateFormatter alloc]init];
        formate.dateFormat = @"HH:mm";
        dateContent = [NSString stringWithFormat:@"%@",[formate stringFromDate:beginDate]];
    }
    else
    {
        NSDateFormatter *formate = [[NSDateFormatter alloc]init];
        formate.dateFormat = @"yyyy-MM-dd HH:mm";
        dateContent = [NSString stringWithFormat:@"%@",[formate stringFromDate:beginDate]];
    }
    return dateContent;
}

+(NSString *)dateOnlyHourStrFromDataStr:(NSString *)dateStr{
    NSDateFormatter *formate = [[NSDateFormatter alloc]init];
    formate.dateFormat = @"HH:mm";
    NSDate *beginDate  = [formate dateFromString:dateStr];
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    fmt.dateFormat = @"HH:mm";
    NSString *monthAndDayStr = [fmt stringFromDate:beginDate];
    return monthAndDayStr;
}

+(NSString *)dateFormToday{
    NSDate *now = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    fmt.dateFormat = @"yyyy/MM/dd";
    NSString *str = [fmt stringFromDate:now];
    return str;
}

+(NSString *)dateStrFormTimeInterval:(NSString *)timeIntervalStr andFormatStr:(NSString *)fmtStr{
    long long int timeInterval = timeIntervalStr.longLongValue;
    long long int f = timeInterval/1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:f];
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    fmt.dateFormat = fmtStr;
    NSString *monthAndDayStr = [fmt stringFromDate:date];
    return monthAndDayStr;
}

#pragma mark - 上个项目的
+(NSString *)dateStrFromDateStr:(NSString *)dateStr{
    NSDateFormatter *formate = [[NSDateFormatter alloc]init];
    formate.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *beginDate  = [formate dateFromString:dateStr];
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    fmt.dateFormat = @"HH:mm";
    NSString *monthAndDayStr = [fmt stringFromDate:beginDate];
    return monthAndDayStr;
}

+(NSString *)dateDetailStrFromDateStr:(NSString *)dateStr{
    NSDateFormatter *formate = [[NSDateFormatter alloc]init];
    formate.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *beginDate  = [formate dateFromString:dateStr];
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    fmt.dateFormat = @"yyyy/MM/dd HH:mm";
    NSString *monthAndDayStr = [fmt stringFromDate:beginDate];
    return monthAndDayStr;
}

+(NSString *)dateDetailStrFromDateStr:(NSString *)dateStr formateStr:(NSString *)formateStr{
    NSDateFormatter *formate = [[NSDateFormatter alloc]init];
    formate.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *beginDate  = [formate dateFromString:dateStr];
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    fmt.dateFormat = formateStr;
    NSString *monthAndDayStr = [fmt stringFromDate:beginDate];
    return monthAndDayStr;
}

+(NSString *)monthDetailStrFromDateStr:(NSString *)dateStr{
    NSDateFormatter *formate = [[NSDateFormatter alloc]init];
    formate.dateFormat = @"yyyy-MM-dd";
    NSDate *beginDate  = [formate dateFromString:dateStr];
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    fmt.dateFormat = @"MM";
    NSString *monthAndDayStr = [fmt stringFromDate:beginDate];
    return monthAndDayStr;
}

+(NSString *)monthAndDayDetailStrFromDateStr:(NSString *)dateStr{
    NSDateFormatter *formate = [[NSDateFormatter alloc]init];
    formate.dateFormat = @"yyyy-MM-dd";
    NSDate *beginDate  = [formate dateFromString:dateStr];
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    fmt.dateFormat = @"MM月dd日";
    NSString *monthAndDayStr = [fmt stringFromDate:beginDate];
    return monthAndDayStr;
}


+ (NSString *)onlyMonthDatw:(NSDate *)date{
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    fmt.dateFormat = @"MM月";
    NSString *month = [fmt stringFromDate:date];
    return month;
}


+(NSString *)yearsAndMonthAndDayDetailStrFromDateStr:(NSString *)dateStr{
    NSDateFormatter *formate = [[NSDateFormatter alloc]init];
    formate.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *beginDate  = [formate dateFromString:dateStr];
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    fmt.dateFormat = @"yyyy年MM月dd日";
    NSString *monthAndDayStr = [fmt stringFromDate:beginDate];
    return monthAndDayStr;
}


+ (NSString *)studyOverViewDay:(NSDate *)date{
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    fmt.dateFormat = @"MM月dd日";
    NSString *month = [fmt stringFromDate:date];
    return month;
}

+ (NSString *)studyOverViewMonth:(NSDate *)date{
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    fmt.dateFormat = @"MM月";
    NSString *month = [fmt stringFromDate:date];
    return month;
}

+ (NSString *)studyOverViewVideo:(NSDate *)date{
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *month = [fmt stringFromDate:date];
    return month;
}

+ (NSString *)lr_stringDate{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    return dateString;
}

@end
