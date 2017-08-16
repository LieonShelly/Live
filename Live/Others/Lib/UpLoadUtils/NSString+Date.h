//
//  NSString+Date.h
//  BossApp
//
//  Created by fanfans on 5/31/16.
//  Copyright © 2016 ZDJY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Date)

+(NSString *)getUTCFormateDate:(NSString *)newsDateStr;

+(NSDate *)dateDateStr:(NSString *)dateStr FormateDateStr:(NSString *)formateStr;

/**
    10:00:00 -> 10:00  ps: HH:mm:ss -> HH:mm
 */
+(NSString *)dateHourStrFormDateStr:(NSString *)dateStr;

/**
    10:00 -> 10  ps: mm:ss -> HH
 */
+(NSString *)dateOnlyHourStrFromDataStr:(NSString *)dateStr;

/**
    获取 年月日 ps: 2017-01-03
 */
+(NSString *)dateFormToday;

+(NSString *)dateStrFormTimeInterval:(NSString *)timeIntervalStr andFormatStr:(NSString *)fmtStr;

//+(NSString *)dateStrFromDateStr:(NSString *)dateStr;
//
//+(NSString *)dateDetailStrFromDateStr:(NSString *)dateStr;
//
//+(NSString *)dateDetailStrFromDateStr:(NSString *)dateStr formateStr:(NSString *)formateStr;
//
//+(NSString *)monthDetailStrFromDateStr:(NSString *)dateStr;
//
//+(NSString *)monthAndDayDetailStrFromDateStr:(NSString *)dateStr;
//
//+ (NSString *)onlyMonthDatw:(NSDate *)date;
//
//+(NSString *)yearsAndMonthAndDayDetailStrFromDateStr:(NSString *)dateStr;
//
//+ (NSString *)studyOverViewDay:(NSDate *)date;
//
//+ (NSString *)studyOverViewMonth:(NSDate *)date;
//
//+ (NSString *)studyOverViewVideo:(NSDate *)date;
//
//+ (NSString *)lr_stringDate;

@end
