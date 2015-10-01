//
//  ServiceManager.m
//  Macy
//
//  Created by Durgesh Gupta on 9/30/15.
//  Copyright © 2015 Durgesh Gupta. All rights reserved.
//

#import "DataManager.h"
#import <AFNetworking.h>
#define BASE_URL @"http://www.nactem.ac.uk/software/acromine/dictionary.py"


@implementation DataManager


+ (void)fetchAcronymsForString:(NSString *)string withCompletionHandaler:(CompletionHandler)iHandler
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    NSDictionary *parameter = @{@"sf" : string};
    [manager GET:BASE_URL parameters:parameter success:^(NSURLSessionDataTask *task, id responseData) {
        
        // ((NSArray *)responseData).count is to check if array count is greater than 0;
        if (responseData && ((NSArray *)responseData).count > 0) {
            NSDictionary *dataDict = ((NSDictionary *)responseData[0]);
            iHandler([(NSArray *)dataDict[@"lfs"] mutableCopy], nil);
        }else{
            iHandler (nil, nil);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        NSLog(@"Error %@",error);
        iHandler (nil, error);
    }];

    
}
@end
