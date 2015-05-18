//
//  FetchDamStatus.m
//  ThirstyTaiwan
//
//  Created by Mephisto Chu on 5/18/15.
//  Copyright (c) 2015 CinnamonRoll. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DamController.h"

@interface DamController ()

@end

@implementation DamController

-(NSMutableURLRequest *) GetDamStatus:(NSString *) remoteURL
{
    NSMutableURLRequest *rtnRequest = nil;
    NSURL *url = [[NSURL alloc] initWithString: remoteURL];
    //NSURL *url = [[NSURL alloc] initWithString:@"http://128.199.223.114:10080/today"];
    rtnRequest = [NSMutableURLRequest requestWithURL:url];
    [rtnRequest setValue:@"application/json" forHTTPHeaderField:@"accept"];
    [rtnRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    return rtnRequest;
}

@end