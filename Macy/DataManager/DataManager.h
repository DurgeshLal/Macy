//
//  ServiceManager.h
//  Macy
//
//  Created by Durgesh Gupta on 9/30/15.
//  Copyright © 2015 Durgesh Gupta. All rights reserved.
//

typedef void(^CompletionHandler)(id responseData);
#import <Foundation/Foundation.h>


@interface DataManager : NSObject

+(void)fetchAcronymsForString:(NSString *)string withCompletionHandaler:(CompletionHandler)iHandler;

@end
