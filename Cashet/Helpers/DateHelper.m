//
//  DateHelper.m
//  ChalkTalk
//
//  Created by Daniel Rodríguez on 4/14/16.
//  Copyright © 2016 ChalkTalk. All rights reserved.
//

#import "DateHelper.h"

@implementation DateHelper

+ (NSString*)UTFStringFromDate:(NSDate*)date
{
    [NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehavior10_4];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:NSTimeZoneNameStyleStandard];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    
    return [formatter stringFromDate:date];
}

@end
