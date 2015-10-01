//
//  ServiceManager.m
//  Macy
//
//  Created by Durgesh Gupta on 9/30/15.
//  Copyright © 2015 Durgesh Gupta. All rights reserved.
//

#import "DataManager.h"
#import <AFNetworking.h>
#define BASE_URL @"http://www.nactem.ac.uk/software/acromine/dictionary.py?sf="


@implementation DataManager


+ (void)fetchAcronymsForString:(NSString *)string withCompletionHandaler:(CompletionHandler)iHandler
{
    
    NSString *urlString = [BASE_URL stringByAppendingString:string];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    
    [manager GET:urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseData) {
        NSDictionary *dataDict = ((NSDictionary *)responseData[0]);
        iHandler([(NSArray *)dataDict[@"lfs"] mutableCopy]);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        NSLog(@"Error %@",error);
    }];

    
}
@end
