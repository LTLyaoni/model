//
//  NSString+LTLCode.m
//  StandardProject
//
//  Created by 123 on 2017/11/10.
//  Copyright © 2017年 teaxus. All rights reserved.
//

#import "NSString+LTLCode.h"

@implementation NSString (LTLCode)
-(NSString*)decode
{
    return [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
-(NSString*)code
{
    return [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end
